<?php

namespace App\Http\Controllers\Contractor;

use App\Http\Controllers\Controller;
use App\Http\Requests\Contractor\Schedule\UpdateRequest;
use App\Services\Contractor\ScheduleService;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\JsonResponse;


class ScheduleController extends Controller
{
    public function __construct(
        private ScheduleService $scheduleService
    ) {}

    public function store(
        UpdateRequest $request
    ): JsonResponse {

        $schedule = $this->scheduleService
            ->store($request->validated());

        return response()->json([
            'message' => 'تمت إضافة الفترة بنجاح',
            'data' => $schedule
        ], 201);
    }

    public function index(): JsonResponse
    {
        return response()->json([
            'data' => $this->scheduleService->index()
        ]);
    }

    public function show(
        int $scheduleId
    ): JsonResponse {

        return response()->json([
            'data' => $this->scheduleService
                ->show($scheduleId)
        ]);
    }

    public function destroy(
        int $scheduleId
    ): JsonResponse {

        $this->scheduleService
            ->delete($scheduleId);

        return response()->json([
            'message' => 'تم حذف الموعد بنجاح'
        ]);
    }

    public function update(
        UpdateRequest $request,
        int $scheduleId
    ): JsonResponse {

        $schedule = $this->scheduleService->update(
            $scheduleId,
            $request->validated()
        );

        return response()->json([
            'message' => 'تم تعديل الموعد بنجاح',
            'data' => $schedule
        ]);
    }

}
