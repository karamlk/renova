<?php

namespace Tests;

use App\Models\ConstructionForm;
use App\Models\ContractorSchedule;
use App\Models\InspectionRequest;
use App\Models\Project;
use App\Models\ReconstructionRequest;
use App\Models\Role;
use App\Models\SiteVisit;
use App\Models\User;
use App\Models\Wallet;
use Illuminate\Foundation\Testing\TestCase as BaseTestCase;

abstract class TestCase extends BaseTestCase
{
    // ── Helper: create user by role ──────────────────
    protected function createUser(array $attrs = []): User
    {
        $user = User::factory()->asUser()->create($attrs);
        Wallet::factory()->create(['user_id' => $user->id]);
        return $user;
    }

    protected function createContractor(array $attrs = []): User
    {
        $user = User::factory()->asContractor()->create($attrs);
        Wallet::factory()->create(['user_id' => $user->id]);
        return $user;
    }

    protected function createEngineer(array $attrs = []): User
    {
        $user = User::factory()->asEngineer()->create($attrs);
        Wallet::factory()->create(['user_id' => $user->id]);
        return $user;
    }

    protected function createAdmin(array $attrs = []): User
    {
        $user = User::factory()->asAdmin()->create($attrs);
        Wallet::factory()->create(['user_id' => $user->id, 'balance' => 1000000]);
        return $user;
    }

    // ── Helper: create a full project chain ──────────
    // ── Helper: create a full project chain ──────────
    protected function createFullProject(array $attrs = []): array
    {
        $user       = $this->createUser();
        $contractor = $this->createContractor();
        $engineer   = $this->createEngineer();

        $request = ReconstructionRequest::factory()->create([
            'user_id' => $user->id,
        ]);

        $inspectionRequest = InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'accepted',
        ]);

        $schedule = ContractorSchedule::factory()->ended()->create([
            'contractor_id' => $contractor->id,
        ]);

        $siteVisit = SiteVisit::factory()->create([
            'inspection_request_id' => $inspectionRequest->id,
            'schedule_id'           => $schedule->id,
            'engineer_id'            => $engineer->id,
            'status'                => 'accepted',
        ]);

        $form = ConstructionForm::factory()
            ->approved()
            ->withTotalCost(1000000)
            ->create([
                'reconstruction_request_id' => $request->id,
                'contractor_id'             => $contractor->id,
                'engineer_id'               => $engineer->id,
            ]);

        $project = Project::factory()->create(array_merge([
            'construction_form_id' => $form->id,
            'contractor_id'        => $contractor->id,
            'engineer_id'          => $engineer->id,
            'user_id'              => $user->id,
            'progress'             => 100,
            'status'               => 'active',
            'project_ends_at'      => '2026-06-30',
            'warranty_ends_at'     => '2029-06-30',
        ], $attrs));

        return compact(
            'user',
            'contractor',
            'engineer',
            'request',
            'inspectionRequest',
            'schedule',
            'siteVisit',
            'form',
            'project'
        );
    }

    // ── Helper: login and get token ──────────────────
    protected function tokenFor(User $user): string
    {
        return $user->createToken('test')->plainTextToken;
    }

    protected function authHeaders(User $user): array
    {
        return [
            'Authorization' => 'Bearer ' . $this->tokenFor($user),
            'Accept'        => 'application/json',
        ];
    }
}
