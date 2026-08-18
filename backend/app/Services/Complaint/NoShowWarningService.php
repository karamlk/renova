<?php

namespace App\Services\Complaint;

use App\Models\NoShowWarning;
use App\Models\SiteVisit;
use App\Models\User;
use App\Services\NotificationService;
use Carbon\Carbon;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;

class NoShowWarningService
{
    public function __construct(
        protected NotificationService $notificationService
    ) {}
    // ─────────────────────────────────────────────────
    // الإبلاغ عن غياب
    // الفرونت يرسل: site_visit_id + reported_role
    // الباك يجد reported_id تلقائياً من المشاركين
    // ─────────────────────────────────────────────────
    public function report(int $siteVisitId, string $reportedRole): NoShowWarning
    {
        return DB::transaction(function () use ($siteVisitId, $reportedRole) {

            $reporter = Auth::user();

            $siteVisit = SiteVisit::with([
                'schedule',
                'inspectionRequest.request',
            ])->findOrFail($siteVisitId);

            // ── 1. التحقق من حالة الزيارة ────────────────────────────────
            abort_if(
                !in_array($siteVisit->status, ['accepted', 'completed']),
                422,
                'لا يمكن تقديم بلاغ غياب على زيارة لم تُقبل بعد'
            );

            // ── 2. التحقق أن تاريخ الزيارة محدد وأن وقتها قد انتهى فعلاً ──
            abort_if(
                is_null($siteVisit->visit_date),
                422,
                'تاريخ الزيارة غير محدد'
            );

            $visitEndsAt = Carbon::parse(
                $siteVisit->visit_date->format('Y-m-d') . ' ' . $siteVisit->schedule->end_time
            );

            abort_if(
                Carbon::now()->lt($visitEndsAt),
                422,
                'لا يمكن تقديم بلاغ الغياب قبل انتهاء وقت الزيارة'
            );
            
            // ── 3. تحديد المشاركين في الزيارة ───────────────────────────
            $contractorId = $siteVisit->inspectionRequest->contractor_id;
            $customerId   = $siteVisit->inspectionRequest->request->user_id;
            $engineerId   = $siteVisit->engineer_id;

            $validParticipants = array_filter([
                $contractorId,
                $customerId,
                $engineerId,
            ]);

            // ── 4. التحقق أن المُبلِّغ طرف في الزيارة ───────────────────
            abort_if(
                !in_array($reporter->id, $validParticipants),
                403,
                'لست طرفاً في هذه الزيارة'
            );

            // ── 5. إيجاد reported_id من الدور المُرسَل ───────────────────
            $reportedId = match ($reportedRole) {
                'contractor' => $contractorId,
                'user'       => $customerId,
                'engineer'   => $engineerId,
                default      => abort(422, 'الدور المحدد غير صالح'),
            };

            abort_if(
                is_null($reportedId),
                422,
                'لا يوجد مهندس مفرز لهذه الزيارة'
            );

            // ── 6. منع الإبلاغ على النفس ─────────────────────────────────
            abort_if(
                $reporter->id === $reportedId,
                422,
                'لا يمكنك الإبلاغ على نفسك'
            );

            // ── 7. التحقق أن المُبلَّغ عنه طرف في الزيارة ───────────────
            abort_if(
                !in_array($reportedId, $validParticipants),
                422,
                'الشخص المُبلَّغ عنه ليس طرفاً في هذه الزيارة'
            );

            // ── 8. منع تكرار الإبلاغ ─────────────────────────────────────
            abort_if(
                NoShowWarning::where('site_visit_id', $siteVisitId)
                    ->where('reporter_id', $reporter->id)
                    ->where('reported_id', $reportedId)
                    ->exists(),
                422,
                'لقد أبلغت عن هذا الشخص في هذه الزيارة مسبقاً'
            );

            // ── 9. جلب role_id للطرفين ────────────────────────────────────
            $reporterRoleId = $reporter->role_id;
            $reportedUser   = User::findOrFail($reportedId);
            $reportedRoleId = $reportedUser->role_id;

            // ── 10. إنشاء التحذير ─────────────────────────────────────────
            $warning = NoShowWarning::create([
                'site_visit_id'    => $siteVisitId,
                'reporter_id'      => $reporter->id,
                'reported_id'      => $reportedId,
                'reporter_role_id' => $reporterRoleId,
                'reported_role_id' => $reportedRoleId,
                'type'             => 'no_show',
                'reason'           => 'عدم الحضور إلى الزيارة الميدانية',
                'description'      => "عدم حضور المستخدم إلى الزيارة الميدانية رقم ({$siteVisitId})",
                'penalty_applied'  => false,
            ]);

            $this->notificationService->newNoShowWarning(
                warningId: $warning->id,
                reporterName: Auth::user()->name,
            );

            // ── 11. التحقق من عدد التحذيرات غير المعاقب عليها ───────────
            $unpunishedCount = NoShowWarning::where('reported_id', $reportedId)
                ->where('penalty_applied', false)
                ->count();

            if ($unpunishedCount >= 3) {
                $this->deactivateAccount($reportedId);
            }

            return $warning->fresh();
        });
    }

    // ─────────────────────────────────────────────────
    // تحذيرات أبلغ عنها المستخدم الحالي فقط
    // ─────────────────────────────────────────────────
    public function getForUser()
    {
        return NoShowWarning::with([
            'reported',
            'reporterRole',
            'reportedRole',
            'siteVisit.inspectionRequest.request',
        ])
            ->where('reporter_id', Auth::id())
            ->latest()
            ->get();
    }

    // ─────────────────────────────────────────────────
    // تفاصيل تحذير واحد — للمستخدم الذي أبلغ فقط
    // ─────────────────────────────────────────────────
    public function show(NoShowWarning $warning): array
    {
        abort_if(
            $warning->reporter_id !== Auth::id(),
            403,
            'غير مصرح لك بعرض هذا التحذير'
        );

        $warning->load([
            'reported:id,name',
            'reporterRole:id,name',
            'reportedRole:id,name',
            'siteVisit.schedule:id,day_of_week,start_time,end_time',
        ]);

        return [
            'id'              => $warning->id,
            'reason'          => $warning->reason,
            'description'     => $warning->description,
            'type'            => $warning->type,
            'penalty_applied' => $warning->penalty_applied,
            'created_at'      => $warning->created_at,
            'reported' => [
                'name' => $warning->reported->name,
                'role' => $warning->reportedRole->name,
            ],
            'site_visit' => [
                'id'     => $warning->siteVisit->id,
                'status' => $warning->siteVisit->status,
                'schedule' => [
                    'day'        => $warning->siteVisit->schedule->day_of_week,
                    'start_time' => $warning->siteVisit->schedule->start_time,
                    'end_time'   => $warning->siteVisit->schedule->end_time,
                ],
            ],
        ];
    }

    private function deactivateAccount(int $reportedId): void
    {
        User::where('id', $reportedId)->update(['is_active' => false]);

        NoShowWarning::where('reported_id', $reportedId)
            ->where('penalty_applied', false)
            ->update(['penalty_applied' => true]);
    }
}
