<?php

namespace App\Services\Admin;

use App\Models\EngineerProfile;
use App\Models\User;
use App\Models\UserProfile;
use App\Models\Wallet;
use Illuminate\Support\Facades\Hash;

class UserManagementService
{
    public function index()
    {
        return User::with([
            'role',
            'profile',
            'contractorProfile',
            'engineerProfile'
        ])->get();
    }

    public function show(User $user)
    {
        return $user->load([
            'role',
            'contractorProfile',
            'profile',
            'engineerProfile'

        ]);
    }

    public function updateStatus(
        User $user,
        string $status
    )
    {
        $user->update([
            'status' => $status
        ]);

        return $user;
    }
    public function delete(User $user)
    {
        $user->delete();
    }
    public function contractors()
    {
        return User::with('role','contractorProfile')
            ->whereHas('role', function ($query) {

                $query->where(
                    'name',
                    'contractor'
                );
            })
            ->get();
    }
    public function engineers()
    {
        return User::with('role','profile','engineerProfile')
            ->whereHas('role', function ($query) {

                $query->where(
                    'name',
                    'engineer'
                );
            })
            ->get();
    }
    public function toggleActive(User $user)
    {
        $newStatus = ! $user->is_active;

        $user->update([
            'is_active' => $newStatus
        ]);

        // إذا تم تعطيل الحساب
        if (! $newStatus) {

            $user->tokens()->delete();
        }

        return $user->fresh();
    }

    public function createEngineerAccount(array $data): User {
        // خطوة اختيارية: التأكد من تطابق كلمة المرور والتأكيد داخل الدالة
        if (!isset($data['password_confirmation']) || $data['password'] !== $data['password_confirmation']) {
            throw new \Illuminate\Http\Exceptions\HttpResponseException(
                response()->json([
                    'message' => 'البيانات المرسلة غير صالحة.كلمة المرور وتأكيدها غير متطابقين',
                    'errors'  => [
                        //'password' => ['كلمة المرور وتأكيدها غير متطابقين.']
                    ]
                ], 422)
            );
        }

        $engineer = User::create([
            'name'     => $data['name'],
            'email'    => $data['email'],
            'password' => Hash::make($data['password']),
            'role_id'  => 4,
            'status'   => 'approved',
        ]);
        Wallet::create([

            'user_id' => $engineer->id,

            'balance' => rand(1000,5000),

            'card_number' => str_pad(
                rand(0,9999),
                4,
                '0',
                STR_PAD_LEFT
            )
        ]);

        UserProfile::create([
            'user_id'    => $engineer->id,
            'first_name' => $data['name'],
            'last_name'  => '',
            'phone'      => '',
            'location'   => '',
        ]);

        EngineerProfile::create([
            'user_id'          => $engineer->id,
            'specialization'   => '',
            'syndicate_number' => 'PENDING_' . $engineer->id,
            'degree'           => '',
            'covered_zones'    => '',
        ]);

        return $engineer;
    }

}
