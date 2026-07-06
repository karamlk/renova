<?php

namespace App\Services\Complaint;

use App\Models\Complaint;
use App\Models\ConstructionForm;
use App\Models\Wallet;
use App\Services\WalletService;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class ComplaintService
{
    public function __construct(
        protected WalletService $walletService
    ) {}

    // ─────────────────────────────────────────────────────
    // الأسباب الثابتة 
    // ─────────────────────────────────────────────────────
    public function getReasons(): array
    {
        return [
            'user_vs_contractor' => [
                ['key' => 'timeline_breach', 'label' => 'عدم الالتزام بالجدول الزمني'],
                ['key' => 'poor_quality',    'label' => 'رداءة جودة العمل'],
            ],
            'user_vs_engineer' => [
                ['key' => 'timeline_breach',        'label' => 'عدم الالتزام بالجدول الزمني'],
                ['key' => 'inappropriate_behavior', 'label' => 'سلوك غير لائق'],
            ],
            'contractor_vs_user' => [
                ['key' => 'late_payment',        'label' => 'التأخر في الدفع'],
                ['key' => 'lack_of_cooperation', 'label' => 'عدم التعاون'],
            ],
            'contractor_vs_engineer' => [
                ['key' => 'negligence', 'label' => 'إهمال في العمل'],
                ['key' => 'absence',    'label' => 'عدم الالتزام بالحضور'],
            ],
            'engineer_vs_contractor' => [
                ['key' => 'unpaid_dues',        'label' => 'عدم صرف المستحقات'],
                ['key' => 'unsafe_environment', 'label' => 'بيئة عمل غير آمنة'],
            ],
            'engineer_vs_user' => [
                ['key' => 'inappropriate_behavior', 'label' => 'سلوك غير لائق'],
                ['key' => 'lack_of_cooperation',    'label' => 'عدم التعاون'],
            ],
        ];
    }

    // ─────────────────────────────────────────────────────
    // رفع شكوى جديدة
    // ─────────────────────────────────────────────────────
    public function file(array $data): Complaint
    {
        $user = Auth::user();
        $complainantRole = $user->role->name; // 'user', 'contractor', 'engineer'

        // بناء مفتاح التركيبة
        $key = "{$complainantRole}_vs_{$data['complained_on_role']}";

        // التحقق من أن السبب صالح لهذه التركيبة
        $validReasons = array_column(
            $this->getReasons()[$key] ?? [],
            'key'
        );

        abort_if(
            !in_array($data['reason'], $validReasons),
            422,
            'السبب المختار غير صالح لهذه الشكوى'
        );

        // منع الشكوى على النفس
        abort_if(
            $user->id === (int) $data['complained_on_id'],
            422,
            'لا يمكنك تقديم شكوى على نفسك'
        );

        return Complaint::create([
            'complainant_id'       => $user->id,
            'complained_on_id'     => $data['complained_on_id'],
            'construction_form_id' => $data['construction_form_id'] ?? null,
            'complainant_role'     => $complainantRole,
            'complained_on_role'   => $data['complained_on_role'],
            'reason'               => $data['reason'],
            'description'          => $data['description'] ?? null,
            'is_anonymous'         => $data['is_anonymous'] ?? false,
            'status'               => 'open',
        ]);
    }

    // ─────────────────────────────────────────────────────
    // جلب الشكاوي للمستخدم الحالي مع إخفاء الهوية
    // ─────────────────────────────────────────────────────
   public function getForUser()
{
    $userId = Auth::id();

    return Complaint::with([
        'complainant',
        'complainedOn',
        'constructionForm',
    ])
    ->where(function ($q) use ($userId) {
        $q->where('complainant_id', $userId)
          ->orWhere('complained_on_id', $userId);
    })
    ->latest()
    ->get() 
    ->map(function ($complaint) use ($userId) { 
        // إذا كان المستخدم هو المشكو عليه والشكوى مجهولة → أخفِ الهوية
        if (
            $complaint->complained_on_id === $userId &&
            $complaint->is_anonymous
        ) {
            $complaint->complainant = null;
        }
        return $complaint;
    });
}


    // ─────────────────────────────────────────────────────
    // جلب كل الشكاوي للأدمن — يرى كل شيء
    // ─────────────────────────────────────────────────────
    public function getForAdmin()
    {
        return Complaint::with([
            'complainant',
            'complainedOn',
            'constructionForm',
        ])->latest()->paginate(20);
    }

    // ─────────────────────────────────────────────────────
    // الأدمن يحل الشكوى
    // ─────────────────────────────────────────────────────
    public function resolve(Complaint $complaint, array $data): Complaint
    {
        return DB::transaction(function () use ($complaint, $data) {

            $penaltyPercentage = $data['penalty_percentage'] ?? null;

            // العقوبة المالية فقط بين user و contractor
            if (
                $penaltyPercentage &&
                $this->isFinancial($complaint) &&
                $complaint->construction_form_id
            ) {
                $form = ConstructionForm::findOrFail($complaint->construction_form_id);

                // المبلغ المحجوز = 30% من التكلفة الكلية
                $heldAmount    = $form->total_cost * 0.30;
                $penaltyAmount = $heldAmount * ($penaltyPercentage / 100);

                // تحديد المتعهد والمستخدم من الاستمارة مباشرة
                $contractorId = $form->contractor_id;
                $customerId   = $form->reconstructionRequest->user_id;

                $contractorWallet = Wallet::where('user_id', $contractorId)->firstOrFail();
                $customerWallet   = Wallet::where('user_id', $customerId)->firstOrFail();

                // خصم من محفظة المتعهد → تعويض للمستخدم
                $this->walletService->withdraw(
                    $contractorWallet,
                    $penaltyAmount,
                    "خصم عقوبة شكوى #{$complaint->id}"
                );

                $this->walletService->deposit(
                    $customerWallet,
                    $penaltyAmount,
                    "تعويض من شكوى #{$complaint->id}"
                );

                $complaint->penalty_percentage  = $penaltyPercentage;
                $complaint->penalty_amount      = $penaltyAmount;
                $complaint->compensation_amount = $penaltyAmount;
            }

            $complaint->status      = $data['status'];
            $complaint->admin_note  = $data['admin_note'] ?? null;
            $complaint->resolved_at = now();
            $complaint->save();

            return $complaint->fresh();
        });
    }

    // ─────────────────────────────────────────────────────
    // هل الشكوى بين user و contractor (مالية)
    // ─────────────────────────────────────────────────────
    private function isFinancial(Complaint $complaint): bool
    {
        $roles = [$complaint->complainant_role, $complaint->complained_on_role];
        return in_array('user', $roles) && in_array('contractor', $roles);
    }
}