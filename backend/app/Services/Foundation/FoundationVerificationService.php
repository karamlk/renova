<?php

namespace App\Services\Foundation;

use App\Models\FoundationVerificationRequest;
use App\Models\FoundationVerificationDocument;
use Illuminate\Support\Facades\DB;

class FoundationVerificationService
{
    public function store($request)
    {
        $user = auth()->user();

        $existingRequest = FoundationVerificationRequest::where(
            'user_id',
            $user->id
        )
            ->where('status', 'pending')
            ->first();

        if ($existingRequest) {
            abort(422, 'لديك طلب توثيق قيد المراجعة');
        }

        return DB::transaction(function () use (
            $request,
            $user
        ) {

            $verification =
                FoundationVerificationRequest::create([
                    'user_id' => $user->id,

                    'foundation_name' =>
                        $request->foundation_name,

                    'description' =>
                        $request->description,

                    'registration_number' =>
                        $request->registration_number,

                    'status' => 'pending',
                ]);

            foreach ($request->file('documents') as $document) {

                $path = $document->store(
                    'foundation-documents',
                    'public'
                );

                FoundationVerificationDocument::create([
                    'foundation_verification_request_id' =>
                        $verification->id,

                    'document' => $path,

                    'type' =>
                        $document->getClientOriginalExtension(),
                ]);
            }

            return $verification->load('documents');
        });
    }

    public function pending()
    {
        return FoundationVerificationRequest::with([
            'user.profile',
            'documents'
        ])
            ->where('status', 'pending')
            ->latest()
            ->get();
    }

    public function approve($id)
    {
        $request = FoundationVerificationRequest::findOrFail($id);

        if ($request->status !== 'pending') {
            abort(422, 'طلب التوثيق تمت معالجته مسبقاً');
        }

        $request->update([
            'status' => 'approved',
            'rejection_reason' => null,
        ]);

        return $request->load([
            'user.profile',
            'documents'
        ]);
    }

    public function reject($id)
    {
        $request = FoundationVerificationRequest::findOrFail($id);

        if ($request->status !== 'pending') {
            abort(422, 'طلب التوثيق تمت معالجته مسبقاً');
        }

        $request->update([
            'status' => 'rejected',
            'rejection_reason' => $request->rejection_reason,
        ]);

        return $request->load([
            'user.profile',
            'documents'
        ]);
    }

    public function show($id)
    {
        $request = FoundationVerificationRequest::with([
            'user.profile',
            'documents'
        ])->find($id);

        if (!$request) {
            abort(404, 'طلب توثيق الجمعية غير موجود');
        }

        return $request;
    }
}
