<?php

namespace Database\Factories;

use App\Models\ConstructionForm;
use App\Models\ReconstructionRequest;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class ConstructionFormFactory extends Factory
{
    protected $model = ConstructionForm::class;

    public function definition(): array
    {
        $materials = fake()->numberBetween(100000, 600000);
        $labor     = fake()->numberBetween(50000, 300000);
        $profit    = fake()->numberBetween(20000, 150000);

        return [
            'reconstruction_request_id' => ReconstructionRequest::factory(),
            'contractor_id'             => User::factory()->asContractor(),
            'engineer_id'               => User::factory()->asEngineer(),
            'building_description'      => fake()->paragraph(),
            'warranty_period'           => '12 months',
            'execution_duration'        => '6 months',
            'materials_cost'            => $materials,
            'labor_cost'                => $labor,
            'profit'                    => $profit,
            'total_cost'                => $materials + $labor + $profit,
            'status'                    => 'user_approved',
        ];
    }

    public function approved(): static
    {
        return $this->state(fn() => ['status' => 'user_approved']);
    }

    public function pending(): static
    {
        return $this->state(fn() => ['status' => 'pending_engineer']);
    }

    public function withTotalCost(float $amount): static
    {
        return $this->state(fn() => [
            'materials_cost' => $amount * 0.6,
            'labor_cost'     => $amount * 0.25,
            'profit'         => $amount * 0.15,
            'total_cost'     => $amount,
        ]);
    }
}
