<?php

namespace App\Models;

use Carbon\Carbon;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Mail;
use App\Mail\OtpMail;


class Otp extends Model
{
    //
    protected $fillable = ['user_id', 'code', 'expires_at'];

    public $timestamps = true;

    protected $dates = ['expires_at'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
    public function sendOtp($user)
    {
        // توليد OTP 6 أرقام
        $code = rand(100000, 999999);

        // حفظ OTP في قاعدة البيانات
        Otp::create([
            'user_id' => $user->id,
            'code' => $code,
            'expires_at' => Carbon::now()->addMinutes(10), // صلاحية 10 دقائق
        ]);

        // إرسال الإيميل
        Mail::to($user->email)->send(new \App\Mail\OtpMail($code));

        return response()->json(['message' => 'OTP تم إرساله للإيميل.']);
    }
}
