<?php

namespace App\Http\Controllers\Contractor;

use App\Http\Controllers\Controller;
use App\Http\Requests\Contractor\Schedule\StoreScheduleRequest;
use App\Services\Contractor\ScheduleService;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\JsonResponse;


class ScheduleController extends Controller
{
    public function __construct(
        private ScheduleService $scheduleService
    ) {}

    public function store(
        StoreScheduleRequest $request
    ): JsonResponse {

        $schedule = $this->scheduleService
            ->store($request->validated());

        return response()->json([
            'message' => 'تمت إضافة الموعد بنجاح',
            'data' => $schedule
        ]);
    }
}
