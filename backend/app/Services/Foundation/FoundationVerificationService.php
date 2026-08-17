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
}
