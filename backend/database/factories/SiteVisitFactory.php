<?php

namespace Database\Factories;

use App\Models\ContractorSchedule;
use App\Models\InspectionRequest;
use App\Models\SiteVisit;
use Illuminate\Database\Eloquent\Factories\Factory;

class SiteVisitFactory extends Factory
{
    protected $model = SiteVisit::class;

    public function definition(): array
    {
        return [
            'inspection_request_id' => InspectionRequest::factory(),
            'schedule_id'           => ContractorSchedule::factory(),
            'engineer_id'           => null,
            'status'                => 'pending',
            // Default: visit already happened yesterday, so the test works that
            // doesn't care about the date
            'visit_date'            => now()->subDay()->format('Y-m-d'),
        ];
    }

    public function missed(): static
    {
        return $this->state(fn () => ['status' => 'missed']);
    }

    public function accepted(): static
    {
        return $this->state(fn () => ['status' => 'accepted']);
    }

    public function completed(): static
    {
        return $this->state(fn () => ['status' => 'completed']);
    }

    public function onDate($date): static
    {
        return $this->state(fn () => [
            'visit_date' => \Carbon\Carbon::parse($date)->format('Y-m-d'),
        ]);
    }

    public function upcoming(): static
    {
        return $this->state(fn () => [
            'visit_date' => now()->addWeek()->format('Y-m-d'),
        ]);
    }

    public function today(): static
    {
        return $this->state(fn () => [
            'visit_date' => now()->format('Y-m-d'),
        ]);
    }
}