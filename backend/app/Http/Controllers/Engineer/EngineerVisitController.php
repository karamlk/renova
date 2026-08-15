<?php

namespace App\Http\Controllers\Engineer;

use App\Http\Controllers\Controller;
use App\Models\SiteVisit;
use App\Services\Engineer\EngineerVisitService;
use App\Services\NotificationService;
use App\Services\SiteVisitService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class EngineerVisitController extends Controller
{
    protected $siteVisitService;
    protected $notificationService;

    public function __construct(SiteVisitService $siteVisitService, NotificationService  $notificationService)
    {
        $this->siteVisitService = $siteVisitService;
        $this->notificationService = $notificationService;
    }

    // ج) قبول أو رفض الزيارة من المهندس نفسه
   public function respondToVisit(Request $request): JsonResponse
{
    $request->validate([
        'visit_id' => 'required|exists:site_visits,id',
        'status'   => 'required|in:accepted,rejected',
    ]);

    $visit = $this->siteVisitService->updateVisitStatusByEngineer(
        auth()->user(),
        $request->visit_id,
        $request->status
    );

    // إشعار الأدمن بقرار المهندس
    if ($request->status === 'accepted') {
        $this->notificationService->engineerAcceptedVisit(
            visitId:      $visit->id,
            engineerName: auth()->user()->name,
        );
    } else {
        $this->notificationService->engineerRejectedVisit(
            visitId:      $visit->id,
            engineerName: auth()->user()->name,
        );
    }

    return response()->json(['message' => 'تم تحديث حالة طلب الزيارة بنجاح.']);
}


    public function index(
        Request $request,
        EngineerVisitService $service
    )
    {
        return response()->json([

            'data' =>

                $service->index(
                    $request->status
                )

        ]);
    }
    public function show(
        SiteVisit $visit,
        EngineerVisitService $service
    )
    {
        return response()->json([

            'data'=>

                $service->show($visit)

        ]);
    }

}
