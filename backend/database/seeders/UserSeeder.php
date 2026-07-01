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
        // 1. إنشاء الرولات إذا لم تكن موجودة
        $admin = Role::firstOrCreate(['name' => 'admin']);
        $user = Role::firstOrCreate(['name' => 'user']);
        $contractor = Role::firstOrCreate(['name' => 'contractor']);
        $engineer = Role::firstOrCreate(['name' => 'engineer']);

        // 2. إنشاء 10 مستخدمين عاديين (User)
        for ($i = 1; $i <= 10; $i++) {
            User::create([
                'name' => "Regular User $i",
                'email' => "user$i@test.com",
                'password' => Hash::make('12345678'),
                'role_id' => $user->id, // رول مستخدم عادي
                'status' => 'approved',
                'otp_verified' => true,
            ]);
        }

        // 3. إنشاء 10 متعهدين (Contractor)
        for ($i = 1; $i <= 10; $i++) {
            User::create([
                'name' => "Contractor $i",
                'email' => "contractor$i@test.com",
                'password' => Hash::make('12345678'),
                'role_id' => $contractor->id, // رول متعهد
                'status' => 'approved',
                'otp_verified' => true,
            ]);
        }

        // 4. إنشاء 10 مهندسين (Engineer)
        for ($i = 1; $i <= 10; $i++) {
            User::create([
                'name' => "Engineer $i",
                'email' => "engineer$i@test.com",
                'password' => Hash::make('12345678'),
                'role_id' => $engineer->id, // رول مهندس
                'status' => 'approved',
                'otp_verified' => true,
            ]);
        }

        // 5. الأدمن الثابت للتجربة والدخول السريع
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
