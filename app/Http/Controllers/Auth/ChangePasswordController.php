<?php

namespace App\Http\Controllers\Auth;

use App\Http\Controllers\Controller;
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
}

