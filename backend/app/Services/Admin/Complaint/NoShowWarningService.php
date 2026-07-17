<?php

namespace App\Services\Admin\Complaint;

use App\Http\Resources\Complaint\NoShowWarningDetailsResource;
use App\Http\Resources\Complaint\NoShowWarningResource;
use App\Models\NoShowWarning;
use App\Models\SiteVisit;
use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class NoShowWarningService
{

    public function getAllNoShowWarnings()
    {
        $warnings = NoShowWarning::with([
            'reporter',
            'reported' => function ($query) {
                $query->withCount('noShowWarnings as complaints_count');
            },
            'siteVisit.inspectionRequest.request',
        ])
            ->latest()
            ->get();

        return NoShowWarningResource::collection($warnings);
    }

    public function getNoShowWarningDetails(NoShowWarning $noShowWarning): NoShowWarningDetailsResource
    {
        $noShowWarning->load([
            'reporter',
            'reported' => function ($query) {
                $query->withCount('noShowWarnings as complaints_count');
            },
            'siteVisit.inspectionRequest.request.user',
            'siteVisit.inspectionRequest.contractor',
        ]);

        $noShowWarning->reporter?->load(['profile', 'contractorProfile', 'engineerProfile']);
        $noShowWarning->reported?->load(['profile', 'contractorProfile', 'engineerProfile']);

        return new NoShowWarningDetailsResource ($noShowWarning);
    }


    public function archiveNoShowWarning(NoShowWarning $warning): NoShowWarningDetailsResource
    {
        $warning->update([
            'is_archived' => true,
            'archived_at' => now(),
        ]);

        $warning->load([
            'reporter',
            'reported' => function ($query) {
                $query->withCount('noShowWarnings as complaints_count');
            },
            'siteVisit.inspectionRequest.request.user',
            'siteVisit.inspectionRequest.contractor',
        ]);

        return new NoShowWarningDetailsResource($warning);
    }

    public function report(int $siteVisitId, int $reportedId): NoShowWarning
    {
        return DB::transaction(function () use ($siteVisitId, $reportedId) {

            $reporter = Auth::user();

            // جلب الزيارة مع جدول المتعهد وطلب الفحص
            $siteVisit = SiteVisit::with([
                'schedule',
                'inspectionRequest.request',
            ])->findOrFail($siteVisitId);

            // ── 1. التحقق من حالة الزيارة ────────────────────────────────
            // يجب أن تكون الزيارة مقبولة أو مكتملة
            abort_if(
                !in_array($siteVisit->status, ['accepted', 'completed']),
                422,
                'لا يمكن تقديم بلاغ غياب على زيارة لم تُقبل بعد'
            );

            // ── 2. التحقق من وقت انتهاء الزيارة ─────────────────────────
            // نتحقق أن وقت الآن تجاوز end_time في جدول المتعهد
            $endTime = Carbon::parse($siteVisit->schedule->end_time);
            $now     = Carbon::now();

            // TODO: عندما يضيف المتعهد عمود التاريخ (visit_date) لجدول site_visits
            // استبدل هذا الكود بالتالي:
            // $visitDate = Carbon::parse($siteVisit->visit_date);
            // $endDateTime = $visitDate->setTimeFrom($endTime);
            // abort_if(
            //     $now->lessThan($endDateTime),
            //     422,
            //     'لا يمكن تقديم بلاغ الغياب قبل انتهاء وقت الزيارة'
            // );
            //
            // في الوقت الحالي نتحقق من الوقت فقط بدون التاريخ (نفس اليوم)
            abort_if(
                $now->format('H:i:s') < $siteVisit->schedule->end_time,
                422,
                'لا يمكن تقديم بلاغ الغياب قبل انتهاء وقت الزيارة'
            );

            // ── 3. التحقق أن المُبلِّغ طرف في هذه الزيارة ───────────────
            $contractorId = $siteVisit->inspectionRequest->contractor_id;
            $customerId   = $siteVisit->inspectionRequest->request->user_id;
            $engineerId   = $siteVisit->engineer_id;

            $validParticipants = array_filter([
                $contractorId,
                $customerId,
                $engineerId, // المهندس قد يكون null
            ]);

            abort_if(
                !in_array($reporter->id, $validParticipants),
                403,
                'لست طرفاً في هذه الزيارة'
            );

            // ── 4. التحقق أن المُبلَّغ عنه طرف في هذه الزيارة ──────────
            abort_if(
                !in_array($reportedId, $validParticipants),
                422,
                'الشخص المُبلَّغ عنه ليس طرفاً في هذه الزيارة'
            );

            // ── 5. منع الإبلاغ على النفس ─────────────────────────────────
            abort_if(
                $reporter->id === $reportedId,
                422,
                'لا يمكنك الإبلاغ على نفسك'
            );

            // ── 6. منع تكرار الإبلاغ من نفس الشخص على نفس الشخص في نفس الزيارة ──
            abort_if(
                NoShowWarning::where('site_visit_id', $siteVisitId)
                    ->where('reporter_id', $reporter->id)
                    ->where('reported_id', $reportedId)
                    ->exists(),
                422,
                'لقد أبلغت عن هذا الشخص في هذه الزيارة مسبقاً'
            );

            // ── 7. جلب role_id للطرفين ────────────────────────────────────
            $reporterRoleId = $reporter->role_id;
            $reportedUser   = User::findOrFail($reportedId);
            $reportedRoleId = $reportedUser->role_id;

            // ── 8. إنشاء التحذير ──────────────────────────────────────────
            $warning = NoShowWarning::create([
                'site_visit_id'   => $siteVisitId,
                'reporter_id'     => $reporter->id,
                'reported_id'     => $reportedId,
                'reporter_role_id' => $reporterRoleId,
                'reported_role_id' => $reportedRoleId,
                'type'            => 'no_show',
                'reason'          => 'عدم الحضور إلى الزيارة الميدانية',
                'description'     => "عدم حضور المستخدم إلى الزيارة الميدانية رقم ({$siteVisitId})",
                'penalty_applied' => false,
            ]);

            // ── 9. التحقق من عدد التحذيرات غير المعاقب عليها ────────────
            $unpunishedCount = NoShowWarning::where('reported_id', $reportedId)
                ->where('penalty_applied', false)
                ->count();

            // عند بلوغ 3 تحذيرات → تعطيل الحساب
            if ($unpunishedCount >= 3) {
                $this->deactivateAccount($reportedId);
            }

            return $warning->fresh();
        });
    }

    private function deactivateAccount(int $reportedId): void
    {
        // تعطيل حساب المستخدم
        User::where('id', $reportedId)->update(['is_active' => false]);

        // تعليم كل التحذيرات غير المعاقب عليها كـ penalty_applied
        // حتى تبدأ الدورة من جديد إذا أُعيد تفعيل الحساب لاحقاً
        NoShowWarning::where('reported_id', $reportedId)
            ->where('penalty_applied', false)
            ->update(['penalty_applied' => true]);
    }
}
