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
        $startTime = fake()->time('H:i:s', '12:00:00'); // وقت البداية قبل الظهر مثلاً

        return [
            // بيفترض إنك بتجيب ID مستخدم موجود أو بيعمل واحد جديد
            'contractor_id' => User::where('role_id', '3')->inRandomOrder()->first()?->id ?? User::factory(),
            'day_of_week'   => fake()->randomElement(['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday']),
            'start_time'    => $startTime,
            // وقت النهاية بيكون بعد وقت البداية بـ 4 لـ 8 ساعات
            'end_time'      => fake()->dateTimeInInterval($startTime, '+8 hours')->format('H:i:s'),
        ];
    }
}
