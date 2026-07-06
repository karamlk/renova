<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\EngineerProfile;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class EngineerSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // 1. إنشاء حساب مهندس ثابت للتجربة والاختبار
        $testEngineer = User::firstOrCreate(
            ['email' => 'engineer@test.com'],
            [
                'name'         => 'Engineer Ahmad',
                'password'     => Hash::make('password'),
                'status'       => 'active',
                'role_id'      => 3, // تأكد من تطابق الرقم مع الـ Role الخاص بالمهندسين عندك
                'otp_verified' => true,
            ]
        );

        // ربط الحساب الثابت بملف المهندس مباشرة (يحتوي على البيانات الشخصية والمهنية معاً)
        if ($testEngineer->wasRecentlyCreated) {
            EngineerProfile::factory()->create([
                'user_id'        => $testEngineer->id,
                'first_name'     => 'Ahmad',
                'last_name'      => 'Al-Ali',
                'specialization' => 'Civil Engineer',
            ]);
        }


        // 2. إنشاء 10 مهندسين آخرين عشوائيين مع حساباتهم وملفاتهم بالكامل
        User::factory()
            ->count(10)
            ->create([
                'role_id' => 4, // تم تعديلها لتطابق الـ role_id للمهندس الثابت (3) تجنباً للمشاكل
                'status'  => 'active'
            ])
            ->each(function ($user) {
                // إنشاء ملف المهندس الموحد فقط
                EngineerProfile::factory()->create([
                    'user_id' => $user->id,
                ]);
            });
    }
}
