<?php

namespace App\Http\Controllers\Contractor;

use App\Http\Controllers\Controller;
use App\Http\Requests\Contractor\ContractorPost\StoreContractorPostRequest;
use App\Http\Requests\Contractor\ContractorPost\UpdateContractorPostRequest;
use App\Services\Contractor\ContractorPostService;

class ContractorPostController extends Controller
{
    public function __construct(
        protected ContractorPostService $postService
    ) {}

    // المشاريع التي يستطيع المتعهد إنشاء بوست منها
    public function availableProjects()
    {
        return response()->json([
             $this->postService->availableProjects()
        ]);
    }

    // إنشاء بوست من مشروع
    public function store(
        StoreContractorPostRequest $request
    ) {
        $post = $this->postService->store($request);

        return response()->json([
            'message' => 'تم إنشاء البوست',
            'data' => $post
        ]);
    }

    public function index()
    {
        return response()->json([
            'data' => $this->postService->index()
        ]);
    }

    public function show($id)
    {
        return response()->json([
            'data' => $this->postService->show($id)
        ]);
    }

    public function contractorPosts($id)
    {
        return response()->json([
            'data' => $this->postService->contractorPosts($id)
        ]);
    }

    public function update(
        UpdateContractorPostRequest $request,
                                    $id
    ) {
        $post = $this->postService->update($request, $id);

        return response()->json([
            'message' => 'تم تعديل البوست',
            'data' => $post
        ]);
    }

    public function delete($id)
    {
        $this->postService->delete($id);

        return response()->json([
            'message' => 'تم حذف البوست'
        ]);
    }
}
