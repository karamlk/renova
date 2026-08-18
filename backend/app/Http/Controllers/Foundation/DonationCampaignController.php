<?php

namespace App\Http\Controllers\Foundation;

use App\Http\Controllers\Controller;
use App\Services\Foundation\DonationCampaignService;
use Illuminate\Http\Request;

class DonationCampaignController extends Controller
{
    public function store(
        Request $request,
        DonationCampaignService $service
    ) {

        $request->validate([

//            'reconstruction_request_id' =>
//                'nullable|exists:reconstruction_requests,id',

            'title' =>
                'required|string|max:255',

            'description' =>
                'nullable|string',

            'location' =>
                'required|string|max:255',


            'target_amount' =>
                'required|numeric|min:1',

            'starts_at' =>
                'required|date',

            'ends_at' =>
                'required|date|after:starts_at',

            'images' =>
                'required|array|min:1',

            'images.*' =>
                'required|image|mimes:jpg,jpeg,png,webp|max:5120',
        ]);


        $campaign =
            $service->store($request);


        return response()->json([

            'message' =>
                'تم إنشاء حملة التبرع بنجاح',

            'data' => $campaign

        ], 201);
    }

    public function index(
        DonationCampaignService $service
    ) {
        $campaigns = $service->index();

        return response()->json([
            'message' => 'تم جلب حملات التبرع بنجاح',
            'data' => $campaigns
        ]);
    }

    public function show(
        $id,
        DonationCampaignService $service
    ) {
        $campaign = $service->show($id);

        return response()->json([
            'message' => 'تم جلب تفاصيل حملة التبرع بنجاح',
            'data' => $campaign
        ]);
    }

    public function destroy(
        $id,
        DonationCampaignService $service
    ) {
        $service->destroy($id);

        return response()->json([
            'message' => 'تم حذف حملة التبرع بنجاح'
        ]);
    }
}
