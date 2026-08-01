<?php

namespace Database\Factories;

use App\Models\Wallet;
use Illuminate\Database\Eloquent\Factories\Factory;

class WalletFactory extends Factory
{
    protected $model = Wallet::class;

    public function definition(): array
    {
        return [
            'user_id'     => null,
            'balance'     => 100000.00,
            'card_number' => fake()->unique()->numerify('####'),
        ];
    }

    public function withBalance(float $amount): static
    {
        return $this->state(fn() => ['balance' => $amount]);
    }
}