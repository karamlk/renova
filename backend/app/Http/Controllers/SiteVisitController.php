<?php

namespace App\Http\Controllers;

use App\Services\SiteVisitService;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\JsonResponse;

class SiteVisitController extends Controller
{
    public function __construct(
        private SiteVisitService $siteVisitService
    ) {}
    //
    public function contractorVisits(): JsonResponse
    {
        return response()->json([
            'data' => $this->siteVisitService
                ->contractorVisits()
        ]);
    }

    public function userVisits(): JsonResponse
    {
        return response()->json([
            'data' => $this->siteVisitService
                ->userVisits()
        ]);
    }
    public function availableEngineers(): JsonResponse
    {
        $engineers = $this->siteVisitService->getAvailableEngineers();
        return response()->json(['data' => $engineers]);
    }

    // ب) فرز مهندس للزيارة
    public function assignEngineer(Request $request): JsonResponse
    {
        $request->validate([
            'visit_id'    => 'required|exists:site_visits,id',
            'engineer_id' => 'required|exists:users,id',
        ]);

        $this->siteVisitService->assignEngineerToVisit($request->visit_id, $request->engineer_id);

        return response()->json(['message' => 'تم فرز المهندس للزيارة الميدانية بنجاح.']);
    }

    /**
     * عرض الزيارات التي تحتاج إعادة تعيين أو فرز مهندس
     */
    public function unassignedOrRejectedVisits(): \Illuminate\Http\JsonResponse
    {
        $visits = $this->siteVisitService->getUnassignedOrRejectedVisits();

        return response()->json([
            'data' => $visits
        ]);
    }
    }

