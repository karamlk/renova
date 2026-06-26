<?php

namespace App\Services\Admin;

use App\Models\User;

class UserManagementService
{
    public function index()
    {
        return User::with([
            'role',
            'profile'
        ])->get();
    }

    public function show(User $user)
    {
        return $user->load([
            'role',
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
        return User::with('role')
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
        return User::with('role')
            ->whereHas('role', function ($query) {

                $query->where(
                    'name',
                    'engineer'
                );
            })
            ->get();
    }
}
