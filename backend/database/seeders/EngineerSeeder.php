<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\UserProfile;
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
        // 1. إنشاء حساب مهندس ثابت للتجربة والاختبار (أو جلب الحساب إذا كان موجوداً مسبقاً)
        $testEngineer = User::firstOrCreate(
            ['email' => 'engineer@test.com'], // الشرط: البحث عن هذا الإيميل أولاً لمنع التكرار
            [
                'name'         => 'Engineer Ahmad',
                'password'     => Hash::make('password'), // كلمة المرور الموحدة للتجربة
                'status'       => 'active',
                'role_id'      => 3, // غير الرقم حسب قيمة صلاحية المهندس (Engineer) عندك بالسيستم
                'otp_verified' => true,
            ]
        );

        // ربط الحساب الثابت بالـ Profiles (يتم الإنشاء فقط إذا كان الحساب قد أُنشئ للتو)
        if ($testEngineer->wasRecentlyCreated) {
            UserProfile::factory()->create([
                'user_id'    => $testEngineer->id,
                'first_name' => 'Ahmad',
                'last_name'  => 'Al-Ali',
            ]);

            EngineerProfile::factory()->create([
                'user_id'        => $testEngineer->id,
                'specialization' => 'Civil Engineer',
            ]);
        }


        // 2. إنشاء 10 مهندسين آخرين عشوائيين مع حساباتهم وملفاتهم بالكامل
        User::factory()
            ->count(10)
            ->create([
                'role_id' => 4, // تأكد من مطابقة الـ role_id للمهندسين العشوائيين
                'status'  => 'active'
            ])
            ->each(function ($user) {
                // إنشاء الملف الشخصي العام وربطه بالمهندس
                UserProfile::factory()->create([
                    'user_id' => $user->id,
                ]);

                // إنشاء ملف المهندس المختص وربطه بالمهندس
                EngineerProfile::factory()->create([
                    'user_id' => $user->id,
                ]);
            });
    }
}
