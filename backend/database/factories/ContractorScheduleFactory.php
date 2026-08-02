<?php

namespace Database\Factories;

use App\Models\ContractorSchedule;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class ContractorScheduleFactory extends Factory
{
    protected $model = ContractorSchedule::class;

    public function definition(): array
    {
        return [
            'contractor_id' => User::factory()->asContractor(),
            'day_of_week'   => fake()->randomElement(['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']),
            'start_time'    => '09:00:00',
            'end_time'      => '17:00:00',
        ];
    }

    // للاختبار: جعل وقت الانتهاء في الماضي
    public function ended(): static
    {
        return $this->state(fn() => [
            'start_time' => '08:00:00',
            'end_time'   => '09:00:00',
        ]);
    }

    // للاختبار: جعل وقت الانتهاء في المستقبل
    public function upcoming(): static
    {
        return $this->state(fn() => [
            'start_time' => '22:00:00',
            'end_time'   => '23:59:00',
        ]);
    }
}
