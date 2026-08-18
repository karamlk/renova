<?php

namespace App\Services\Foundation;

use App\Models\DonationCampaign;
use App\Models\DonationCampaignImage;
use App\Models\FoundationVerificationRequest;
use Carbon\Carbon;
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
            $startDate = Carbon::parse($request->starts_at)->startOfDay();
            $today = Carbon::today();
            $status = $startDate->lessThanOrEqualTo($today) ? 'active' : 'pending';


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

                'status' => $status,

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

    public function index()
    {
        $foundation = FoundationVerificationRequest::where(
            'user_id',
            auth()->id()
        )
            ->where('status', 'approved')
            ->firstOrFail();

        return DonationCampaign::where(
            'foundation_verification_request_id',
            $foundation->id
        )
            ->with('images')
            ->latest()
            ->get();

    }

    public function show($id)
    {
        $foundation = FoundationVerificationRequest::where(
            'user_id',
            auth()->id()
        )
            ->where('status', 'approved')
            ->firstOrFail();

        return DonationCampaign::where(
            'foundation_verification_request_id',
            $foundation->id
        )
            ->with('images')
            ->findOrFail($id);
    }

    public function destroy($id)
    {
        $foundation = FoundationVerificationRequest::where(
            'user_id',
            auth()->id()
        )
            ->where('status', 'approved')
            ->firstOrFail();

        $campaign = DonationCampaign::where(
            'foundation_verification_request_id',
            $foundation->id
        )->findOrFail($id);

        $campaign->delete();

        return true;
    }
    private function updateExpiredStatus(DonationCampaign $campaign)
    {
        if (
            $campaign->ends_at->isPast() &&
            in_array($campaign->status, ['pending', 'active'])
        ) {
            $campaign->update([
                'status' => 'expired'
            ]);
        }

        return $campaign;
    }

    public function activeCampaigns()
    {
        return DonationCampaign::where('status', 'active')
            ->whereDate('ends_at', '>=', now()->toDateString())
            ->with('images')
            ->latest()
            ->get();
    }

    public function donationCampaignDetails($id)
    {
        return DonationCampaign::with('images')
            ->findOrFail($id);
    }
}
