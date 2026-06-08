<?php

namespace App\Services;

use App\Models\Otp;
use App\Models\User;
use App\Services\Auth\OtpService;
use Illuminate\Support\Facades\Hash;

class AuthService
{
    //غير مستخدم ____________________________________
    public function login(array $data)
    {
        $user = User::where('email', $data['email'])->first();

//        if (!$user || !Hash::check($data['password'], $user->password)) {
//            return response()->json(['message' => 'بيانات الدخول غير صحيحة.'], 401);
//        }
        if (! $user) {

            throw new \Exception(
                'الإيميل غير موجود'
            );
        }

        if (! Hash::check(
            $data['password'],
            $user->password
        )) {

            throw new \Exception(
                'كلمة المرور غير صحيحة'
            );
        }
        // تحقق من الجهاز
        $deviceId = request()->userAgent();
        $otpRequired = !Otp::where('user_id', $user->id)
            ->where('device_identifier', $deviceId)
            ->where('used', true)
            ->exists();

        if ($otpRequired) {
            app(OtpService::class)->send($user); // 👈 استدعاء الخدمة
            return response()->json(['message' => 'تم إرسال رمز التحقق إلى بريدك الإلكتروني.']);

        }
       // $this->OtpService->send($user);

        $token = $user->createToken('auth_token')->plainTextToken;
        return response()->json(['token' => $token]);


}}

