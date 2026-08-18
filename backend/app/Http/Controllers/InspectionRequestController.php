<?php

namespace App\Http\Controllers;

use App\Http\Requests\User\AcceptInspectionRequest;
use App\Models\InspectionRequest;
use App\Models\ReconstructionRequest;
use App\Services\Contractor\InspectionRequestService;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\JsonResponse;

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

        $reconstructionRequest = ReconstructionRequest::with('user')
            ->findOrFail($request->reconstruction_request_id);

        $user = $reconstructionRequest->user;
        // تسجيل الإشعار في قاعدة البيانات
        event(new \App\Events\AppEvent(
            $user->id,
            'طلب زيارة جديد',
            'لديك طلب زيارة متعلق بطلب إعادة الإعمار الخاص بك.',
            'inspection_request',
            'inspections',
            $inspection->id
        ));
        // إرسال Push Notification
        if ($user->fcm_token) {

            app(
                \App\Services\FirebaseNotificationService::class
            )->send(
                $user->fcm_token,

                'طلب زيارة جديد',

                'لديك طلب زيارة متعلق بطلب إعادة الإعمار الخاص بك.',

                [
                    'type' =>
                        'inspection_request',

                    'target_path' =>
                        'inspections',

                    'related_id' =>
                        (string) $inspection->id,
                ]
            );
        }

        return response()->json([

            'message' =>
                'تم إرسال طلب الزيارة',

            'data' => $inspection
        ]);
    }

    // كل طلبات الزيارة لطلب معين
    public function requestInspections()
    {
        return response()->json([
            'data' => $this->inspectionService
                ->requestInspections()
        ]);
    }
   // protected InspectionRequestService $inspectionRequestService;
    // قبول
    public function accept(
        AcceptInspectionRequest $request
    ): JsonResponse
    {

        $this->inspectionService
            ->accept(
                $request->validated()
            );

        return response()->json([
            'message' => 'تم قبول طلب الزيارة وتحديد الموعد'
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
    public function userOffers(): JsonResponse
    {
        return response()->json([
            'data' => $this->inspectionService
                ->userOffers()
        ]);
    }

}
