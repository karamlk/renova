<?php

namespace App\Services\Complaint;

use App\Models\ConstructionForm;
use App\Models\NoShowWarning;
use App\Models\SiteVisit;
use App\Models\Wallet;
use App\Services\WalletService;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class NoShowWarningService
{
    public function __construct(
        protected WalletService $walletService
    ) {}

    public function report(int $siteVisitId): NoShowWarning
    {
        return DB::transaction(function () use ($siteVisitId) {

            $reporterId = Auth::id();

            $siteVisit = SiteVisit::with([
                'inspectionRequest.request'
            ])->findOrFail($siteVisitId);

            $contractorId = $siteVisit->inspectionRequest->contractor_id;
            $customerId   = $siteVisit->inspectionRequest->request->user_id;

            // التأكد أن من يبلغ هو أحد طرفي الزيارة
            abort_if(
                !in_array($reporterId, [$contractorId, $customerId]),
                403,
                'لست طرفاً في هذه الزيارة'
            );

            // من يبلغ → الطرف الآخر هو المتغيب تلقائياً
            if ($reporterId === $contractorId) {
                $reportedId   = $customerId;
                $reportedRole = 'user';
            } else {
                $reportedId   = $contractorId;
                $reportedRole = 'contractor';
            }

            // منع التكرار — شخص واحد لا يبلغ مرتين عن نفس الزيارة
            abort_if(
                NoShowWarning::where('site_visit_id', $siteVisitId)
                    ->where('reporter_id', $reporterId)
                    ->exists(),
                422,
                'لقد أبلغت عن هذه الزيارة مسبقاً'
            );

            // TODO align the sitevist status 
            
            // إنشاء التحذير
            $warning = NoShowWarning::create([
                'site_visit_id'   => $siteVisitId,
                'reporter_id'     => $reporterId,
                'reported_id'     => $reportedId,
                'reported_role'   => $reportedRole,
                'penalty_applied' => false,
            ]);

            // عدد التحذيرات غير المعاقب عليها لهذا الشخص
            $unpunishedCount = NoShowWarning::where('reported_id', $reportedId)
                ->where('penalty_applied', false)
                ->count();

            // عند بلوغ تحذيرين غير معاقب عليهما → تطبيق العقوبة
            if ($unpunishedCount >= 2) {
                $this->applyPenalty(
                    $reportedId,
                    $reportedRole,
                    $siteVisitId,
                    $siteVisit
                );
            }

            return $warning->fresh();
        });
    }

    private function applyPenalty(
        int $reportedId,
        string $reportedRole,
        int $siteVisitId,
        SiteVisit $siteVisit
    ): void {

        $penaltyAmount = config('renova.no_show_penalty_amount', 10);

        // محفظة الأدمن — وجهة كل الغرامات
        $adminWallet = Wallet::where('user_id', 1)->firstOrFail();

        // جلب الاستمارة المعتمدة إن وجدت
        $reconstructionRequestId = $siteVisit->inspectionRequest->request->id;

        $form = ConstructionForm::where('reconstruction_request_id', $reconstructionRequestId)
            ->where('status', 'user_approved')
            ->first();

        if ($reportedRole === 'contractor') {
            if ($form) {
                $contractorWallet = Wallet::where('user_id', $reportedId)->firstOrFail();
                $this->walletService->withdraw(
                    $contractorWallet,
                    $penaltyAmount,
                    "غرامة غياب متعهد عن زيارة #{$siteVisitId}"
                );
            }
            $this->walletService->deposit(
                $adminWallet,
                $penaltyAmount,
                "استلام غرامة غياب متعهد عن زيارة #{$siteVisitId}"
            );
        } else {
            // user
            if ($form) {
                $userWallet = Wallet::where('user_id', $reportedId)->firstOrFail();
                $this->walletService->withdraw(
                    $userWallet,
                    $penaltyAmount,
                    "غرامة غياب مستخدم عن زيارة #{$siteVisitId}"
                );
                $this->walletService->deposit(
                    $adminWallet,
                    $penaltyAmount,
                    "استلام غرامة غياب مستخدم عن زيارة #{$siteVisitId}"
                );
            }
            // إذا لا يوجد مشروع معتمد → لا تتحرك أموال
        }

        // تعليم كل التحذيرات غير المعاقب عليها لهذا الشخص كـ penalty_applied
        // حتى يبدأ العداد من جديد للمستقبل
        NoShowWarning::where('reported_id', $reportedId)
            ->where('penalty_applied', false)
            ->update([
                'penalty_applied' => true,
                'penalty_amount'  => $form ? $penaltyAmount : 0,
            ]);
    }
}
