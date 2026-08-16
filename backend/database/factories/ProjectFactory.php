<?php

namespace Database\Factories;

use App\Models\ConstructionForm;
use App\Models\Project;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Project>
 */
class ProjectFactory extends Factory
{
    protected $model = Project::class;

    public function definition(): array
    {
        return [
            'construction_form_id' => ConstructionForm::factory(),

            'contractor_id' => User::factory()->asContractor()->create()->id,

            'engineer_id' => User::factory()->asEngineer()->create()->id,

            'user_id' => User::factory()->asUser()->create()->id,

            'progress' => fake()->randomFloat(2, 0, 100),

            'status' => fake()->randomElement([
                'active',
                'completed',
                'cancelled',
            ]),

            'project_ends_at' => fake()->dateTimeBetween(
                '-2 years',
                'now'
            ),

            'warranty_ends_at' => fake()->dateTimeBetween(
                '+1 year',
                '+4 years'
            ),
        ];
    }

    public function active(): static
    {
        return $this->state([
            'status' => 'active',
            'progress' => fake()->randomFloat(2, 0, 99),
        ]);
    }

    public function completed(): static
    {
        return $this->state([
            'status' => 'completed',
            'progress' => 100,
        ]);
    }

    public function cancelled(): static
    {
        return $this->state([
            'status' => 'cancelled',
        ]);
    }
}
