<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use App\Models\ReconstructionRequest;
use App\Models\ReconstructionRequestImage;

class

ReconstructionRequestSeeder extends Seeder
{
    public function run(): void
    {
        $users = User::whereHas(
            'role',
            fn($q) => $q->where('name', 'user')
        )->get();

        $images = [
            'requests/request1.jpg',
            'requests/request2.jpg',
            'requests/request3.jpg',
            'requests/request4.jpg',
            'requests/request5.jpg',
        ];

        foreach ($users as $user) {

            for ($i = 1; $i <= 3; $i++) {

                $request = ReconstructionRequest::create([
                    'user_id' => $user->id,
                    'title' => fake()->sentence(4),
                    'description' => fake()->paragraph(),
                    'location' => fake()->city(),
                    'type' => fake()->randomElement([
                     'restoration','construction','finishing'
                    ]),

                ]);

                $numberOfImages = rand(1, 3);

                for ($j = 0; $j < $numberOfImages; $j++) {

                    ReconstructionRequestImage::create([
                        'reconstruction_request_id' => $request->id,
                        'image' => $images[array_rand($images)],
                    ]);
                }
            }
        }
    }
}
