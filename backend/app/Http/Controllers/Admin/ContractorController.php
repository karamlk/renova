<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\User\Mail\ContractorApprovedMail;
use App\Http\Requests\User\Mail\ContractorRejectedMail;
use App\Models\User;
use Illuminate\Support\Facades\Mail;

class ContractorController extends Controller
{
    // جلب المتعهدين المعلقين
    public function pending()
    {
        $contractors = User::with(
            'contractorProfile'
        )
            ->where('status', 'pending')
            ->whereHas('role', function ($q) {

                $q->where(
                    'name',
                    'contractor'
                );
            })
            ->get();

        return response()->json(
            $contractors
        );
    }

    // قبول متعهد
    public function approve($id)
    {
        $user = User::findOrFail($id);

        $user->update([
            'status' => 'approved'
        ]);

        Mail::to($user->email)
            ->queue(
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

        Mail::to($user->email)
            ->queue(
                new ContractorRejectedMail($user)
            );

        return response()->json([
            'message' => 'تم رفض المتعهد'
        ]);
    }
}
