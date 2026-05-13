<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Http\Requests\ReconstructionRequest\StoreReconstructionRequest;
use App\Http\Requests\ReconstructionRequest\UpdateReconstructionRequest;
use App\Services\User\ReconstructionRequestService;

class ReconstructionRequestController extends Controller
{
    public function __construct(
        protected ReconstructionRequestService $requestService
    ) {}

    public function store(
        StoreReconstructionRequest $request
    ) {

        $reconstructionRequest =
            $this->requestService->store($request);

        return response()->json([

            'message' => 'تم إنشاء الطلب بنجاح',

            'data' => $reconstructionRequest

        ], 201);
    }

    public function index()
    {
        return response()->json([

            'data' => $this->requestService->index()

        ]);
    }

    public function show($id)
    {
        return response()->json([

            'data' => $this->requestService->show($id)

        ]);
    }

    public function update(
        UpdateReconstructionRequest $request,
                                    $id
    ) {

        $reconstructionRequest =
            $this->requestService->update(
                $request,
                $id
            );

        return response()->json([

            'message' => 'تم تعديل الطلب',

            'data' => $reconstructionRequest

        ]);
    }

    public function destroy($id)
    {
        $this->requestService->destroy($id);

        return response()->json([

            'message' => 'تم حذف الطلب'

        ]);
    }
}
