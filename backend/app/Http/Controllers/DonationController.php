<?php

namespace App\Http\Controllers;

use App\Models\DonationCampaign;
use App\Services\DonationService;
use Illuminate\Http\Request;

class DonationController extends Controller
{
    public function store(
        Request $request,
        DonationCampaign $campaign,
        DonationService $service
    ) {
        $request->validate([
            'amount' =>
                'required|numeric|min:0.01',
        ]);

        $donation = $service->donate(
            $campaign,
            $request->amount
        );

        return response()->json([
            'message' =>
                'تم التبرع بنجاح',

            'data' =>
                $donation
        ], 201);
    }
}
