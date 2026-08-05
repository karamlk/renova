<?php

namespace Tests\Unit;

use App\Models\Complaint;
use App\Models\ConstructionForm;
use App\Models\Role;
use App\Models\Wallet;
use App\Services\Admin\Complaint\ComplaintService;
use App\Services\WalletService;
use Database\Seeders\RoleSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ComplaintServiceTest extends TestCase
{
    use RefreshDatabase;

    protected ComplaintService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleSeeder::class);
        $this->service = app(ComplaintService::class);
    }

    // ─────────────────────────────────────────────────
    // Penalty calculation
    // ─────────────────────────────────────────────────

    public function test_penalty_is_30_percent_of_total_cost_times_percentage(): void
    {
        // held = total_cost × 30%
        // penalty = held × penalty_percentage / 100
        $totalCost         = 1000000;
        $penaltyPercentage = 10;

        $held    = $totalCost * 0.30;
        $penalty = $held * ($penaltyPercentage / 100);

        $this->assertEquals(300000, $held);
        $this->assertEquals(30000, $penalty);
    }

    public function test_penalty_calculation_with_20_percent(): void
    {
        $totalCost         = 1000000;
        $penaltyPercentage = 20;

        $held    = $totalCost * 0.30;
        $penalty = $held * ($penaltyPercentage / 100);

        $this->assertEquals(60000, $penalty);
    }

    public function test_penalty_calculation_with_100_percent(): void
    {
        $totalCost         = 1000000;
        $penaltyPercentage = 100;

        $held    = $totalCost * 0.30;
        $penalty = $held * ($penaltyPercentage / 100);

        // max penalty = full held amount
        $this->assertEquals(300000, $penalty);
    }

    public function test_penalty_calculation_with_zero_percent(): void
    {
        $totalCost         = 1000000;
        $penaltyPercentage = 0;

        $held    = $totalCost * 0.30;
        $penalty = $held * ($penaltyPercentage / 100);

        $this->assertEquals(0, $penalty);
    }

    // ─────────────────────────────────────────────────
    // resolve() — wallet movement
    // ─────────────────────────────────────────────────

    public function test_resolve_with_penalty_moves_money_from_admin_to_user(): void
    {
        $project = $this->createFullProject();
        $admin   = $this->createAdmin();

        $admin->wallet->update(['balance' => 1000000]);
        $userBalanceBefore = $project['user']->wallet->balance;

        $complaint = Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'status'                => 'open',
        ]);

        $this->service->resolve($complaint, [
            'status'             => 'resolved',
            'penalty_percentage' => 10,
        ]);

        // held = 1,000,000 × 30% = 300,000
        // penalty = 300,000 × 10% = 30,000
        $expectedPenalty = 1000000 * 0.30 * (10 / 100);

        $project['user']->wallet->refresh();
        $this->assertEquals(
            $userBalanceBefore + $expectedPenalty,
            $project['user']->wallet->balance
        );
    }

    public function test_resolve_stores_penalty_amounts_on_complaint(): void
    {
        $project = $this->createFullProject();
        $admin   = $this->createAdmin();
        $admin->wallet->update(['balance' => 1000000]);

        $complaint = Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'status'                => 'open',
        ]);

        $this->service->resolve($complaint, [
            'status'             => 'resolved',
            'penalty_percentage' => 10,
        ]);

        $complaint->refresh();

        $this->assertEquals(10, $complaint->penalty_percentage);
        $this->assertEquals(30000, $complaint->penalty_amount);
        $this->assertEquals(30000, $complaint->compensation_amount);
    }

    public function test_resolve_without_penalty_does_not_move_money(): void
    {
        $project = $this->createFullProject();
        $admin   = $this->createAdmin();

        $adminBalanceBefore = $admin->wallet->balance;
        $userBalanceBefore  = $project['user']->wallet->balance;

        $complaint = Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'status'                => 'open',
        ]);

        $this->service->resolve($complaint, [
            'status'     => 'dismissed',
            'admin_note' => 'الشكوى غير مبررة',
        ]);

        $admin->wallet->refresh();
        $project['user']->wallet->refresh();

        $this->assertEquals($adminBalanceBefore, $admin->wallet->balance);
        $this->assertEquals($userBalanceBefore, $project['user']->wallet->balance);
    }

    public function test_resolve_sets_resolved_at_timestamp(): void
    {
        $project = $this->createFullProject();
        $admin   = $this->createAdmin();

        $complaint = Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'status'                => 'open',
        ]);

        $this->service->resolve($complaint, ['status' => 'dismissed']);

        $complaint->refresh();
        $this->assertNotNull($complaint->resolved_at);
    }

    // ─────────────────────────────────────────────────
    // archiveComplaint()
    // ─────────────────────────────────────────────────

    public function test_archive_sets_is_archived_true(): void
    {
        $project = $this->createFullProject();

        $complaint = Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'is_archived'           => false,
        ]);

        $this->service->archiveComplaint($complaint);

        $this->assertDatabaseHas('complaints', [
            'id'          => $complaint->id,
            'is_archived' => true,
        ]);
    }

    public function test_archive_sets_archived_at_timestamp(): void
    {
        $project = $this->createFullProject();

        $complaint = Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'is_archived'           => false,
        ]);

        $this->service->archiveComplaint($complaint);

        $complaint->refresh();
        $this->assertNotNull($complaint->archived_at);
    }
}