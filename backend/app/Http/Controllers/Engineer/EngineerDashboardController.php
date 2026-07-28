<?php

namespace App\Http\Controllers\Engineer;

use App\Http\Controllers\Controller;
use App\Services\Engineer\EngineerDashboardService;

class EngineerDashboardController extends Controller
{
    public function index(
        EngineerDashboardService $service
    )
    {
        return response()->json([

            'data'=>

                $service->index()

        ]);
    }
}
