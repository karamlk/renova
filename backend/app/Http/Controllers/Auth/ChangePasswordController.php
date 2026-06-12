<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

class ChangePasswordController extends Controller
{
    public function change(Request $request)
    {
        $request->validate([
            'current_password' => 'required|string',
            'new_password' => 'required|string|min:6|confirmed',
        ]);

        $user = $request->user(); // من الـ auth:sanctum middleware

        // تحقق من كلمة المرور القديمة
        if (! Hash::check($request->current_password, $user->password)) {
            return response()->json([
                'message' => 'كلمة المرور القديمة غير صحيحة.'
            ], 400);
        }

        // تحديث كلمة المرور
        $user->password = Hash::make($request->new_password);
        $user->save();

        return response()->json([
            'message' => 'تم تغيير كلمة المرور بنجاح.'
        ]);
    }
    public function updatePassword(Request $request)
    {
        // 1. التحقق من البيانات القادمة من الـ API (يجب إرسال الإيميل وكلمة المرور الجديدة)
        $request->validate([
            'email'    => ['required', 'email', 'exists:users,email'],
            'password' => ['required', 'string', 'min:8', 'confirmed'], // يتطلب password_confirmation
        ], [
            'email.required'    => 'البريد الإلكتروني مطلوب.',
            'email.exists'      => 'هذا البريد الإلكتروني غير مسجل لدينا.',
            'password.required' => 'حقل كلمة المرور مطلوب.',
            'password.min'      => 'كلمة المرور يجب ألا تقل عن 8 أحرف.',
            'password.confirmed'=> 'كلمتا المرور غير متطابقتين.',
        ]);

        // 2. البحث عن المستخدم عبر الإيميل القادم في الطلب (Request)
        $user = User::where('email', $request->email)->first();

        if ($user) {
            // تحديث كلمة المرور وتشفيها
            $user->update([
                'password' => Hash::make($request->password)
            ]);

            // إرجاع استجابة نجاح بصيغة JSON
            return response()->json([
                'status'  => true,
                'message' => 'تم تغيير كلمة المرور بنجاح.'
            ], 200);
        }

        // في حال حدوث خطأ غير متوقع
        return response()->json([
            'status'  => false,
            'message' => 'حدث خطأ ما، لم يتم العثور على الحساب.'
        ], 404);
    }
}

