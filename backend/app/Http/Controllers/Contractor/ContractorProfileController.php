<?php

namespace App\Http\Controllers\Contractor;

use App\Http\Controllers\Controller;
use App\Services\Contractor\ContractorProfileService;
use App\Http\Requests\Contractor\StoreContractorProfileRequest;

class ContractorProfileController extends Controller
{
    protected $profileService;

    public function __construct(
        ContractorProfileService $profileService
    ) {
        $this->profileService = $profileService;
    }

    public function store(
        StoreContractorProfileRequest $request
    ) {

        $profile =
            $this->profileService->store($request);

        return response()->json([

            'message' =>
                'تم إرسال طلبك للإدارة',

            'data' => $profile
        ]);
    }
}
