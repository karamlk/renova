<?php

namespace Database\Factories;

use App\Models\EngineerProfile;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class EngineerProfileFactory extends Factory
{
    protected $model = EngineerProfile::class;

    public function definition(): array
    {
        return [
            'user_id'             => User::factory(),
            'specialization'      => fake()->randomElement(['Civil Engineer', 'Architect', 'Electrical Engineer', 'Mechanical Engineer']),
            'syndicate_number'    => fake()->unique()->numberBetween(10000, 99999),
            'degree'              => fake()->randomElement(['Bachelor', 'Master', 'PhD']),
            'years_of_experience' => fake()->numberBetween(2, 25),
            // نفترض أنها مخزنة كـ array أو JSON أو نص عادي بناءً على موديلك
            'covered_zones'       => fake()->randomElement(['Zone A, Zone B', 'North Region', 'Downtown']),
            'bio'                 => fake()->paragraph(),
            'syndicate_card_image'=> 'engineer_docs/default_card.png',
            'certificate_file'    => 'engineer_docs/default_cert.pdf',
            'is_verified'         => fake()->boolean(80), // 80% من المهندسين موثقين تلقائياً
        ];
    }
}
