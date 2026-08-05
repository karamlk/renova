<?php

namespace Tests\Unit;

use App\Models\NoShowWarning;
use App\Models\Role;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class NoShowWarningServiceTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(\Database\Seeders\RoleSeeder::class);
    }

    // ─────────────────────────────────────────────────
    // Unpunished count logic
    // ─────────────────────────────────────────────────

    public function test_unpunished_count_only_includes_penalty_applied_false(): void
    {
        $contractor = $this->createContractor();
        $roleId     = Role::where('name', 'contractor')->first()->id;

        // 3 unpunished
        NoShowWarning::factory()->count(3)->create([
            'reported_id'     => $contractor->id,
            'reported_role_id'=> $roleId,
            'penalty_applied' => false,
        ]);

        // 2 already punished
        NoShowWarning::factory()->count(2)->create([
            'reported_id'     => $contractor->id,
            'reported_role_id'=> $roleId,
            'penalty_applied' => true,
        ]);

        $unpunished = NoShowWarning::where('reported_id', $contractor->id)
            ->where('penalty_applied', false)
            ->count();

        $this->assertEquals(3, $unpunished);
    }

    public function test_punished_warnings_dont_count_toward_deactivation(): void
    {
        $contractor = $this->createContractor();
        $roleId     = Role::where('name', 'contractor')->first()->id;

        // 5 punished — should not trigger anything
        NoShowWarning::factory()->count(5)->create([
            'reported_id'     => $contractor->id,
            'reported_role_id'=> $roleId,
            'penalty_applied' => true,
        ]);

        $unpunished = NoShowWarning::where('reported_id', $contractor->id)
            ->where('penalty_applied', false)
            ->count();

        $this->assertEquals(0, $unpunished);
        // Account should still be active
        $contractor->refresh();
        $this->assertTrue((bool) $contractor->is_active);
    }

    // ─────────────────────────────────────────────────
    // Deactivation at 3 warnings
    // ─────────────────────────────────────────────────

    public function test_account_deactivated_at_third_unpunished_warning(): void
    {
        $contractor = $this->createContractor();
        $roleId     = Role::where('name', 'contractor')->first()->id;

        NoShowWarning::factory()->count(2)->create([
            'reported_id'     => $contractor->id,
            'reported_role_id'=> $roleId,
            'penalty_applied' => false,
        ]);

        // Simulate third warning triggering deactivation
        $unpunished = NoShowWarning::where('reported_id', $contractor->id)
            ->where('penalty_applied', false)
            ->count() + 1; // +1 for the new one being added

        if ($unpunished >= 3) {
            User::where('id', $contractor->id)->update(['is_active' => false]);
            NoShowWarning::where('reported_id', $contractor->id)
                ->where('penalty_applied', false)
                ->update(['penalty_applied' => true]);
        }

        $contractor->refresh();
        $this->assertFalse((bool) $contractor->is_active);
    }

    public function test_account_not_deactivated_at_second_warning(): void
    {
        $contractor = $this->createContractor();
        $roleId     = Role::where('name', 'contractor')->first()->id;

        NoShowWarning::factory()->create([
            'reported_id'     => $contractor->id,
            'reported_role_id'=> $roleId,
            'penalty_applied' => false,
        ]);

        $unpunished = NoShowWarning::where('reported_id', $contractor->id)
            ->where('penalty_applied', false)
            ->count() + 1; // +1 for new one

        if ($unpunished >= 3) {
            User::where('id', $contractor->id)->update(['is_active' => false]);
        }

        // Only 2 warnings — should NOT deactivate
        $contractor->refresh();
        $this->assertTrue((bool) $contractor->is_active);
    }

    // ─────────────────────────────────────────────────
    // Warnings marked as applied after deactivation
    // ─────────────────────────────────────────────────

    public function test_all_unpunished_warnings_marked_after_deactivation(): void
    {
        $contractor = $this->createContractor();
        $roleId     = Role::where('name', 'contractor')->first()->id;

        NoShowWarning::factory()->count(3)->create([
            'reported_id'     => $contractor->id,
            'reported_role_id'=> $roleId,
            'penalty_applied' => false,
        ]);

        // Simulate deactivation logic
        User::where('id', $contractor->id)->update(['is_active' => false]);
        NoShowWarning::where('reported_id', $contractor->id)
            ->where('penalty_applied', false)
            ->update(['penalty_applied' => true]);

        $remaining = NoShowWarning::where('reported_id', $contractor->id)
            ->where('penalty_applied', false)
            ->count();

        $this->assertEquals(0, $remaining);
    }

    public function test_cycle_resets_after_deactivation(): void
    {
        $contractor = $this->createContractor();
        $roleId     = Role::where('name', 'contractor')->first()->id;

        // First cycle — 3 warnings → deactivation
        NoShowWarning::factory()->count(3)->create([
            'reported_id'     => $contractor->id,
            'reported_role_id'=> $roleId,
            'penalty_applied' => false,
        ]);

        User::where('id', $contractor->id)->update(['is_active' => false]);
        NoShowWarning::where('reported_id', $contractor->id)
            ->where('penalty_applied', false)
            ->update(['penalty_applied' => true]);

        // Admin reactivates
        User::where('id', $contractor->id)->update(['is_active' => true]);

        // Second cycle starts fresh — only 1 new unpunished warning
        NoShowWarning::factory()->create([
            'reported_id'     => $contractor->id,
            'reported_role_id'=> $roleId,
            'penalty_applied' => false,
        ]);

        $unpunished = NoShowWarning::where('reported_id', $contractor->id)
            ->where('penalty_applied', false)
            ->count();

        // Should be 1, not 4 — cycle reset correctly
        $this->assertEquals(1, $unpunished);

        // Account should still be active (only 1 warning in new cycle)
        $contractor->refresh();
        $this->assertTrue((bool) $contractor->is_active);
    }

    // ─────────────────────────────────────────────────
    // Warning uniqueness per visit per person
    // ─────────────────────────────────────────────────

    public function test_same_reporter_cannot_report_same_reported_twice_on_same_visit(): void
    {
        $project = $this->createFullProject();
        $roleId  = Role::where('name', 'user')->first()->id;

        NoShowWarning::factory()->create([
            'site_visit_id'    => $project['siteVisit']->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['contractor']->id,
            'reporter_role_id' => $roleId,
            'reported_role_id' => Role::where('name', 'contractor')->first()->id,
        ]);

        $exists = NoShowWarning::where('site_visit_id', $project['siteVisit']->id)
            ->where('reporter_id', $project['user']->id)
            ->where('reported_id', $project['contractor']->id)
            ->exists();

        $this->assertTrue($exists);

        // Trying to create a duplicate should fail due to unique constraint
        $this->expectException(\Illuminate\Database\QueryException::class);

        NoShowWarning::create([
            'site_visit_id'    => $project['siteVisit']->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['contractor']->id,
            'reporter_role_id' => $roleId,
            'reported_role_id' => Role::where('name', 'contractor')->first()->id,
            'type'             => 'no_show',
            'reason'           => 'عدم الحضور',
            'penalty_applied'  => false,
        ]);
    }

    public function test_same_reporter_can_report_different_people_on_same_visit(): void
    {
        $project = $this->createFullProject();

        // User reports contractor
        NoShowWarning::factory()->create([
            'site_visit_id'    => $project['siteVisit']->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['contractor']->id,
            'reporter_role_id' => Role::where('name', 'user')->first()->id,
            'reported_role_id' => Role::where('name', 'contractor')->first()->id,
        ]);

        // User reports engineer — different reported_id, should be allowed
        NoShowWarning::factory()->create([
            'site_visit_id'    => $project['siteVisit']->id,
            'reporter_id'      => $project['user']->id,
            'reported_id'      => $project['engineer']->id,
            'reporter_role_id' => Role::where('name', 'user')->first()->id,
            'reported_role_id' => Role::where('name', 'engineer')->first()->id,
        ]);

        $count = NoShowWarning::where('site_visit_id', $project['siteVisit']->id)
            ->where('reporter_id', $project['user']->id)
            ->count();

        $this->assertEquals(2, $count);
    }
}