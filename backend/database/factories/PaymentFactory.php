<?php

namespace Database\Factories;

use App\Models\ConstructionForm;
use App\Models\Payment;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class PaymentFactory extends Factory
{
    protected $model = Payment::class;

    public function definition(): array
    {
        return [
            'construction_form_id' => ConstructionForm::factory(),
            'user_id'              => User::factory()->asUser(),
            'amount'               => fake()->numberBetween(100000, 500000),
            'type'                 => fake()->randomElement(['first_payment', 'second_payment', 'final_payment']),
            'status'               => 'pending',
            'paid_at'              => null,
            'released_amount'      => 0,
        ];
    }

    public function paid(): static
    {
        return $this->state(fn() => [
            'status'  => 'paid',
            'paid_at' => now(),
        ]);
    }

    public function released(): static
    {
        return $this->state(fn() => [
            'status'          => 'released',
            'paid_at'         => now(),
            'released_amount' => $this->amount ?? 300000,
        ]);
    }
}