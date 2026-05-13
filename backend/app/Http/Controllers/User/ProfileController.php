<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Http\Requests\UserProfile\StoreProfileRequest;
use App\Http\Requests\UserProfile\UpdateProfileRequest;
use App\Services\User\ProfileService;

class ProfileController extends Controller
{
  public function __construct(
      protected ProfileService $profileService
  )
  {

  }
  public function store(StoreProfileRequest $request){
      $profile =$this-> profileService ->store($request);
      return response()->json([
          'message'=>'تم انشاء ملفك الشخصي',
          'data'=>$profile
      ]);
  }
    public function show()
    {
        return response()->json([
            'data' => $this->profileService->show()
        ]);
    }

    public function update(UpdateProfileRequest $request)
    {
        $profile = $this->profileService->update($request);

        return response()->json([
            'message' => 'تم تعديل البروفايل',
            'data' => $profile
        ]);
    }

}
