<?php

namespace Database\Seeders;


use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        //
        User::create([
            'name'              => 'Admin', // اسم الأدمن
            'email'             => 'admin@example.com', // إيميل الأدمن
            'email_verified_at' => now(), // تأكيد الإيميل (الوقت الحالي)
            'password'          => Hash::make('password123'), // كلمة المرور (مشفرة)
            'role_id'           => 1, // رقم صلاحية الأدمن
        ]);
    }
}
