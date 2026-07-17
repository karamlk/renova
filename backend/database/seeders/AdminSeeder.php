<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\UserProfile;
use App\Models\Wallet;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Storage;

class AdminSeeder extends Seeder
{
    public function run(): void
    {
        $admin = User::updateOrCreate(
            ['email' => 'admin@example.com'],
            [
                'name' => 'john',
                'role_id' => \App\Models\Role::where('name', 'admin')->first()->id,
                'status'  => 'approved',
                'password' => Hash::make('12345678'),
                'otp_verified' => true,
            ]
        );

        Wallet::firstOrCreate(
            ['user_id' => $admin->id],
            [
                'balance'     => 1000000.00,
                'card_number' => 'SD-ADMIN-' . rand(1000, 9999),
            ]
        );

        $source = database_path('seeders/images/admin.png');
        $imagePath = 'profiles/admin.png';

        Storage::disk('public')->put(
            $imagePath,
            file_get_contents($source)
        );

        UserProfile::updateOrCreate(
            ['user_id' => $admin->id],
            [
                'first_name' => 'Admin',
                'last_name'  => 'Renova',
                'phone'      => '+963000000000',
                'image'      => $imagePath,
                'location'   => 'Damascus',
            ]
        );
    }
}
