<?php

namespace Tests\Feature;

use App\Models\ContractorSchedule;
use App\Models\InspectionRequest;
use App\Models\ReconstructionRequest;
use App\Models\SiteVisit;
use Database\Seeders\RoleSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class InspectionWorkflowTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleSeeder::class);
    }

    // ─────────────────────────────────────────────────
    // Contractor sends inspection request
    // ─────────────────────────────────────────────────

    public function test_contractor_can_send_inspection_request(): void
    {
        $user       = $this->createUser();
        $contractor = $this->createContractor();
        $request    = ReconstructionRequest::factory()->create([
            'user_id' => $user->id,
            'status'  => 'open',
        ]);

        $response = $this->withHeaders($this->authHeaders($contractor))
            ->postJson('/api/inspection-requests', [
                'reconstruction_request_id' => $request->id,
            ]);

        $response->assertStatus(200);

        $this->assertDatabaseHas('inspection_requests', [
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'pending',
        ]);
    }

    public function test_contractor_cannot_send_duplicate_inspection_request(): void
    {
        $user       = $this->createUser();
        $contractor = $this->createContractor();
        $request    = ReconstructionRequest::factory()->create(['user_id' => $user->id]);

        InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'pending',
        ]);

        $this->withHeaders($this->authHeaders($contractor))
            ->postJson('/api/inspection-requests', [
                'reconstruction_request_id' => $request->id,
            ])
            ->assertStatus(422);
    }

    public function test_two_different_contractors_can_apply_to_same_request(): void
    {
        $user        = $this->createUser();
        $contractor1 = $this->createContractor();
        $contractor2 = $this->createContractor();
        $request     = ReconstructionRequest::factory()->create(['user_id' => $user->id]);

        $this->actingAs($contractor1, 'sanctum')
            ->postJson('/api/inspection-requests', [
                'reconstruction_request_id' => $request->id,
            ])
            ->assertStatus(200);

        $response = $this->actingAs($contractor2, 'sanctum')
            ->postJson('/api/inspection-requests', [
                'reconstruction_request_id' => $request->id,
            ]);

        $response->assertStatus(200);
        $this->assertDatabaseCount('inspection_requests', 2);
    }

    public function test_inspection_request_requires_reconstruction_request_id(): void
    {
        $contractor = $this->createContractor();

        $this->withHeaders($this->authHeaders($contractor))
            ->postJson('/api/inspection-requests', [])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['reconstruction_request_id']);
    }

    public function test_inspection_request_fails_for_nonexistent_reconstruction_request(): void
    {
        $contractor = $this->createContractor();

        $this->withHeaders($this->authHeaders($contractor))
            ->postJson('/api/inspection-requests', [
                'reconstruction_request_id' => 99999,
            ])
            ->assertStatus(422);
    }

    public function test_unauthenticated_user_cannot_send_inspection_request(): void
    {
        $request = ReconstructionRequest::factory()->create([
            'user_id' => $this->createUser()->id,
        ]);

        $this->postJson('/api/inspection-requests', [
            'reconstruction_request_id' => $request->id,
        ])->assertStatus(401);
    }

    // ─────────────────────────────────────────────────
    // Customer accepts inspection request
    // ─────────────────────────────────────────────────

    public function test_customer_can_accept_inspection_request(): void
    {
        $user       = $this->createUser();
        $contractor = $this->createContractor();
        $request    = ReconstructionRequest::factory()->create(['user_id' => $user->id]);

        $inspection = InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'pending',
        ]);

        $schedule = ContractorSchedule::factory()->create([
            'contractor_id' => $contractor->id,
        ]);

        $response = $this->withHeaders($this->authHeaders($user))
            ->postJson('/api/inspection-requests/accept', [
                'inspection_request_id' => $inspection->id,
                'schedule_id'           => $schedule->id,
            ]);

        $response->assertStatus(200);

        $this->assertDatabaseHas('inspection_requests', [
            'id'     => $inspection->id,
            'status' => 'accepted',
        ]);

        // Site visit is created automatically
        $this->assertDatabaseHas('site_visits', [
            'inspection_request_id' => $inspection->id,
            'schedule_id'           => $schedule->id,
        ]);
    }

    public function test_accepting_creates_site_visit(): void
    {
        $user       = $this->createUser();
        $contractor = $this->createContractor();
        $request    = ReconstructionRequest::factory()->create(['user_id' => $user->id]);

        $inspection = InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'pending',
        ]);

        $schedule = ContractorSchedule::factory()->create([
            'contractor_id' => $contractor->id,
        ]);

        $this->withHeaders($this->authHeaders($user))
            ->postJson('/api/inspection-requests/accept', [
                'inspection_request_id' => $inspection->id,
                'schedule_id'           => $schedule->id,
            ]);

        $this->assertDatabaseCount('site_visits', 1);
    }

    public function test_accept_requires_inspection_request_id(): void
    {
        $user     = $this->createUser();
        $schedule = ContractorSchedule::factory()->create([
            'contractor_id' => $this->createContractor()->id,
        ]);

        $this->withHeaders($this->authHeaders($user))
            ->postJson('/api/inspection-requests/accept', [
                'schedule_id' => $schedule->id,
            ])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['inspection_request_id']);
    }

    public function test_accept_requires_schedule_id(): void
    {
        $user       = $this->createUser();
        $inspection = InspectionRequest::factory()->create([
            'contractor_id' => $this->createContractor()->id,
        ]);

        $this->withHeaders($this->authHeaders($user))
            ->postJson('/api/inspection-requests/accept', [
                'inspection_request_id' => $inspection->id,
            ])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['schedule_id']);
    }

    // ─────────────────────────────────────────────────
    // Customer rejects inspection request
    // ─────────────────────────────────────────────────

    public function test_customer_can_reject_inspection_request(): void
    {
        $user       = $this->createUser();
        $contractor = $this->createContractor();
        $request    = ReconstructionRequest::factory()->create(['user_id' => $user->id]);

        $inspection = InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'pending',
        ]);

        $this->withHeaders($this->authHeaders($user))
            ->postJson("/api/inspection-requests/{$inspection->id}/reject")
            ->assertStatus(200);

        $this->assertDatabaseHas('inspection_requests', [
            'id'     => $inspection->id,
            'status' => 'rejected',
        ]);
    }

    public function test_unauthenticated_user_cannot_reject_inspection_request(): void
    {
        $inspection = InspectionRequest::factory()->create([
            'contractor_id' => $this->createContractor()->id,
        ]);

        $this->postJson("/api/inspection-requests/{$inspection->id}/reject")
            ->assertStatus(401);
    }

    // ─────────────────────────────────────────────────
    // Viewing inspection requests
    // ─────────────────────────────────────────────────

    public function test_user_can_view_pending_offers(): void
    {
        $user       = $this->createUser();
        $contractor = $this->createContractor();
        $request    = ReconstructionRequest::factory()->create(['user_id' => $user->id]);

        InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'pending',
        ]);

        $response = $this->withHeaders($this->authHeaders($user))
            ->getJson('/api/user/offers');

        $response->assertStatus(200);
        $this->assertNotEmpty($response->json('data'));
    }

    // ─────────────────────────────────────────────────
    // Security / malicious user tests
    // ─────────────────────────────────────────────────

    /**
     * BUG EXPOSURE: reject() has no ownership check.
     * Any authenticated user can reject any inspection request.
     * This test will FAIL until your teammate adds an ownership check.
     */
    public function test_outsider_cannot_reject_inspection_request(): void
    {
        $owner      = $this->createUser();
        $outsider   = $this->createUser();
        $contractor = $this->createContractor();
        $request    = ReconstructionRequest::factory()->create(['user_id' => $owner->id]);

        $inspection = InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'pending',
        ]);

        $this->withHeaders($this->authHeaders($outsider))
            ->postJson("/api/inspection-requests/{$inspection->id}/reject")
            ->assertStatus(403);
    }

    /**
     * BUG EXPOSURE: accept() has no ownership check.
     * Any authenticated user can accept any inspection request.
     * This test will FAIL until your teammate adds an ownership check.
     */
    public function test_outsider_cannot_accept_inspection_request(): void
    {
        $owner      = $this->createUser();
        $outsider   = $this->createUser();
        $contractor = $this->createContractor();
        $request    = ReconstructionRequest::factory()->create(['user_id' => $owner->id]);

        $inspection = InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'pending',
        ]);

        $schedule = ContractorSchedule::factory()->create([
            'contractor_id' => $contractor->id,
        ]);

        $this->withHeaders($this->authHeaders($outsider))
            ->postJson('/api/inspection-requests/accept', [
                'inspection_request_id' => $inspection->id,
                'schedule_id'           => $schedule->id,
            ])
            ->assertStatus(403);
    }
}
