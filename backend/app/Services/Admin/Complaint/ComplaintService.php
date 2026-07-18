<?php

namespace App\Services\Admin\Complaint;

use App\Http\Resources\Complaint\ComplaintDetailsResource;
use App\Http\Resources\Complaint\ComplaintResource;
use App\Http\Resources\Complaint\NoShowWarningResource;
use App\Models\Complaint;
use App\Models\ComplaintImage;
use App\Models\ConstructionForm;
use App\Models\NoShowWarning;
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

    private const ROLE_MAP = [
        'user' => 2,
        'contractor' => 3,
        'engineer' => 4,
    ];

    public function getAllComplaints(array $filters)
    {
        $complaints = collect();

        $warnings = collect();

        if (
            !isset($filters['type']) ||
            $filters['type'] === 'general'
        ) {

            $complaints = $this
                ->buildComplaintQuery($filters, false)
                ->get()
                ->map(function ($complaint) {

                    $complaint->complaint_type = 'general';

                    return (new ComplaintResource($complaint))->resolve();
                });
        }

        if (
            !isset($filters['type']) ||
            $filters['type'] === 'no_show'
        ) {

            $warnings = $this
                ->buildNoShowWarningQuery($filters, false)
                ->get()
                ->map(function ($warning) {

                    $warning->complaint_type = 'no_show';

                    return (new NoShowWarningResource($warning))->resolve();
                });
        }

        return $complaints
            ->concat($warnings)
            ->sortByDesc('created_at')
            ->values();
    }

    public function getArchivedComplaints(array $filters)
    {
        $complaints = collect();

        $warnings = collect();

        if (
            !isset($filters['type']) ||
            $filters['type'] === 'general'
        ) {

            $complaints = $this
                ->buildComplaintQuery($filters, true)
                ->get()
                ->map(function ($complaint) {

                    $complaint->complaint_type = 'general';

                    return (new ComplaintResource($complaint))->resolve();
                });
        }

        if (
            !isset($filters['type']) ||
            $filters['type'] === 'no_show'
        ) {

            $warnings = $this
                ->buildNoShowWarningQuery($filters, true)
                ->get()
                ->map(function ($warning) {

                    $warning->complaint_type = 'no_show';

                    return (new NoShowWarningResource($warning))->resolve();
                });
        }

        return $complaints
            ->concat($warnings)
            ->sortByDesc('created_at')
            ->values();
    }

    public function archiveComplaint(Complaint $complaint): ComplaintDetailsResource
    {
        $complaint->update([
            'is_archived' => true,
            'archived_at' => now(),
        ]);

        $complaint->load([
            'complainant',
            'complainedOn' => function ($query) {
                $query->withCount('complaintsReceived as complaints_count');
            },
            'constructionForm.reconstructionRequest',
            'images',
        ]);

        return new ComplaintDetailsResource($complaint);
    }


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
        $complaints = Complaint::with([
            'complainant',
            'complainedOn' => function ($query) {
                $query->withCount([
                    'complaintsReceived as complaints_count'
                ]);
            },
            'constructionForm',
            'images'
        ])->latest()->get();

        return ComplaintResource::collection($complaints);
    }


    public function getComplaintDetails(Complaint $complaint): ComplaintDetailsResource
    {
        $complaint->load([
            'complainant',
            'complainedOn' => function ($query) {
                $query->withCount(['complaintsReceived as complaints_count']);
            },
            'constructionForm.reconstructionRequest',
            'images',
        ]);

        $complaint->complainant?->load(['profile', 'contractorProfile', 'engineerProfile']);
        $complaint->complainedOn?->load(['profile', 'contractorProfile', 'engineerProfile']);

        return new ComplaintDetailsResource($complaint);
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

    private function buildComplaintQuery(array $filters, bool $archived)
    {
        $query = Complaint::with([
            'complainant',
            'complainedOn' => function ($query) {
                $query->withCount('complaintsReceived as complaints_count');
            },
            'constructionForm',
            'images',
        ])
            ->where('is_archived', $archived);

        if (!empty($filters['complained_on_role'])) {

            $roles = collect(explode(',', $filters['complained_on_role']))
                ->map(fn($role) => self::ROLE_MAP[$role])
                ->toArray();

            $query->whereIn('complained_on_role_id', $roles);
        }

        return $query;
    }

    private function buildNoShowWarningQuery(array $filters, bool $archived)
    {
        $query = NoShowWarning::with([
            'reporter',
            'reported' => function ($query) {
                $query->withCount('noShowWarnings as complaints_count');
            },
        ])
            ->where('is_archived', $archived);

        if (!empty($filters['complained_on_role'])) {

            $roles = collect(explode(',', $filters['complained_on_role']))
                ->map(fn($role) => self::ROLE_MAP[$role])
                ->toArray();

            $query->whereIn('reported_role_id', $roles);
        }

        return $query;
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
