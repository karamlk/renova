<?php

namespace App\Services\Contractor;

use App\Models\ContractorSchedule;
use App\Models\InspectionRequest;
use App\Models\ReconstructionRequest;
use App\Models\SiteVisit;
use App\Services\NotificationService;
use Carbon\Carbon;

class InspectionRequestService
{
    public function __construct(
        protected NotificationService $notificationService
    ) {}

    public function store($request)
    {
        $exists = InspectionRequest::where(
            'reconstruction_request_id',
            $request->reconstruction_request_id
        )
            ->where('contractor_id', auth()->id())
            ->exists();

        if ($exists) {
            abort(422, 'لقد أرسلت عرضاً لهذا الطلب مسبقاً');
        }

        $inspection = InspectionRequest::create([
            'reconstruction_request_id' => $request->reconstruction_request_id,
            'contractor_id'             => auth()->id(),
        ]);

        // جلب عنوان الطلب للإشعار
        $reconstructionRequest = ReconstructionRequest::find(
            $request->reconstruction_request_id
        );

        $this->notificationService->newInspectionRequest(
            inspectionRequestId: $inspection->id,
            contractorName: auth()->user()->name,
            requestTitle: $reconstructionRequest->title,
        );

        return $inspection;
    }
    // طلبات طلب معين
    public function requestInspections()
    {

        return ReconstructionRequest::with([
            'inspectionRequests',
            'inspectionRequests.contractor'
        ])
            ->whereHas('inspectionRequests')
            ->get();
    }



    public function userOffers()
    {
        return InspectionRequest::with([
            'contractor',
            'request'
        ])->where('status', 'pending')
            ->get();
    }


    // قبول
    public function accept(array $data)
    {
        $inspection = InspectionRequest::findOrFail(
            $data['inspection_request_id']
        );

        if ($inspection->request->user_id !== auth()->id()) {
            abort(403, 'غير مصرح');
        }

        $schedule = ContractorSchedule::findOrFail($data['schedule_id']);

        SiteVisit::create([
            'inspection_request_id' => $inspection->id,
            'schedule_id'           => $schedule->id,
            'visit_date'            => Carbon::now()
                ->next($schedule->day_of_week)
                ->format('Y-m-d'),
        ]);

        $inspection->update([
            'status' => 'accepted'
        ]);

        return $inspection;
    }

    // رفض
    public function reject($id)
    {
        $inspection =
            InspectionRequest::findOrFail($id);

        if ($inspection->request->user_id !== auth()->id()) {
            abort(403, 'غير مصرح');
        }

        $inspection->update([

            'status' => 'rejected'
        ]);

        return $inspection;
    }
}
