<?php

namespace Tests\Feature;

use App\Models\Complaint;
use App\Models\ConstructionForm;
use App\Models\NoShowWarning;
use App\Models\Role;
use App\Models\SiteVisit;
use App\Models\Wallet;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Tests\TestCase;

class ComplaintWorkflowTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(\Database\Seeders\RoleSeeder::class);
        Storage::fake('public');
        $this->travelTo(now()->setTime(14, 0, 0));
    }

    protected function tearDown(): void
    {
        $this->travelBack();

        parent::tearDown();
    }

    // ─────────────────────────────────────────────────
    // Filing a project complaint
    // ─────────────────────────────────────────────────

    public function test_user_can_file_complaint_against_contractor(): void
    {
        $project = $this->createFullProject();

        $response = $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/complaints', [
                'construction_form_id' => $project['form']->id,
                'reason'               => 'رداءة جودة العمل',
                'description'          => 'العمل لا يتوافق مع الاتفاق',
            ]);

        $response->assertStatus(201);

        $this->assertDatabaseHas('complaints', [
            'complainant_id'   => $project['user']->id,
            'complained_on_id' => $project['contractor']->id,
            'status'           => 'open',
        ]);
    }

    public function test_contractor_can_file_complaint_against_user(): void
    {
        $project = $this->createFullProject();

        $response = $this->withHeaders($this->authHeaders($project['contractor']))
            ->postJson('/api/complaints', [
                'construction_form_id' => $project['form']->id,
                'reason'               => 'التأخر في الدفع',
            ]);

        $response->assertStatus(201);

        $this->assertDatabaseHas('complaints', [
            'complainant_id'   => $project['contractor']->id,
            'complained_on_id' => $project['user']->id,
            'status'           => 'open',
        ]);
    }

    public function test_complained_on_is_auto_detected_from_construction_form(): void
    {
        $project = $this->createFullProject();

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/complaints', [
                'construction_form_id' => $project['form']->id,
                'reason'               => 'رداءة جودة العمل',
            ]);

        // Backend should have set complained_on_id to contractor automatically
        $this->assertDatabaseHas('complaints', [
            'complainant_id'   => $project['user']->id,
            'complained_on_id' => $project['contractor']->id,
        ]);
    }

    public function test_user_can_attach_images_to_complaint(): void
    {
        $project = $this->createFullProject();

        $response = $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/complaints', [
                'construction_form_id' => $project['form']->id,
                'reason'               => 'رداءة جودة العمل',
                'images'               => [
                    UploadedFile::fake()->image('evidence1.jpg'),
                    UploadedFile::fake()->image('evidence2.jpg'),
                ],
            ]);

        $response->assertStatus(201);
        $this->assertDatabaseCount('complaint_images', 2);
    }

    public function test_engineer_cannot_file_project_complaint(): void
    {
        $project = $this->createFullProject();

        $this->withHeaders($this->authHeaders($project['engineer']))
            ->postJson('/api/complaints', [
                'construction_form_id' => $project['form']->id,
                'reason'               => 'سبب ما',
            ])
            ->assertStatus(403);
    }

    public function test_outsider_cannot_file_complaint_on_unrelated_project(): void
    {
        $project  = $this->createFullProject();
        $outsider = $this->createUser();

        $this->withHeaders($this->authHeaders($outsider))
            ->postJson('/api/complaints', [
                'construction_form_id' => $project['form']->id,
                'reason'               => 'رداءة جودة العمل',
            ])
            ->assertStatus(403);
    }

    public function test_complaint_requires_construction_form_id(): void
    {
        $user = $this->createUser();

        $this->withHeaders($this->authHeaders($user))
            ->postJson('/api/complaints', [
                'reason' => 'رداءة جودة العمل',
            ])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['construction_form_id']);
    }

    public function test_complaint_requires_reason(): void
    {
        $project = $this->createFullProject();

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/complaints', [
                'construction_form_id' => $project['form']->id,
            ])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['reason']);
    }

    public function test_unauthenticated_cannot_file_complaint(): void
    {
        $this->postJson('/api/complaints', [
            'construction_form_id' => 1,
            'reason'               => 'سبب',
        ])->assertStatus(401);
    }

    // ─────────────────────────────────────────────────
    // Filing a no-show warning
    // ─────────────────────────────────────────────────

    public function test_user_can_report_contractor_no_show(): void
    {
        $project = $this->createFullProject();

        $response = $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/no-show-warnings', [
                'site_visit_id' => $project['siteVisit']->id,
                'reported_role' => 'contractor',
            ]);

        $response->assertStatus(201);

        $this->assertDatabaseHas('no_show_warnings', [
            'site_visit_id'   => $project['siteVisit']->id,
            'reporter_id'     => $project['user']->id,
            'reported_id'     => $project['contractor']->id,
            'penalty_applied' => false,
        ]);
    }

    public function test_contractor_can_report_user_no_show(): void
    {
        $project = $this->createFullProject();

        $response = $this->withHeaders($this->authHeaders($project['contractor']))
            ->postJson('/api/no-show-warnings', [
                'site_visit_id' => $project['siteVisit']->id,
                'reported_role' => 'user',
            ]);

        $response->assertStatus(201);
        $this->assertDatabaseHas('no_show_warnings', [
            'reported_id' => $project['user']->id,
        ]);
    }

    public function test_engineer_can_report_no_show(): void
    {
        $project = $this->createFullProject();

        $response = $this->withHeaders($this->authHeaders($project['engineer']))
            ->postJson('/api/no-show-warnings', [
                'site_visit_id' => $project['siteVisit']->id,
                'reported_role' => 'contractor',
            ]);

        $response->assertStatus(201);
    }

    public function test_cannot_report_same_person_twice_on_same_visit(): void
    {
        $project = $this->createFullProject();

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/no-show-warnings', [
                'site_visit_id' => $project['siteVisit']->id,
                'reported_role' => 'contractor',
            ]);

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/no-show-warnings', [
                'site_visit_id' => $project['siteVisit']->id,
                'reported_role' => 'contractor',
            ])
            ->assertStatus(422);
    }

    public function test_cannot_report_yourself(): void
    {
        $project = $this->createFullProject();

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/no-show-warnings', [
                'site_visit_id' => $project['siteVisit']->id,
                'reported_role' => 'user', // reporting themselves
            ])
            ->assertStatus(422);
    }

    public function test_outsider_cannot_report_no_show(): void
    {
        $project  = $this->createFullProject();
        $outsider = $this->createUser();

        $this->withHeaders($this->authHeaders($outsider))
            ->postJson('/api/no-show-warnings', [
                'site_visit_id' => $project['siteVisit']->id,
                'reported_role' => 'contractor',
            ])
            ->assertStatus(403);
    }

    public function test_cannot_report_on_pending_visit(): void
    {
        $project = $this->createFullProject();
        $project['siteVisit']->update(['status' => 'pending']);

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/no-show-warnings', [
                'site_visit_id' => $project['siteVisit']->id,
                'reported_role' => 'contractor',
            ])
            ->assertStatus(422);
    }

    public function test_cannot_report_before_visit_end_time(): void
    {
        $project = $this->createFullProject();

        $project['schedule']->update([
            'start_time' => '22:00:00',
            'end_time'   => '23:59:00',
        ]);

        $project['siteVisit']->update([
            'visit_date' => now()->format('Y-m-d'),
        ]);

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/no-show-warnings', [
                'site_visit_id' => $project['siteVisit']->id,
                'reported_role' => 'contractor',
            ])
            ->assertStatus(422);
    }

    public function test_third_warning_deactivates_account(): void
    {
        $project = $this->createFullProject();

        // 2 existing unpunished warnings
        NoShowWarning::factory()->count(2)->create([
            'reported_id'     => $project['contractor']->id,
            'reported_role_id' => Role::where('name', 'contractor')->first()->id,
            'penalty_applied' => false,
        ]);

        $response = $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/no-show-warnings', [
                'site_visit_id' => $project['siteVisit']->id,
                'reported_role' => 'contractor',
            ]);

        $response->assertStatus(201);

        $project['contractor']->refresh();

        $this->assertFalse(
            (bool) $project['contractor']->is_active,
            'The contractor account should be deactivated after 3 warnings.'
        );


        $project['contractor']->refresh();
        $this->assertFalse((bool) $project['contractor']->is_active);
    }

    public function test_warnings_marked_as_applied_after_deactivation(): void
    {
        $project = $this->createFullProject();

        NoShowWarning::factory()->count(2)->create([
            'reported_id'     => $project['contractor']->id,
            'reported_role_id' => Role::where('name', 'contractor')->first()->id,
            'penalty_applied' => false,
        ]);

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson('/api/no-show-warnings', [
                'site_visit_id' => $project['siteVisit']->id,
                'reported_role' => 'contractor',
            ]);

        $remaining = NoShowWarning::where('reported_id', $project['contractor']->id)
            ->where('penalty_applied', false)
            ->count();

        $this->assertEquals(0, $remaining);
    }

    // ─────────────────────────────────────────────────
    // Admin — all complaints merged
    // ─────────────────────────────────────────────────

    public function test_admin_sees_all_complaints_merged_by_latest(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $older = Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'is_archived'           => false,
            'created_at'            => now()->subHour(),
        ]);

        $newer = NoShowWarning::factory()->create([
            'site_visit_id'    => $project['siteVisit']->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['contractor']->id,
            'reporter_role_id' => Role::where('name', 'user')->first()->id,
            'reported_role_id' => Role::where('name', 'contractor')->first()->id,
            'is_archived'      => false,
            'created_at'       => now(),
        ]);

        $response = $this->withHeaders($this->authHeaders($admin))
            ->getJson('/api/admin/all-complaints');

        $response->assertStatus(200);

        $data = $response->json('data');
        $this->assertCount(2, $data);
        $this->assertEquals('no_show', $data[0]['type']);
        $this->assertEquals('general', $data[1]['type']);
    }

    public function test_admin_can_filter_by_type_general(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'is_archived'           => false,
        ]);

        NoShowWarning::factory()->create([
            'site_visit_id'    => $project['siteVisit']->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['contractor']->id,
            'reporter_role_id' => Role::where('name', 'user')->first()->id,
            'reported_role_id' => Role::where('name', 'contractor')->first()->id,
            'is_archived'      => false,
        ]);

        $response = $this->withHeaders($this->authHeaders($admin))
            ->getJson('/api/admin/all-complaints?type=general');

        $response->assertStatus(200);

        foreach ($response->json('data') as $item) {
            $this->assertEquals('general', $item['type']);
        }
    }

    public function test_admin_can_filter_by_type_no_show(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'is_archived'           => false,
        ]);

        NoShowWarning::factory()->create([
            'site_visit_id'    => $project['siteVisit']->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['contractor']->id,
            'reporter_role_id' => Role::where('name', 'user')->first()->id,
            'reported_role_id' => Role::where('name', 'contractor')->first()->id,
            'is_archived'      => false,
        ]);

        $response = $this->withHeaders($this->authHeaders($admin))
            ->getJson('/api/admin/all-complaints?type=no_show');

        $response->assertStatus(200);

        foreach ($response->json('data') as $item) {
            $this->assertEquals('no_show', $item['type']);
        }
    }

    public function test_non_admin_cannot_see_all_complaints(): void
    {
        $user = $this->createUser();

        $this->withHeaders($this->authHeaders($user))
            ->getJson('/api/admin/all-complaints')
            ->assertStatus(403);
    }

    // ─────────────────────────────────────────────────
    // Admin — resolve complaint
    // ─────────────────────────────────────────────────

    public function test_admin_can_resolve_complaint_without_penalty(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $complaint = Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'status'                => 'open',
        ]);

        $this->withHeaders($this->authHeaders($admin))
            ->patchJson("/api/admin/complaints/{$complaint->id}/resolve", [
                'status'                => 'dismissed',
                'admin_processing_note' => 'الشكوى غير مبررة',
            ])
            ->assertStatus(200)
            ->assertJsonPath('data.status', 'dismissed');
    }

    public function test_admin_resolve_with_penalty_deducts_from_admin_and_compensates_user(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

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

        $this->withHeaders($this->authHeaders($admin))
            ->patchJson("/api/admin/complaints/{$complaint->id}/resolve", [
                'status'             => 'resolved',
                'penalty_percentage' => 10,
            ])
            ->assertStatus(200);

        // held = total_cost × 30% = 1,000,000 × 30% = 300,000
        // penalty = 300,000 × 10% = 30,000
        $expectedPenalty = 1000000 * 0.30 * (10 / 100);

        $project['user']->wallet->refresh();
        $this->assertEquals(
            $userBalanceBefore + $expectedPenalty,
            $project['user']->wallet->balance
        );
    }

    public function test_cannot_resolve_already_resolved_complaint(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $complaint = Complaint::factory()->resolved()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
        ]);

        $this->withHeaders($this->authHeaders($admin))
            ->patchJson("/api/admin/complaints/{$complaint->id}/resolve", [
                'status' => 'dismissed',
            ])
            ->assertStatus(422);
    }

    public function test_non_admin_cannot_resolve_complaint(): void
    {
        $user    = $this->createUser();
        $project = $this->createFullProject();

        $complaint = Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'status'                => 'open',
        ]);

        $this->withHeaders($this->authHeaders($user))
            ->patchJson("/api/admin/complaints/{$complaint->id}/resolve", [
                'status' => 'resolved',
            ])
            ->assertStatus(403);
    }

    // ─────────────────────────────────────────────────
    // Admin — archive
    // ─────────────────────────────────────────────────

    public function test_admin_can_archive_complaint(): void
    {
        $admin   = $this->createAdmin();
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

        $this->withHeaders($this->authHeaders($admin))
            ->patchJson("/api/admin/complaints/{$complaint->id}/archive")
            ->assertStatus(200);

        $this->assertDatabaseHas('complaints', [
            'id'          => $complaint->id,
            'is_archived' => true,
        ]);
    }

    public function test_archived_complaints_dont_appear_in_main_list(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'is_archived'           => true,
        ]);

        $response = $this->withHeaders($this->authHeaders($admin))
            ->getJson('/api/admin/all-complaints');

        $response->assertStatus(200);
        $this->assertCount(0, $response->json('data'));
    }

    public function test_archived_complaints_appear_in_archived_list(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        Complaint::factory()->create([
            'complainant_id'        => $project['user']->id,
            'complained_on_id'      => $project['contractor']->id,
            'construction_form_id'  => $project['form']->id,
            'complainant_role_id'   => Role::where('name', 'user')->first()->id,
            'complained_on_role_id' => Role::where('name', 'contractor')->first()->id,
            'reason'                => 'رداءة جودة العمل',
            'is_archived'           => true,
        ]);

        $response = $this->withHeaders($this->authHeaders($admin))
            ->getJson('/api/admin/archived-complaints');

        $response->assertStatus(200);
        $this->assertCount(1, $response->json('data'));
    }

    // ─────────────────────────────────────────────────
    // Admin — no-show warnings
    // ─────────────────────────────────────────────────

    public function test_admin_can_view_all_no_show_warnings(): void
    {
        $admin = $this->createAdmin();
        $project = $this->createFullProject();

        $userRoleId       = Role::where('name', 'user')->first()->id;
        $contractorRoleId = Role::where('name', 'contractor')->first()->id;

        NoShowWarning::factory()->create([
            'site_visit_id'    => $project['siteVisit']->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['contractor']->id,
            'reporter_role_id' => $userRoleId,
            'reported_role_id' => $contractorRoleId,
            'is_archived'      => false,
        ]);

        NoShowWarning::factory()->create([
            'site_visit_id'    => SiteVisit::factory()->create()->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['contractor']->id,
            'reporter_role_id' => $userRoleId,
            'reported_role_id' => $contractorRoleId,
            'is_archived'      => false,
        ]);

        NoShowWarning::factory()->create([
            'site_visit_id'    => SiteVisit::factory()->create()->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['contractor']->id,
            'reporter_role_id' => $userRoleId,
            'reported_role_id' => $contractorRoleId,
            'is_archived'      => false,
        ]);

        $response = $this->withHeaders($this->authHeaders($admin))
            ->getJson('/api/admin/no-show-warnings');

        $response->assertStatus(200);
        $this->assertCount(3, $response->json('data'));
    }

    public function test_admin_can_view_single_no_show_warning(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $warning = NoShowWarning::factory()->create([
            'site_visit_id'    => $project['siteVisit']->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['contractor']->id,
            'reporter_role_id' => Role::where('name', 'user')->first()->id,
            'reported_role_id' => Role::where('name', 'contractor')->first()->id,
        ]);

        $this->withHeaders($this->authHeaders($admin))
            ->getJson("/api/admin/no-show-warnings/{$warning->id}")
            ->assertStatus(200)
            ->assertJsonPath('data.id', $warning->id);
    }

    public function test_admin_can_archive_no_show_warning(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $warning = NoShowWarning::factory()->create([
            'site_visit_id'    => $project['siteVisit']->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['contractor']->id,
            'reporter_role_id' => Role::where('name', 'user')->first()->id,
            'reported_role_id' => Role::where('name', 'contractor')->first()->id,
            'is_archived'      => false,
        ]);

        $this->withHeaders($this->authHeaders($admin))
            ->patchJson("/api/admin/no-show-warnings/{$warning->id}/archive")
            ->assertStatus(200);

        $this->assertDatabaseHas('no_show_warnings', [
            'id'          => $warning->id,
            'is_archived' => true,
        ]);
    }

    public function test_non_admin_cannot_view_no_show_warnings(): void
    {
        $user = $this->createUser();

        $this->withHeaders($this->authHeaders($user))
            ->getJson('/api/admin/no-show-warnings')
            ->assertStatus(403);
    }
}
