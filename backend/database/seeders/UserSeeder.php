<?php

namespace Database\Seeders;

use App\Models\Role;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        // إنشاء الرولات إذا لم تكن موجودة
        $admin = Role::firstOrCreate([
            'name' => 'admin'
        ]);

        $user = Role::firstOrCreate([
            'name' => 'user'
        ]);

        $contractor = Role::firstOrCreate([
            'name' => 'contractor'
        ]);

        $engineer = Role::firstOrCreate([
            'name' => 'engineer'
        ]);

        $roles = [
            $user->id,
            $contractor->id,
            $engineer->id,
        ];

        // إنشاء 10 مستخدمين
        for ($i = 1; $i <= 10; $i++) {

            User::create([
                'name' => "Test User $i",
                'email' => "user$i@test.com",
                'password' => Hash::make('12345678'),
                'role_id' => $roles[array_rand($roles)],
                'status' => 'approved',
                'otp_verified' => true,
            ]);
        }

        // أدمن ثابت
        User::firstOrCreate(
            ['email' => 'admin@test.com'],
            [
                'name' => 'Admin',
                'password' => Hash::make('12345678'),
                'role_id' => $admin->id,
                'status' => 'approved',
                'otp_verified' => true,
            ]
        );
    }
}
