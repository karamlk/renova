<?php

namespace App\Services\User;

use App\Models\Role;
use App\Models\User;
use App\Services\Auth\OtpService;
use Illuminate\Support\Facades\Hash;

class UserService
{
    protected $otpService;


    public function __construct(OtpService $otpService)
    {
        $this->otpService = $otpService;
    }


    public function register(array $data)
    {
        $role = Role::where('name', $data['role'])->first();
        $user = User::create([
            'name' => $data['name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'otp_verified' => false,
            'role_id' => $role->id,

            'status' => $data['role'] === 'contractor'
                ? 'pending'
                : 'approved',
        ]);

        $this->otpService->send($user);

        $token = $user->createToken('auth_token')->plainTextToken;

        return [
            'user' => $user,
            'token' => $token
        ];
    }
    public function login(array $data): string
    {
        $user = User::where('email', $data['email'])->first();

//        if (! $user || ! Hash::check($data['password'], $user->password)) {
//            throw new \Exception('الإيميل أو كلمة المرور غير صحيحة.');
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

        if (
            in_array($user->role->name, ['user', 'contractor']) &&
            ! $user->otp_verified
        ) {
            throw new \Exception('يجب التحقق من OTP أولاً.');
        }
//
        if (! $user->is_active) {

            throw new \Exception(
                'تم تعطيل هذا الحساب من قبل الإدارة'
            );
        }
        if (
            $user->role->name === 'contractor'
            && $user->status !== 'approved'
        ) {
            throw new \Exception('حسابك قيد المراجعة من الإدارة');
        }

        $this->handlePendingDelete($user);

        return $user->createToken('auth_token')->plainTextToken;
    }
    //
    private function handlePendingDelete(User $user): void
    {
        if ($user->pending_delete && $user->delete_at > now()) {

            $user->update([
                'pending_delete' => false,
                'delete_at' => null,
            ]);
        }

        if ($user->pending_delete && $user->delete_at <= now()) {

            $user->delete();

            throw new \Symfony\Component\HttpKernel\Exception\HttpException(
                403,
                'تم تعطيل هذا الحساب من قبل الإدارة'
            );
        }
    }
    public function logout(User $user): void
    {
        $user->currentAccessToken()->delete();
    }
}

