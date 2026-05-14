<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Mail;
use App\Mail\ContractorApprovedMail;

class ContractorController extends Controller
{
    // جلب المتعهدين المعلقين
    public function pending()
    {
        $contractors = User::where('status', 'pending')
            ->whereHas('role', function ($q) {
                $q->where('name', 'contractor');
            })
            ->get();

        return response()->json($contractors);
    }

    // قبول متعهد
    public function approve($id)
    {
        $user = User::findOrFail($id);

        $user->update([
            'status' => 'approved'
        ]);
        Mail::to($user->email)
            ->send(
                new ContractorApprovedMail($user)
            );
        return response()->json([
            'message' => 'تم قبول المتعهد'
        ]);
    }

    // رفض متعهد
    public function reject($id)
    {
        $user = User::findOrFail($id);

        $user->update([
            'status' => 'rejected'
        ]);

        return response()->json([
            'message' => 'تم رفض المتعهد'
        ]);
    }
}
