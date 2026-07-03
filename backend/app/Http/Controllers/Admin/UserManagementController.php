<?php

namespace App\Http\Controllers\Admin;

use App\Http\Requests\Admin\StoreEngineerRequest;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use App\Http\Controllers\Controller;
use App\Services\Admin\UserManagementService;
use Illuminate\Http\Request;

class UserManagementController extends Controller
{
    public function __construct(
        private UserManagementService $service
    ) {}

    public function index(): JsonResponse
    {
        return response()->json([
            'data' => $this->service->index()
        ]);
    }

    public function show(
        User $user
    ): JsonResponse
    {
        return response()->json([
            'data' => $this->service->show($user)
        ]);
    }

    public function toggleStatus(
        Request $request,
        User $user
    ): JsonResponse
    {
        $request->validate([
            'status' => 'required|in:pending,approved,rejected'
        ]);

        return response()->json([
            'data' => $this->service->updateStatus(
                $user,
                $request->status
            )
        ]);
    }

    public function destroy(
        User $user
    ): JsonResponse
    {
        $this->service->delete($user);

        return response()->json([
            'message' => 'تم حذف المستخدم'
        ]);
    }
    public function contractors()
    {
        return response()->json([
            'data' => $this->service->contractors()
        ]);
    }

    public function engineers()
    {
        return response()->json([
            'data' => $this->service->engineers()
        ]);
    }
    public function toggleActive(
        User $user
    )
    {
        return response()->json([
            'message'=>'تم تغيير حالة النشاط بنجاح',
            'data' => $this->service
                ->toggleActive($user)
        ]);
    }
    public function createEngineerByAdmin(StoreEngineerRequest $request): JsonResponse {
       // $engineer = $this->service->createEngineerAccount($request->validated());
        $engineer = $this->service->createEngineerAccount($request->all());

        return response()->json([
            'message' => 'تم إنشاء حساب المهندس بنجاح من قِبل المسؤول.',
            'data'    => $engineer
        ], 201);
    }
}
