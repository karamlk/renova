<?php
namespace App\Http\Controllers\Engineer;

//use App\Http\Requests\Contractor\UpdateEngineerProfileRequest;
//use App\Http\Requests\Engineer\UpdateEngineerProfileRequest;
//use App\Services\Contractor\EngineerProfileService;
//use App\Services\Engineer\EngineerProfileService;
use App\Http\Controllers\Controller;
use App\Http\Requests\Engineer\UpdateEngineerProfileRequest;
use App\Models\EngineerProfile;
use App\Services\Engineer\EngineerProfileService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class EngineerProfileController extends Controller {
    protected $profileService;

    public function __construct(EngineerProfileService $profileService) {
        $this->profileService = $profileService;
    }

    public function show(Request $request): JsonResponse {
        $formattedData = $this->profileService
            ->getFormattedProfile($request->user());

        return response()->json([
            'data' => $formattedData
        ]);
    }

    public function update(UpdateEngineerProfileRequest $request): JsonResponse {
        $this->profileService
            ->updateEngineerProfile($request->user(), $request->validated());

        return response()->json([
            'message' => 'تم تحديث البروفايل بالكامل والأوراق الرسمية بنجاح!'
        ]);
    }
}
