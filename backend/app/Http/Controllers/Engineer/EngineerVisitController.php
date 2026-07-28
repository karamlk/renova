<?php

namespace App\Http\Controllers\Engineer;

use App\Http\Controllers\Controller;
use App\Models\SiteVisit;
use App\Services\Engineer\EngineerVisitService;
use App\Services\SiteVisitService;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class EngineerVisitController extends Controller
{
    protected $siteVisitService;

    public function __construct(SiteVisitService $siteVisitService)
    {
        $this->siteVisitService = $siteVisitService;
    }

    // ج) قبول أو رفض الزيارة من المهندس نفسه
    public function respondToVisit(Request $request): JsonResponse
    {
        $request->validate([
            'visit_id' => 'required|exists:site_visits,id',
            'status'   => 'required|in:accepted,rejected',
        ]);

        $this->siteVisitService->updateVisitStatusByEngineer
        (auth()->user(), $request->visit_id, $request->status);

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
