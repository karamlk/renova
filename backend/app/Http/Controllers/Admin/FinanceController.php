<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Services\Admin\FinanceService;

class FinanceController extends Controller
{
    public function dashboard(
        FinanceService $financeService
    )
    {
        return response()->json(

            $financeService->dashboard()

        );
    }
    public function report()
    {
        return response()->json(

            app(FinanceService::class)
                ->report()

        );
    }
}
