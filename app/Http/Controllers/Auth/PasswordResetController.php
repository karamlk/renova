<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Services\Auth\OtpService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class PasswordResetController extends Controller
{
    protected $otpService;

    public function __construct(OtpService $otpService)
    {
        $this->otpService = $otpService;
    }

    // 1️⃣ إرسال OTP لإعادة تعيين كلمة المرور
    public function sendOtp(Request $request)
    {
        $request->validate([
            'email' => 'required|email'
        ]);

        $user = User::where('email', trim($request->email))->first();

        if (!$user) {
            return response()->json(['message' => 'الإيميل غير موجود.'], 404);
        }

        $this->otpService->send($user);

        // إنشاء token مؤقت لإعادة تعيين كلمة المر
        $tempToken = $user->createToken('password_reset_token')->plainTextToken;

        return response()->json([
            'message' => 'تم إرسال رمز التحقق إلى بريدك الإلكتروني.',
            'temp_token' => $tempToken
        ]);
    }

    public function verifyOtp(Request $request)
    {
        $request->validate([
            'otp' => 'required|digits:6',
        ]);

        // قراءة التوكن من Bearer Token
        $tempToken = $request->bearerToken();

        if (! $tempToken) {
            return response()->json(['message' => 'توكن مفقود.'], 401);
        }

        $user = \Laravel\Sanctum\PersonalAccessToken::findToken($tempToken)?->tokenable;

        if (! $user) {
            return response()->json(['message' => 'توكن غير صالح.'], 401);
        }

        $isValid = $this->otpService->verify($user, $request->otp);

        if (! $isValid) {
            return response()->json(['message' => 'رمز التحقق غير صحيح.'], 400);
        }

        return response()->json([
            'message' => 'تم التحقق من OTP بنجاح.'
        ]);
    }


    public function setNewPassword(Request $request)
    {
        $request->validate([
            'password' => 'required|string|min:6|confirmed',
            'temp_token' => 'required|string',
        ]);

        $user = \Laravel\Sanctum\PersonalAccessToken::findToken($request->temp_token)?->tokenable;

        if (! $user) {
            return response()->json(['message' => 'توكن غير صالح.'], 401);
        }

        $user->password = Hash::make($request->password);
        $user->save();

        // ممكن هنا تمسح الـ temp token بعد الاستخدام
        $user->tokens()->where('token', $request->temp_token)->delete();

        return response()->json([
            'message' => 'تم تغيير كلمة المرور بنجاح.'
        ]);
    }

}
    // 2️⃣ تحقق OTP وتغيير كلمة المرور
