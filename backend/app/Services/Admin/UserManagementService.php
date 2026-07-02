<?php

namespace App\Services\Admin;

use App\Models\User;

class UserManagementService
{
    public function index()
    {
        return User::with([
            'role',
            'profile',
            'contractorProfile'
        ])->get();
    }

    public function show(User $user)
    {
        return $user->load([
            'role',
            'contractorProfile',
            'profile'
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
        return User::with('role','profile')
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
}
