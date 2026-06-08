<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Http\Requests\Auth_Requests\LoginRequest;
use App\Http\Requests\Auth_Requests\RegisterRequest;
use App\Http\Requests\Auth_Requests\VerifyOtpRequest;
use App\Models\User;
use App\Services\Auth\OtpService;
use App\Services\User\UserService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Laravel\Sanctum\PersonalAccessToken;

class AuthController extends Controller
{

    protected UserService $userService;
    protected OtpService $otpService;

    public function __construct(
        UserService $userService,
        OtpService $otpService
    ) {
        $this->userService = $userService;
        $this->otpService = $otpService;
    }


        public function register(RegisterRequest $request): JsonResponse
    {
       // dd('reached register');

        $user = $this->userService->register($request->validated());
         //$user->load('role');

        return response()->json([
            'message' => 'تم إنشاء الحساب بنجاح، وتم إرسال رمز التحقق إلى بريدك الإلكتروني.',
             'user' => $user,
             'role'=>$user['user']->role->name,
        ], 201);
    }


    public function resendOtp(Request $request): JsonResponse
    {
        $token = $request->bearerToken();

        if (! $token) {
            return response()->json([
                'message' => 'توكن مفقود.'
            ], 401);
        }

        $accessToken = PersonalAccessToken::findToken($token);

        if (! $accessToken || ! $accessToken->tokenable) {
            return response()->json([
                'message' => 'توكن غير صالح أو منتهي.'
            ], 401);
        }

        $user = $accessToken->tokenable;

        $this->otpService->resend($user);

        return response()->json([
            'message' => 'تم إعادة إرسال رمز التحقق.'
        ]);
    }

    public function verify(
        VerifyOtpRequest $request
    ): JsonResponse {

        $user = $this->getAuthenticatedUser($request);

        if (! $user) {
            return response()->json([
                'message' => 'توكن غير صالح أو مفقود.'
            ], 401);
        }

        try {

            $token = $this->otpService->verify(
                $user,
                $request->otp
            );

            return response()->json([
                'message' => 'تم التحقق بنجاح.',
                'token' => $token
            ]);

        } catch (\Exception $e) {

            return response()->json([
                'message' => $e->getMessage()
            ], 400);
        }
    }
    public function login(LoginRequest $request): JsonResponse
    {
        try {

            $token = $this->userService->login(
                $request->validated()
            );
            $user = User::with('role')->
                where('email',$request->email)
                ->first();
            return response()->json([
                'message' => 'تم تسجيل الدخول بنجاح.',
                'token' => $token,
                'role'=>$user->role->name

            ]);

        } catch (\Exception $e) {

            return response()->json([
                'message' => $e->getMessage()
            ], 401);
        }
    }

    public function logout(Request $request): JsonResponse
    {
        $this->userService->logout(
            $request->user()
        );

        return response()->json([
            'message' => 'تم تسجيل الخروج بنجاح.'
        ]);
    }
    //Helper لجلب المستخدم من التوكن
    private function getAuthenticatedUser(Request $request)
    {
        $token = $request->bearerToken();

        if (! $token) {
            return null;
        }

        $accessToken = PersonalAccessToken::findToken($token);

        if (! $accessToken || ! $accessToken->tokenable) {
            return null;
        }

        return $accessToken->tokenable;
    }
}
