<?php

namespace App\Services;

use App\Models\SiteVisit;
use App\Models\User;
use Illuminate\Support\Facades\Log;

class SiteVisitService
{
    public function contractorVisits()
    {
        return SiteVisit::with([
            'inspectionRequest.request',
            'schedule'
        ])
            ->whereHas(
                'inspectionRequest',
                function ($query) {

                    $query->where(
                        'contractor_id',
                        auth()->id()
                    );
                }
            )
            ->get();
    }

    public function userVisits()
    {
        return SiteVisit::with([
            'inspectionRequest.contractor',
            'schedule'
        ])
            ->whereHas(
                'inspectionRequest.request',
                function ($query) {

                    $query->where(
                        'user_id',
                        auth()->id()
                    );
                }
            )
            ->get();
    }

    /**
     * 1. جلب المهندسين المتاحين (غير المشغولين)
     * المهندس يعتبر "مشغول" إذا كان لديه زيارة حالتها 'accepted' (مقبولة وتحت التنفيذ حالياً)
     */
    public function getAvailableEngineers()
    {
        return User::where('role_id', 4) // رول المهندس تبعا لمشروعكِ
        ->whereDoesntHave('engineerVisits', function ($query) {
            $query->where('status', 'accepted'); // إذا عنده زيارة جارية فهو مشغول
        })
            ->with('engineerProfile') // جلب البروفايل العادي معهم
            ->get();
    }

    /**
     * 2. فرز مهندس لزيارة ميدانية بواسطة الآدمن
     */
    public function assignEngineerToVisit(int $visitId, int $engineerId): SiteVisit
    {
        $visit = SiteVisit::findOrFail($visitId);

    // Check the assigned user actually has the engineer role
        $engineer = User::findOrFail($engineerId);

        abort_if(
            $engineer->role->name !== 'engineer',
            422,
            'المستخدم المحدد ليس مهندساً'
        );

        $visit->update([
            'engineer_id' => $engineerId,
            'status' => 'pending' // تعود قيد الانتظار حتى يوافق المهندس المفرز حديثاً
        ]);

        return $visit;
    }

    /**
     * 3. تحديث حالة الزيارة من قِبل المهندس (قبول أو رفض)
     */
    public function updateVisitStatusByEngineer(
        User $engineer,
        int $visitId,
        string $status
    ): SiteVisit {

        $visit = SiteVisit::where('id', $visitId)
            ->where('engineer_id', $engineer->id)
            ->where('status', 'pending')
            ->firstOrFail();

        if (in_array($status, ['accepted', 'rejected'])) {

            $visit->update([
                'status' => $status
            ]);

            if ($status === 'accepted') {

                $contractor = $visit->schedule->contractor;

                if ($contractor) {

                    // إشعار الويب - لا نغير نظامه
                    event(new \App\Events\AppEvent(
                        $contractor->id,
                        'تم تعيين مهندس للزيارة',
                        'تم تعيين مهندس للقيام بزيارة الموقع.',
                        'site_visit',
                        'site-visits',
                        $visit->id
                    ));

                    // إشعار الموبايل FCM
                    if ($contractor->fcm_token) {

                        app(
                            \App\Services\FirebaseNotificationService::class
                        )->send(
                            $contractor->fcm_token,
                            'تم تعيين مهندس للزيارة',
                            'تم تعيين مهندس للقيام بزيارة الموقع.',
                            [
                                'type' => 'site_visit',
                                'target_path' => 'site-visits',
                                'related_id' => (string) $visit->id,
                            ]
                        );
                    }
                }
            }
        }

        return $visit->fresh();
    }
    /**
     * جلب الزيارات الميدانية المعلقة (التي بلا مهندس أو التي رُفضت من المهندسين)
     */
    public function getUnassignedOrRejectedVisits()
    {
        return \App\Models\SiteVisit::whereNull('engineer_id')
            ->orWhere('status', 'rejected')
            ->with([
                'inspectionRequest'=> function($query) {
                $query->with([
                   'contractor',
                    'request'=>function($query){
                    $query->with('user');
                    }
                    ]);
            },
                'engineer.profile','schedule',]) // شحن العلاقات لمعرفة تفاصيل الطلب والمهندس الذي رفض إن وجد
            ->get();
    }

}

