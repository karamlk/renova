<?php

namespace App\Http\Controllers\Contractor;

use App\Http\Controllers\Controller;
use App\Http\Requests\Contractor\profile\StoreContractorProfileRequest;
use App\Services\Contractor\ContractorProfileService;

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
    public function show()
    {
        return response()->json([

            'data' => $this->profileService->show()

        ]);
    }

    public function update(
        \App\Http\Requests\Contractor\profile\UpdateContractorProfileRequest $request
    ) {

        $profile =
            $this->profileService->update($request);

        return response()->json([

            'message' =>
                'تم تعديل البروفايل',

            'data' => $profile

        ]);
    }
}
