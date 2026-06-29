<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\ContractorProfile;
use Illuminate\Database\Seeder;

class ContractorProfileSeeder extends Seeder
{
    public function run(): void
    {
        $images = [
            'contractors/request1.jpg',
            'contractors/request2.jpg',
            'contractors/request3.jpg',
        ];
        $contractors = User::whereHas(
            'role',
            function ($query) {

                $query->where(
                    'name',
                    'contractor'
                );
            }
        )->get();

        foreach ($contractors as $contractor) {

            ContractorProfile::firstOrCreate(
                [
                    'user_id' => $contractor->id
                ],
                [
                    'first_name' => fake()->firstName(),
                    'last_name' => fake()->lastName(),
                    'phone' => fake()->numerify('09########'),
                    'location' => fake()->city(),
                    'company_name' => fake()->company(),
                    'image' => $images[array_rand($images)],

                    'commercial_record' =>
                        'contractors/request1.jpg',

                ]

            );
        }
    }
}
