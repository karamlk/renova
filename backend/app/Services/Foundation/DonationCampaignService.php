<?php

namespace App\Services\Foundation;

use App\Models\DonationCampaign;
use App\Models\DonationCampaignImage;
use App\Models\FoundationVerificationRequest;
use Illuminate\Support\Facades\DB;

class DonationCampaignService
{
    public function store($request)
    {
        $user = auth()->user();

        // لازم يكون عنده طلب Foundation موافق عليه
        $foundation =
            FoundationVerificationRequest::where(
                'user_id',
                $user->id
            )
                ->where('status', 'approved')
                ->latest()
                ->first();

        if (!$foundation) {
            abort(
                403,
                'يجب توثيق الجمعيةأولاً'
            );
        }

        return DB::transaction(function () use (
            $request,
            $foundation
        ) {

            $campaign = DonationCampaign::create([

                'foundation_verification_request_id' =>
                    $foundation->id,

//                'reconstruction_request_id' =>
//                    $request->reconstruction_request_id?:null,

                'title' =>
                    $request->title,

                'description' =>
                    $request->description,

                'location' => $request->location,

                'target_amount' =>
                    $request->target_amount,

                'collected_amount' => 0,

                'starts_at' =>
                    $request->starts_at,

                'ends_at' =>
                    $request->ends_at,

                'status' => 'pending',
            ]);


            // رفع صور البيت المتضرر
            foreach (
                $request->file('images', [])
                as $image
            ) {

                $path = $image->store(
                    'donation-campaigns',
                    'public'
                );

                DonationCampaignImage::create([

                    'donation_campaign_id' =>
                        $campaign->id,

                    'image' => $path,
                ]);
            }


            return $campaign->load([
                'images'
            ]);
        });
    }
}
