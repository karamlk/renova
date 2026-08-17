<?php

namespace App\Http\Controllers\Foundation;

use App\Http\Controllers\Controller;
use App\Services\Foundation\FoundationVerificationService;
use Illuminate\Http\Request;

class FoundationVerificationController extends Controller
{
    public function store(
        Request $request,
        FoundationVerificationService $service
    ) {
        $request->validate([
            'foundation_name' =>
                'required|string|max:255',

            'description' =>
                'nullable|string',

            'registration_number' =>
                'nullable|string|max:255',

            'documents' =>
                'required|array|min:1',

            'documents.*' =>
                'required|file|mimes:pdf,jpg,jpeg,png|max:5120',
        ]);

        $verification =
            $service->store($request);

        return response()->json([
            'message' =>
                'تم إرسال طلب توثيق الـ Foundation بنجاح',

            'data' => $verification
        ], 201);
    }

    public function pending(
        FoundationVerificationService $service
    ) {
        return response()->json(
             $service->pending());
    }

    public function approve(
        $id,
        FoundationVerificationService $service
    ) {
        return response()->json([
            'message' => 'تم توثيق الجمعية بنجاح',
            'data' => $service->approve($id)
        ]);
    }

    public function reject(
        Request $request,
                $id,
        FoundationVerificationService $service
    ) {
        $request->validate([
            'reason' => 'nullable|string'
        ]);

        return response()->json([
            'message' => 'تم رفض طلب التوثيق',
            'data' => $service->reject(
                $id,
                $request->reason
            )
        ]);
    }
    public function show($id , FoundationVerificationService $service)
    {
        $foundation = $service->show($id);

        return response()->json($foundation);
    }
}
