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

    public function show(Request $request): JsonResponse
    {
        $formattedData = $this->profileService->getFormattedProfile($request->user());

        return response()->json([
            'data' => $formattedData
        ]);
    }

    public function update(UpdateEngineerProfileRequest $request): JsonResponse
    {
        // 1. تنفيذ التحديث عبر الـ Service
        $this->profileService->updateEngineerProfile($request->user(), $request->validated());

        // 2. السطر السحري: إجبار لارافيل على إعادة تنشيط وجلب البيانات المحدثة من الداتابيز
        $user = $request->user()->refresh();

        // 3. جلب الـ Response الجديد المنسق بعد التحديث الفوري
        $formattedData = $this->profileService->getFormattedProfile($user);

        return response()->json([
            'message' => 'تم تحديث البروفايل بالكامل والأوراق الرسمية بنجاح!',
            'data'    => $formattedData // إرجاع البيانات المحدثة مباشرة للفرونت إند ليتأكد من ظهورها
        ]);
    }
}
