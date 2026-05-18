<?php

namespace App\Http\Controllers;

use App\Services\Contractor\InspectionRequestService;
use Illuminate\Http\Request;

class InspectionRequestController
    extends Controller
{
    public function __construct(
        protected InspectionRequestService
        $inspectionService
    ) {}

    // طلب زيارة
    public function store(Request $request)
    {
        $request->validate([

            'reconstruction_request_id' =>
                'required|exists:reconstruction_requests,id'
        ]);

        $inspection =
            $this->inspectionService
                ->store($request);

        return response()->json([

            'message' =>
                'تم إرسال طلب الزيارة',

            'data' => $inspection
        ]);
    }

    // كل طلبات الزيارة لطلب معين
    public function requestInspections($id)
    {
        return response()->json([

            'data' =>
                $this->inspectionService
                    ->requestInspections($id)
        ]);
    }

    // قبول
    public function accept($id)
    {
        $inspection =
            $this->inspectionService
                ->accept($id);

        return response()->json([

            'message' =>
                'تم قبول طلب الزيارة',

            'data' => $inspection
        ]);
    }

    // رفض
    public function reject($id)
    {
        $inspection =
            $this->inspectionService
                ->reject($id);

        return response()->json([

            'message' =>
                'تم رفض طلب الزيارة',

            'data' => $inspection
        ]);
    }
}
