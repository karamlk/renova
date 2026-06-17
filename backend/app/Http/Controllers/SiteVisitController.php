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
    }

