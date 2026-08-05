<?php

namespace Tests\Feature;

use App\Models\ConstructionForm;
use App\Models\ConstructionMaterial;
use App\Models\ReconstructionRequest;
use App\Models\Wallet;
use Database\Seeders\RoleSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ConstructionFormWorkflowTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleSeeder::class);
        Storage::fake('public');
    }

    // ─────────────────────────────────────────────────
    // Contractor creates a form
    // ─────────────────────────────────────────────────

    public function test_contractor_can_create_construction_form(): void
    {
        $project = $this->createFullProject();

        $response = $this->withHeaders($this->authHeaders($project['contractor']))
            ->postJson('/api/construction-forms', [
                'reconstruction_request_id' => $project['request']->id,
                'engineer_id'               => $project['engineer']->id,
                'contractor_id'             =>$project['contractor']->id,
                'building_description'      => 'مبنى سكني من طابقين',
                'warranty_period'           => '12 months',
                'execution_duration'        => '6 months',
                'materials_cost'            => 500000,
                'labor_cost'                => 300000,
                'profit'                    => 200000,
            ]);

        $response->assertStatus(201);

        $this->assertDatabaseHas('construction_forms', [
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'status'                    => 'pending_engineer',
            'total_cost'                => 1000000,
        ]);
    }

    public function test_total_cost_is_calculated_automatically(): void
    {
        $project = $this->createFullProject();

        $response = $this->withHeaders($this->authHeaders($project['contractor']))
            ->postJson('/api/construction-forms', [
                'reconstruction_request_id' => $project['request']->id,
                'engineer_id'               => $project['engineer']->id,
                'contractor_id'=>$project['contractor']->id,
                'building_description'      => 'بناء عبارة عن ثلاث طوابق وكراج',
                'warranty_period'           => '12 months',
                'execution_duration'        => '6 months',
                'materials_cost'            => 300000,
                'labor_cost'                => 150000,
                'profit'                    => 50000,
            ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('construction_forms', ['total_cost' => 500000]);
    }

    public function test_contractor_can_create_form_with_materials(): void
    {
        $project = $this->createFullProject();

        $materials = json_encode([
            ['material_name' => 'cement', 'material_type' => 'binding', 'quantity' => 100, 'unit' => 'bag', 'unit_price' => 5000],
            ['material_name' => 'steel',  'material_type' => 'structure', 'quantity' => 50,  'unit' => 'ton', 'unit_price' => 20000],
        ]);

        $response = $this->withHeaders($this->authHeaders($project['contractor']))
            ->postJson('/api/construction-forms', [
                'reconstruction_request_id' => $project['request']->id,
                'engineer_id'               => $project['engineer']->id,
                'contractor_id'=>$project['contractor']->id,
                'building_description'      => 'بناء عبارة عن ثلاث طوابق وكراج',
                'warranty_period'           => '12 months',
                'execution_duration'        => '6 months',
                'materials_cost'            => 500000,
                'labor_cost'                => 300000,
                'profit'                    => 200000,
                'materials'                 => $materials,
            ]);

        $response->assertStatus(201);
        $this->assertDatabaseCount('construction_materials', 2);
    }

    public function test_user_cannot_create_construction_form(): void
    {
        $project = $this->createFullProject();

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/construction-forms', [
                'reconstruction_request_id' => $project['request']->id,
                'engineer_id'               => $project['engineer']->id,
                'building_description'      => 'وصف',
                'warranty_period'           => '12 months',
                'execution_duration'        => '6 months',
                'materials_cost'            => 500000,
                'labor_cost'                => 300000,
                'profit'                    => 200000,
            ])
            ->assertStatus(403);
    }

    // ─────────────────────────────────────────────────
    // Contractor updates a form
    // ─────────────────────────────────────────────────

    public function test_contractor_can_update_pending_engineer_form(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        $response = $this->withHeaders($this->authHeaders($project['contractor']))
            ->postJson("/api/construction-forms/{$form->id}", [
                'reconstruction_request_id' => $project['request']->id,
                'engineer_id'               => $project['engineer']->id,
                'contractor_id'             =>$project['contractor']->id,
                'building_description'      => 'بناء عبارة عن ثلاث طوابق وكراج',
                'warranty_period'           => '6 months',
                'execution_duration'        => '3 months',
                'materials_cost'            => 400000,
                'labor_cost'                => 200000,
                'profit'                    => 100000,
            ]);

        $response->assertStatus(200);
        $this->assertDatabaseHas('construction_forms', [
            'id'     => $form->id,
            'status' => 'pending_engineer', // resets back to pending_engineer
        ]);
    }

    public function test_contractor_cannot_update_form_after_engineer_approval(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
            'status'                    => 'pending_user', // already approved by engineer
        ]);

        $this->withHeaders($this->authHeaders($project['contractor']))
            ->postJson("/api/construction-forms/{$form->id}", [
                'reconstruction_request_id' => $project['request']->id,
                'engineer_id'               => $project['engineer']->id,
                'building_description'      => 'محاولة تعديل',
                'warranty_period'           => '6 months',
                'execution_duration'        => '3 months',
                'materials_cost'            => 400000,
                'labor_cost'                => 200000,
                'profit'                    => 100000,
            ])
            ->assertStatus(422);
    }

    // ─────────────────────────────────────────────────
    // Engineer reviews the form
    // ─────────────────────────────────────────────────

    public function test_engineer_can_approve_form(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        $response = $this->withHeaders($this->authHeaders($project['engineer']))
            ->putJson("/api/construction-forms/{$form->id}/engineer-review", [
                'status'         => 'engineer_approved',
                'engineer_notes' => 'كل شيء على ما يرام',
            ]);

        $response->assertStatus(200);
        $this->assertDatabaseHas('construction_forms', [
            'id'     => $form->id,
            'status' => 'pending_user',
        ]);
    }

    public function test_engineer_can_reject_form(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        $response = $this->withHeaders($this->authHeaders($project['engineer']))
            ->putJson("/api/construction-forms/{$form->id}/engineer-review", [
                'status'         => 'engineer_rejected',
                'engineer_notes' => 'يوجد أخطاء في التكاليف',
            ]);

        $response->assertStatus(200);
        $this->assertDatabaseHas('construction_forms', [
            'id'     => $form->id,
            'status' => 'engineer_rejected',
        ]);
    }

    public function test_engineer_cannot_review_form_not_in_pending_engineer_status(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
            'status'                    => 'pending_user', // already reviewed
        ]);

        $this->withHeaders($this->authHeaders($project['engineer']))
            ->putJson("/api/construction-forms/{$form->id}/engineer-review", [
                'status' => 'engineer_approved',
            ])
            ->assertStatus(422);
    }

    public function test_user_cannot_do_engineer_review(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        $this->withHeaders($this->authHeaders($project['user']))
            ->putJson("/api/construction-forms/{$form->id}/engineer-review", [
                'status' => 'engineer_approved',
            ])
            ->assertStatus(403);
    }

    // ─────────────────────────────────────────────────
    // User reviews the form
    // ─────────────────────────────────────────────────

    public function test_user_can_reject_form(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
            'status'                    => 'pending_user',
        ]);

        $response = $this->withHeaders($this->authHeaders($project['user']))
            ->putJson("/api/construction-forms/{$form->id}/user-review", [
                'status'     => 'user_rejected',
                'user_notes' => 'التكاليف مرتفعة جداً',
            ]);

        $response->assertStatus(200);
        $this->assertDatabaseHas('construction_forms', [
            'id'     => $form->id,
            'status' => 'user_rejected',
        ]);
    }

    public function test_user_cannot_review_form_before_engineer_approval(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        $this->withHeaders($this->authHeaders($project['user']))
            ->putJson("/api/construction-forms/{$form->id}/user-review", [
                'status' => 'user_approved',
            ])
            ->assertStatus(422);
    }

    public function test_contractor_cannot_do_user_review(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
            'status'                    => 'pending_user',
        ]);

        $this->withHeaders($this->authHeaders($project['contractor']))
            ->putJson("/api/construction-forms/{$form->id}/user-review", [
                'status' => 'user_approved',
            ])
            ->assertStatus(403);
    }

    // ─────────────────────────────────────────────────
    // Deleting a form
    // ─────────────────────────────────────────────────

    public function test_contractor_can_delete_their_form(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        $this->withHeaders($this->authHeaders($project['contractor']))
            ->deleteJson("/api/construction-forms/{$form->id}")
            ->assertStatus(200);

        $this->assertDatabaseMissing('construction_forms', ['id' => $form->id]);
    }

    /**
     * BUG EXPOSURE: deleteForm() has no ownership check.
     * Any contractor can delete any form.
     * This test will FAIL until an ownership check is added.
     */
    public function test_another_contractor_cannot_delete_form(): void
    {
        $project           = $this->createFullProject();
        $anotherContractor = $this->createContractor();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        $this->withHeaders($this->authHeaders($anotherContractor))
            ->deleteJson("/api/construction-forms/{$form->id}")
            ->assertStatus(403);
    }

    public function test_user_cannot_delete_construction_form(): void
    {
        $project = $this->createFullProject();

        $form = ConstructionForm::factory()->pending()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        $this->withHeaders($this->authHeaders($project['user']))
            ->deleteJson("/api/construction-forms/{$form->id}")
            ->assertStatus(403);
    }

    // ─────────────────────────────────────────────────
    // Viewing forms
    // ─────────────────────────────────────────────────

    public function test_contractor_can_view_their_own_forms(): void
    {
        $project = $this->createFullProject();

        ConstructionForm::factory()->count(3)->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
        ]);

        $response = $this->withHeaders($this->authHeaders($project['contractor']))
            ->getJson('/api/construction-forms');

        $response->assertStatus(200);
        $this->assertCount(4, $response->json());
    }

    public function test_user_can_view_their_received_forms(): void
    {
        $project = $this->createFullProject();

        ConstructionForm::factory()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
            'status'                    => 'pending_user',
        ]);

      $user = $project['user'];
    $user->load('role');

    $form = $project['form'];
    $form->update(['status' => 'pending_user']);
    
    $form->reconstructionRequest->update([
        'user_id' => $user->id
    ]);

    // 2. Force Sanctum to authenticate the user and register their role
    Sanctum::actingAs($user, ['*']);

    // 3. Make the API request cleanly without manual header arrays
    $response = $this->getJson('/api/receivedForms');

    // 4. Fallback trace dump (Will print details if it still fails)
    if ($response->status() === 403) {
        dd([
            'Response JSON' => $response->json(),
            'User Role name in Test' => $user->role->name,
            'Middleware Expected Roles Debug' => 'Ensure the route group says role:user'
        ]);
    }

    // 5. Assertions
    $response->assertStatus(200);
    $this->assertNotEmpty($response->json());
    }

    public function test_user_cannot_view_another_users_form(): void
    {
        $project   = $this->createFullProject();
        $otherUser = $this->createUser();

        $form = ConstructionForm::factory()->create([
            'reconstruction_request_id' => $project['request']->id,
            'contractor_id'             => $project['contractor']->id,
            'engineer_id'               => $project['engineer']->id,
            'status'                    => 'pending_user',
        ]);

        $this->withHeaders($this->authHeaders($otherUser))
            ->getJson("/api/showForm/{$form->id}")
            ->assertStatus(403);
    }
}