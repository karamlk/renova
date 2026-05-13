<?php

namespace App\Services\Auth;

use App\Models\Otp;
use App\Models\User;
use Illuminate\Support\Facades\Mail;

class OtpService
{
    public function send(User $user)
    {
        $this->deleteOldOtps($user);

        $otp = $this->createOtp($user);

        $this->sendMail($user, $otp->code);

        return $otp;
    }

    public function resend(User $user)
    {
        $this->deleteOldOtps($user);
        $otp = $this->createOtp($user);
        $this->sendMail($user, $otp->code);
        return $otp;
    }

    public function verify(User $user, string $code): string
    {
        $otp = Otp::where('user_id', $user->id)
            ->where('code', $code)
            ->where('used', false)
            ->latest()
            ->first();

        if (! $otp) {
            throw new \Exception('رمز التحقق غير صحيح.');
        }

        if ($otp->expires_at < now()) {
            throw new \Exception('انتهت صلاحية رمز التحقق.');
        }

        $otp->update([
            'used' => true,
        ]);

        $user->update([
            'otp_verified' => true,
        ]);

        return $user->createToken('final_token')->plainTextToken;
    }

    protected function deleteOldOtps(User $user)
    {
        Otp::where('user_id', $user->id)
            ->where('used', false)
            ->delete();
    }

    protected function createOtp(User $user)
    {
        $code = rand(100000, 999999);

        return Otp::create([
            'user_id' => $user->id,
            'code' => $code,
            'used' => false,
            'expires_at' => now()->addMinutes(15), // صلاحية ربع ساعة فقط
        ]);
    }

    protected function sendMail(User $user, $code)
    {
        Mail::raw("رمز التحقق الخاص بك هو: $code", function ($message) use ($user) {
            $message->to($user->email)
                ->subject('رمز التحقق OTP');
        });
    }
}
