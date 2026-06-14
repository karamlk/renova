<?php

namespace App\Services\Contractor;

use App\Models\ContractorSchedule;
use App\Models\InspectionRequest;
use App\Models\SiteVisit;
use Carbon\Carbon;

class InspectionRequestService
{
    // إنشاء طلب زيارة
    public function store($request)
    {
        return InspectionRequest::create([

            'reconstruction_request_id' =>
                $request->reconstruction_request_id,

            'contractor_id' =>
                auth()->id(),
        ]);
    }

    // طلبات طلب معين
    public function requestInspections($requestId)
    {
        return InspectionRequest::with([

            'contractor.contractorProfile'
        ])
            ->where(
                'reconstruction_request_id',
                $requestId
            )
            ->latest()
            ->get();
    }

    // قبول
    public function accept(array $data)
    {
        $inspection = InspectionRequest::findOrFail(
            $data['inspection_request_id']
        );
        SiteVisit::create([
            'inspection_request_id' => $inspection->id,
            'schedule_id' => $data['schedule_id'],
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


        $inspection->update([

            'status' => 'rejected'
        ]);

        return $inspection;
    }

}
