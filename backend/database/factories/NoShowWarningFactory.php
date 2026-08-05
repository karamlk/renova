<?php

namespace Database\Factories;

use App\Models\NoShowWarning;
use App\Models\Role;
use App\Models\SiteVisit;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class NoShowWarningFactory extends Factory
{
    protected $model = NoShowWarning::class;

    public function definition(): array
    {
        return [
            'site_visit_id'    => SiteVisit::factory()->missed(),
            'reporter_id'      => User::factory()->asUser(),
            'reported_id'      => User::factory()->asContractor(),
            'reporter_role_id' => Role::where('name', 'user')->first()?->id ?? 2,
            'reported_role_id' => Role::where('name', 'contractor')->first()?->id ?? 3,
            'type'             => 'no_show',
            'reason'           => 'عدم الحضور إلى الزيارة الميدانية',
            'description'      => 'عدم حضور المستخدم إلى الزيارة الميدانية',
            'penalty_applied'  => false,
        ];
    }

    public function penalized(): static
    {
        return $this->state(fn() => ['penalty_applied' => true]);
    }
}