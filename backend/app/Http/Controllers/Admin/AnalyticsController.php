<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Services\Admin\AnalyticsService;
use Illuminate\Http\JsonResponse;

class AnalyticsController extends Controller
{
    protected AnalyticsService $analyticsService;

    public function __construct(AnalyticsService $analyticsService)
    {
        $this->analyticsService = $analyticsService;
    }

    public function index(): JsonResponse
    {
        $data = $this->analyticsService->getAnalyticsSnapshot();

        return response()->json($data, 200);
    }
}
