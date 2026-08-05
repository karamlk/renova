<?php

namespace Database\Factories;

use App\Models\Complaint;
use App\Models\ConstructionForm;
use App\Models\Role;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class ComplaintFactory extends Factory
{
    protected $model = Complaint::class;

    public function definition(): array
    {
        return [
            'complainant_id'        => User::factory()->asUser(),
            'complained_on_id'      => User::factory()->asContractor(),
            'construction_form_id'  => ConstructionForm::factory(),
            'complainant_role_id'   => Role::where('name', 'user')->first()?->id ?? 2,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()?->id ?? 3,
            'type'                  => 'general',
            'reason'                => 'رداءة جودة العمل',
            'description'           => fake()->optional()->sentence(),
            'status'                => 'open',
            'admin_processing_note' => null,
            'penalty_percentage'    => null,
            'penalty_amount'        => null,
            'compensation_amount'   => null,
            'resolved_at'           => null,
        ];
    }

    public function resolved(): static
    {
        return $this->state(fn() => [
            'status'      => 'resolved',
            'resolved_at' => now(),
        ]);
    }

    public function dismissed(): static
    {
        return $this->state(fn() => [
            'status'      => 'dismissed',
            'resolved_at' => now(),
        ]);
    }
}