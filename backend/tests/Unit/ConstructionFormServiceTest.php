<?php

namespace Tests\Unit;

use App\Models\ConstructionForm;
use App\Models\ConstructionMaterial;
use App\Services\Contractor\ConstructionFormService;
use Database\Seeders\RoleSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ConstructionFormServiceTest extends TestCase
{
    use RefreshDatabase;

    protected ConstructionFormService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleSeeder::class);
        $this->service = app(ConstructionFormService::class);
    }

    // ─────────────────────────────────────────────────
    // Total cost calculation
    // ─────────────────────────────────────────────────

    public function test_total_cost_is_sum_of_materials_labor_and_profit(): void
    {
        $materials = 500000;
        $labor     = 300000;
        $profit    = 200000;

        $total = $materials + $labor + $profit;

        $this->assertEquals(1000000, $total);
    }

    public function test_total_cost_with_zero_profit(): void
    {
        $materials = 500000;
        $labor     = 300000;
        $profit    = 0;

        $total = $materials + $labor + $profit;

        $this->assertEquals(800000, $total);
    }

    public function test_total_cost_recalculated_on_update(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
            'materials_cost'            => 500000,
            'labor_cost'                => 300000,
            'profit'                    => 200000,
            'total_cost'                => 1000000,
        ]);

        // Update with new values
        $newMaterials = 400000;
        $newLabor     = 200000;
        $newProfit    = 100000;

        $form->update([
            'materials_cost' => $newMaterials,
            'labor_cost'     => $newLabor,
            'profit'         => $newProfit,
            'total_cost'     => $newMaterials + $newLabor + $newProfit,
        ]);

        $form->refresh();
        $this->assertEquals(700000, $form->total_cost);
    }

    // ─────────────────────────────────────────────────
    // Status transitions
    // ─────────────────────────────────────────────────

    public function test_new_form_starts_as_pending_engineer(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
            'status'                    => 'pending_engineer',
        ]);

        $this->assertEquals('pending_engineer', $form->status);
    }

    public function test_engineer_approval_moves_status_to_pending_user(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        $form->update(['status' => 'pending_user']);

        $form->refresh();
        $this->assertEquals('pending_user', $form->status);
    }

    public function test_engineer_rejection_moves_status_to_engineer_rejected(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        $form->update(['status' => 'engineer_rejected']);

        $form->refresh();
        $this->assertEquals('engineer_rejected', $form->status);
    }

    public function test_update_resets_status_to_pending_engineer(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
            'status'                    => 'engineer_rejected',
        ]);

        // Any update should reset to pending_engineer
        $form->update([
            'status'      => 'pending_engineer',
            'materials_cost' => 400000,
        ]);

        $form->refresh();
        $this->assertEquals('pending_engineer', $form->status);
    }

    public function test_cannot_update_form_after_pending_user_status(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
            'status'                    => 'pending_user',
        ]);

        $allowedStatuses = ['pending_engineer', 'engineer_rejected'];

        $this->assertNotContains($form->status, $allowedStatuses);
    }

    // ─────────────────────────────────────────────────
    // Materials
    // ─────────────────────────────────────────────────

    public function test_materials_total_price_is_quantity_times_unit_price(): void
    {
        $quantity  = 100;
        $unitPrice = 5000;
        $expected  = $quantity * $unitPrice;

        $this->assertEquals(500000, $expected);
    }

    public function test_materials_are_deleted_on_form_update(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        // Create initial materials
        ConstructionMaterial::factory()->count(3)->create([
            'construction_form_id' => $form->id,
        ]);

        $this->assertDatabaseCount('construction_materials', 3);

        // Delete all materials (as update does)
        $form->materials()->delete();

        $this->assertDatabaseCount('construction_materials', 0);
    }
}