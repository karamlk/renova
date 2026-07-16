<?php

namespace App\Services\Complaint;

use App\Models\Complaint;
use App\Models\ComplaintImage;
use App\Models\ConstructionForm;
use App\Models\Role;
use App\Models\Wallet;
use App\Services\WalletService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class ComplaintService
{
    public function __construct(
        protected WalletService $walletService
    ) {}

    // ─────────────────────────────────────────────────────
    // رفع شكوى جديدة
    // ─────────────────────────────────────────────────────
    public function file(Request $request): Complaint
    {
        $complainant     = Auth::user();
        $complainantRole = $complainant->role; // Role model
        $data = $request->validated();

        // فقط user و contractor يمكنهم رفع شكوى
        abort_if(
            !in_array($complainantRole->name, ['user', 'contractor']),
            403,
            'غير مصرح لك برفع شكوى'
        );

        // جلب الاستمارة
        $form = ConstructionForm::findOrFail($data['construction_form_id']);

        // التأكد أن المشتكي طرف في هذا المشروع
        $customerId   = $form->reconstructionRequest->user_id;
        $contractorId = $form->contractor_id;

        abort_if(
            !in_array($complainant->id, [$customerId, $contractorId]),
            403,
            'لست طرفاً في هذا المشروع'
        );

        // تحديد المشكو عليه تلقائياً — الطرف الآخر في المشروع
        if ($complainantRole->name === 'user') {
            $complainedOnId   = $contractorId;
            $complainedOnRole = Role::where('name', 'contractor')->firstOrFail();
        } else {
            $complainedOnId   = $customerId;
            $complainedOnRole = Role::where('name', 'user')->firstOrFail();
        }

        $complaint = Complaint::create([
            'complainant_id'        => $complainant->id,
            'complained_on_id'      => $complainedOnId,
            'construction_form_id'  => $form->id,
            'complainant_role_id'   => $complainantRole->id,
            'complained_on_role_id' => $complainedOnRole->id,
            'type'                  => $data['type'] ?? 'general',
            'reason'                => $data['reason'],
            'description'           => $data['description'] ?? null,
            'status'                => 'open',
        ]);

        $this->storeImages(
            $request,
            $complaint
        );

        return $complaint->load('images');
    }

    // ─────────────────────────────────────────────────────
    // شكاوي المستخدم الحالي
    // ─────────────────────────────────────────────────────
    public function getForUser()
    {
        $userId = Auth::id();

        return Complaint::with([
            'complainant',
            'complainedOn',
            'constructionForm',
            'images'
        ])
            ->where(function ($q) use ($userId) {
                $q->where('complainant_id', $userId)
                    ->orWhere('complained_on_id', $userId);
            })
            ->latest()
            ->get();
    }

    // ─────────────────────────────────────────────────────
    // كل الشكاوي للأدمن
    // ─────────────────────────────────────────────────────
    public function getForAdmin()
    {
        return Complaint::with([
            'complainant',
            'complainedOn' => function ($query) {
                $query->withCount([
                    'complaintsReceived as complaints_count'
                ]);
            },
            'constructionForm',
            'images'
        ])->latest()->get();
    }

    // ─────────────────────────────────────────────────────
    // الأدمن يحل الشكوى
    // ─────────────────────────────────────────────────────
    public function resolve(Complaint $complaint, array $data): Complaint
    {
        return DB::transaction(function () use ($complaint, $data) {

            $penaltyPercentage = $data['penalty_percentage'] ?? null;

            if ($penaltyPercentage && $complaint->construction_form_id) {

                $form = ConstructionForm::findOrFail($complaint->construction_form_id);

                // المبلغ المحجوز = 30% من التكلفة الكلية
                $heldAmount    = $form->total_cost * 0.30;
                $penaltyAmount = $heldAmount * ($penaltyPercentage / 100);

                // TODO: make the warrenty as a date to use it here
                $customerId   = $form->reconstructionRequest->user_id;

                // TODO: make sure the admin id is always 1
                $adminWallet = Wallet::whereHas('user.role', fn($q) => $q->where('name', 'admin'))->firstOrFail();
                $customerWallet   = Wallet::where('user_id', $customerId)->firstOrFail();

                $this->walletService->withdraw(
                    $adminWallet,
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

            $complaint->status                = $data['status'];
            $complaint->admin_processing_note = $data['admin_processing_note'] ?? null;
            $complaint->resolved_at           = now();
            $complaint->save();

            return $complaint->fresh();
        });
    }

    private function storeImages(
        Request $request,
        Complaint $complaint
    ): void {

        if (!$request->hasFile('images')) {
            return;
        }

        foreach ($request->file('images') as $image) {

            $path = $image->store(
                'complaints',
                'public'
            );

            ComplaintImage::create([

                'complaint_id' => $complaint->id,

                'image' => $path,
            ]);
        }
    }
}
