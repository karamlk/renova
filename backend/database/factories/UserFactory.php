<?php

namespace Database\Factories;

use App\Models\Role;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class UserFactory extends Factory
{
    protected $model = User::class;
    protected static ?string $password;

    public function definition(): array
    {
        return [
            'name'             => fake()->name(),
            'email'            => fake()->unique()->safeEmail(),
            'password'         => static::$password ??= Hash::make('password'),
            'remember_token'   => Str::random(10),
            'role_id'          => Role::where('name', 'user')->first()?->id ?? 2,
            'status'           => 'approved',
            'otp_verified'     => true,
            'is_active'        => true,
        ];
    }

    public function asUser(): static
    {
        return $this->state(fn() => [
            'role_id' => Role::where('name', 'user')->first()?->id ?? 2,
            'status'  => 'approved',
        ]);
    }

    public function asContractor(): static
    {
        return $this->state(fn() => [
            'role_id' => Role::where('name', 'contractor')->first()?->id ?? 3,
            'status'  => 'approved',
        ]);
    }

    public function asEngineer(): static
    {
        return $this->state(fn() => [
            'role_id' => Role::where('name', 'engineer')->first()?->id ?? 4,
            'status'  => 'approved',
        ]);
    }

    public function asAdmin(): static
    {
        return $this->state(fn() => [
            'role_id' => Role::where('name', 'admin')->first()?->id ?? 1,
            'status'  => 'approved',
        ]);
    }

    public function pending(): static
    {
        return $this->state(fn() => ['status' => 'pending']);
    }

    public function inactive(): static
    {
        return $this->state(fn() => ['is_active' => false]);
    }

    public function unverified(): static
    {
        return $this->state(fn() => ['otp_verified' => false]);
    }
}
