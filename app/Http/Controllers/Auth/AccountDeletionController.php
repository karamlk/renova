<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\Otp;
use App\Services\Auth\OtpService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class AccountDeletionController extends Controller
{
    protected $otpService;

    public function __construct(OtpService $otpService)
    {
        $this->otpService = $otpService;
    }
    // إرسال OTP لتأكيد الحذف
    public function requestDeletion(Request $request)
    {
        $user = Auth::user();

        // حذف أي رموز قديمة
        Otp::where('user_id', $user->id)->delete();
        $this->otpService->send($user);
        // إنشاء رمز جديد


        // إرسال الإيميل (ممكن تضيفي خدمة الإرسال لاحقًا)
        return response()->json([
            'message' => 'تم إرسال رمز التأكيد إلى بريدك الإلكتروني.',
            //'otp' => $code // مؤقتاً للتاست
        ]);
    }

    // تأكيد الحذف بالـ OTP
    public function confirmDeletion(Request $request)
    {
        $request->validate(['otp' => 'required|digits:6']);

        $user = Auth::user();
        $otp = Otp::where('user_id', $user->id)
            ->where('code', $request->otp)
            ->first();

        if (! $otp) {
            return response()->json(['message' => 'رمز غير صحيح.'], 400);
        }

        if ($otp->expires_at < now()) {
            return response()->json(['message' => 'انتهت صلاحية الرمز.'], 400);
        }

        // جدولة الحذف بعد شهر
        $user->pending_delete = true;
        $user->delete_at = now()->addMonth();
        $user->save();

        return response()->json([
            'message' => 'تم تأكيد الحذف. سيتم حذف الحساب نهائياً بعد شهر ما لم تسجّل الدخول.'
        ]);
    }
}
