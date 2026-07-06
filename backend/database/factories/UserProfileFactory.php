<?php

namespace Database\Factories;

use App\Models\UserProfile;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class UserProfileFactory extends Factory
{
    protected $model = UserProfile::class;

    public function definition(): array
    {
        return [
            'user_id'    => User::factory(),
            'first_name' => fake()->firstName(),
            'last_name'  => fake()->lastName(),
            'phone'      => fake()->phoneNumber(),
            'image'      => 'profiles/default_avatar.png', // مسار وهمي للصورة
            'location'   => fake()->city(),
        ];
    }
}
