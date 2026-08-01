<?php

namespace Tests\Feature;

use App\Models\ContractorSchedule;
use App\Models\InspectionRequest;
use App\Models\ReconstructionRequest;
use App\Models\SiteVisit;
use Database\Seeders\RoleSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SiteVisitWorkflowTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleSeeder::class);
    }

    // ─────────────────────────────────────────────────
    // Contractor views their visits
    // ─────────────────────────────────────────────────

    public function test_contractor_can_view_their_own_visits(): void
    {
        $user       = $this->createUser();
        $contractor = $this->createContractor();

        $request = ReconstructionRequest::factory()->create(['user_id' => $user->id]);
        $inspection = InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'accepted',
        ]);
        $schedule = ContractorSchedule::factory()->create(['contractor_id' => $contractor->id]);
        SiteVisit::factory()->create([
            'inspection_request_id' => $inspection->id,
            'schedule_id'           => $schedule->id,
        ]);

        $response = $this->withHeaders($this->authHeaders($contractor))
            ->getJson('/api/contractor/visits');

        $response->assertStatus(200);
        $this->assertCount(1, $response->json('data'));
    }

    public function test_contractor_cannot_see_other_contractors_visits(): void
    {
        $user        = $this->createUser();
        $contractor1 = $this->createContractor();
        $contractor2 = $this->createContractor();

        $request = ReconstructionRequest::factory()->create(['user_id' => $user->id]);
        $inspection = InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor1->id,
            'status'                    => 'accepted',
        ]);
        $schedule = ContractorSchedule::factory()->create(['contractor_id' => $contractor1->id]);
        SiteVisit::factory()->create([
            'inspection_request_id' => $inspection->id,
            'schedule_id'           => $schedule->id,
        ]);

        // contractor2 should see empty list
        $response = $this->withHeaders($this->authHeaders($contractor2))
            ->getJson('/api/contractor/visits');

        $response->assertStatus(200);
        $this->assertCount(0, $response->json('data'));
    }

    // ─────────────────────────────────────────────────
    // User views their visits
    // ─────────────────────────────────────────────────

    public function test_user_can_view_their_own_visits(): void
    {
        $user       = $this->createUser();
        $contractor = $this->createContractor();

        $request = ReconstructionRequest::factory()->create(['user_id' => $user->id]);
        $inspection = InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'accepted',
        ]);
        $schedule = ContractorSchedule::factory()->create(['contractor_id' => $contractor->id]);
        SiteVisit::factory()->create([
            'inspection_request_id' => $inspection->id,
            'schedule_id'           => $schedule->id,
        ]);

        $response = $this->withHeaders($this->authHeaders($user))
            ->getJson('/api/user/visits');

        $response->assertStatus(200);
        $this->assertCount(1, $response->json('data'));
    }

    public function test_user_cannot_see_other_users_visits(): void
    {
        $user1      = $this->createUser();
        $user2      = $this->createUser();
        $contractor = $this->createContractor();

        $request = ReconstructionRequest::factory()->create(['user_id' => $user1->id]);
        $inspection = InspectionRequest::factory()->create([
            'reconstruction_request_id' => $request->id,
            'contractor_id'             => $contractor->id,
            'status'                    => 'accepted',
        ]);
        $schedule = ContractorSchedule::factory()->create(['contractor_id' => $contractor->id]);
        SiteVisit::factory()->create([
            'inspection_request_id' => $inspection->id,
            'schedule_id'           => $schedule->id,
        ]);

        // user2 should see empty list
        $response = $this->withHeaders($this->authHeaders($user2))
            ->getJson('/api/user/visits');

        $response->assertStatus(200);
        $this->assertCount(0, $response->json('data'));
    }

    // ─────────────────────────────────────────────────
    // Engineer responds to visit
    // ─────────────────────────────────────────────────

    public function test_engineer_can_accept_assigned_visit(): void
    {
        $project = $this->createFullProject();

        $project['siteVisit']->update([
            'status' => 'pending'
        ]);

        $response = $this->withHeaders($this->authHeaders($project['engineer']))
            ->postJson('/api/site-visits/respond', [
                'visit_id' => $project['siteVisit']->id,
                'status'   => 'accepted',
            ]);

        $response->assertStatus(200);

        $this->assertDatabaseHas('site_visits', [
            'id'     => $project['siteVisit']->id,
            'status' => 'accepted',
        ]);
    }

    public function test_engineer_can_reject_assigned_visit(): void
    {
        $project = $this->createFullProject();

        // set status to pending so engineer can respond
        $project['siteVisit']->update(['status' => 'pending']);

        $response = $this->withHeaders($this->authHeaders($project['engineer']))
            ->postJson('/api/site-visits/respond', [
                'visit_id' => $project['siteVisit']->id,
                'status'   => 'rejected',
            ]);

        $response->assertStatus(200);

        $this->assertDatabaseHas('site_visits', [
            'id'     => $project['siteVisit']->id,
            'status' => 'rejected',
        ]);
    }

    public function test_engineer_cannot_respond_to_another_engineers_visit(): void
    {
        $project        = $this->createFullProject();
        $anotherEngineer = $this->createEngineer();

        $project['siteVisit']->update(['status' => 'pending']);

        $this->withHeaders($this->authHeaders($anotherEngineer))
            ->postJson('/api/site-visits/respond', [
                'visit_id' => $project['siteVisit']->id,
                'status'   => 'accepted',
            ])
            ->assertStatus(404); // findOrFail fails since engineer_id doesn't match
    }

    public function test_engineer_cannot_respond_with_invalid_status(): void
    {
        $project = $this->createFullProject();

        $this->withHeaders($this->authHeaders($project['engineer']))
            ->postJson('/api/site-visits/respond', [
                'visit_id' => $project['siteVisit']->id,
                'status'   => 'completed', // not in accepted,rejected
            ])
            ->assertStatus(422);
    }

    public function test_respond_requires_visit_id(): void
    {
        $engineer = $this->createEngineer();

        $this->withHeaders($this->authHeaders($engineer))
            ->postJson('/api/site-visits/respond', [
                'status' => 'accepted',
            ])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['visit_id']);
    }

    // ─────────────────────────────────────────────────
    // Admin assigns engineer to visit
    // ─────────────────────────────────────────────────

    public function test_admin_can_assign_engineer_to_visit(): void
    {
        $admin    = $this->createAdmin();
        $project  = $this->createFullProject();
        $engineer = $this->createEngineer();

        // Remove existing engineer so visit needs assignment
        $project['siteVisit']->update(['engineer_id' => null]);

        $response = $this->withHeaders($this->authHeaders($admin))
            ->postJson('/api/admin/site-visits/assign', [
                'visit_id'    => $project['siteVisit']->id,
                'engineer_id' => $engineer->id,
            ]);

        $response->assertStatus(200);

        $this->assertDatabaseHas('site_visits', [
            'id'          => $project['siteVisit']->id,
            'engineer_id' => $engineer->id,
            'status'      => 'pending',
        ]);
    }

    public function test_admin_can_see_unassigned_visits(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $project['siteVisit']->update(['engineer_id' => null]);

        $response = $this->withHeaders($this->authHeaders($admin))
            ->getJson('/api/admin/site-visits/pending-assignment');

        $response->assertStatus(200);
        $this->assertNotEmpty($response->json('data'));
    }

    public function test_admin_can_see_available_engineers(): void
    {
        $admin    = $this->createAdmin();
        $engineer = $this->createEngineer();

        $response = $this->withHeaders($this->authHeaders($admin))
            ->getJson('/api/admin/available-engineers');

        $response->assertStatus(200);
        $this->assertNotEmpty($response->json('data'));
    }

    public function test_non_admin_cannot_assign_engineer(): void
    {
        $user    = $this->createUser();
        $project = $this->createFullProject();

        $this->withHeaders($this->authHeaders($user))
            ->postJson('/api/admin/site-visits/assign', [
                'visit_id'    => $project['siteVisit']->id,
                'engineer_id' => $project['engineer']->id,
            ])
            ->assertStatus(403);
    }

    /**
     * BUG EXPOSURE: assignEngineer() doesn't verify the user being assigned
     * actually has the engineer role. Any user ID can be assigned.
     * This test will FAIL until your teammate adds a role check.
     */
    public function test_admin_cannot_assign_non_engineer_to_visit(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();
        $user    = $this->createUser(); // not an engineer

        $project['siteVisit']->update(['engineer_id' => null]);

        $this->withHeaders($this->authHeaders($admin))
            ->postJson('/api/admin/site-visits/assign', [
                'visit_id'    => $project['siteVisit']->id,
                'engineer_id' => $user->id, // wrong role
            ])
            ->assertStatus(422);
    }

    // ─────────────────────────────────────────────────
    // Access control
    // ─────────────────────────────────────────────────

    public function test_unauthenticated_cannot_view_visits(): void
    {
        $this->getJson('/api/contractor/visits')->assertStatus(401);
        $this->getJson('/api/user/visits')->assertStatus(401);
    }

    public function test_user_cannot_access_contractor_visits(): void
    {
        $user = $this->createUser();

        $this->withHeaders($this->authHeaders($user))
            ->getJson('/api/contractor/visits')
            ->assertStatus(403);
    }

    public function test_contractor_cannot_access_user_visits(): void
    {
        $contractor = $this->createContractor();

        $this->withHeaders($this->authHeaders($contractor))
            ->getJson('/api/user/visits')
            ->assertStatus(403);
    }
}
