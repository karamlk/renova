<?php

namespace Database\Factories;

use App\Models\ReconstructionRequest;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class ReconstructionRequestFactory extends Factory
{
    protected $model = ReconstructionRequest::class;

    public function definition(): array
    {
        return [
            'user_id'     => User::factory()->asUser(),
            'title'       => fake()->sentence(3),
            'description' => fake()->paragraph(),
            'location'    => fake()->city(),
            'type'        => fake()->randomElement(['restoration', 'construction', 'finishing']),
            'status'      => 'open',
        ];
    }
}
