<?php

namespace Database\Seeders;

use App\Models\ContractorSchedule;
use App\Models\InspectionRequest;
use App\Models\NoShowWarning;
use App\Models\ReconstructionRequest;
use App\Models\Role;
use App\Models\SiteVisit;
use App\Models\User;
use App\Models\UserProfile;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class NoShowWarningSeeder extends Seeder
{
    public function run(): void
    {
        $userRole = Role::where('name', 'user')->firstOrFail();
        $contractorRole = Role::where('name', 'contractor')->firstOrFail();
        $engineerRole = Role::where('name', 'engineer')->firstOrFail();

        $projects = [];

        /*
        |--------------------------------------------------------------------------
        | Create 4 Projects
        |--------------------------------------------------------------------------
        */

        for ($i = 1; $i <= 4; $i++) {

            /*
            |--------------------------------------------------------------------------
            | User
            |--------------------------------------------------------------------------
            */

            $user = User::create([
                'name' => "User {$i}",
                'email' => "nsw_user{$i}@renova.com",
                'password' => Hash::make('password'),
                'role_id' => $userRole->id,
                'status' => 'approved',
                'otp_verified' => true,
                'is_active' => true,
            ]);

            UserProfile::create([
                'user_id' => $user->id,
                'first_name' => "User{$i}",
                'last_name' => 'Test',
                'phone' => "09990000{$i}",
                'location' => 'Damascus',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Contractor
            |--------------------------------------------------------------------------
            */

            $contractor = User::create([
                'name' => "Contractor {$i}",
                'email' => "nsw_contractor{$i}@renova.com",
                'password' => Hash::make('password'),
                'role_id' => $contractorRole->id,
                'status' => 'approved',
                'otp_verified' => true,
                'is_active' => true,
            ]);

            UserProfile::create([
                'user_id' => $contractor->id,
                'first_name' => "Contractor{$i}",
                'last_name' => 'Test',
                'phone' => "09991000{$i}",
                'location' => 'Aleppo',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Engineer
            |--------------------------------------------------------------------------
            */

            $engineer = User::create([
                'name' => "Engineer {$i}",
                'email' => "nsw_engineer{$i}@renova.com",
                'password' => Hash::make('password'),
                'role_id' => $engineerRole->id,
                'status' => 'approved',
                'otp_verified' => true,
                'is_active' => true,
            ]);

            UserProfile::create([
                'user_id' => $engineer->id,
                'first_name' => "Engineer{$i}",
                'last_name' => 'Test',
                'phone' => "09992000{$i}",
                'location' => 'Homs',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Reconstruction Request
            |--------------------------------------------------------------------------
            */

            $request = ReconstructionRequest::create([
                'user_id' => $user->id,
                'title' => "No Show Project {$i}",
                'description' => "Project {$i} for testing no show warnings.",
                'location' => 'Damascus',
                'type' => 'construction',
                'status' => 'open',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Inspection Request
            |--------------------------------------------------------------------------
            */

            $inspectionRequest = InspectionRequest::create([
                'reconstruction_request_id' => $request->id,
                'contractor_id' => $contractor->id,
                'status' => 'accepted',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Contractor Schedule
            |--------------------------------------------------------------------------
            */

            $schedule = ContractorSchedule::create([
                'contractor_id' => $contractor->id,
                'day_of_week' => 'monday',
                'start_time' => '09:00:00',
                'end_time' => '12:00:00',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Site Visit
            |--------------------------------------------------------------------------
            */

            $siteVisit = SiteVisit::create([
                'inspection_request_id' => $inspectionRequest->id,
                'schedule_id' => $schedule->id,
                'engineer_id' => $engineer->id,
                'status' => 'missed',
            ]);

            $projects[] = [
                'user' => $user,
                'contractor' => $contractor,
                'engineer' => $engineer,
                'site_visit' => $siteVisit,
            ];
        }

        /*
        |--------------------------------------------------------------------------
        | Reporter / Reported combinations
        |--------------------------------------------------------------------------
        */

        $combinations = [

            [
                'reporter' => 'user',
                'reported' => 'contractor',
                'reporter_role_id' => $userRole->id,
                'reported_role_id' => $contractorRole->id,
            ],

            [
                'reporter' => 'contractor',
                'reported' => 'user',
                'reporter_role_id' => $contractorRole->id,
                'reported_role_id' => $userRole->id,
            ],

            [
                'reporter' => 'user',
                'reported' => 'engineer',
                'reporter_role_id' => $userRole->id,
                'reported_role_id' => $engineerRole->id,
            ],

            [
                'reporter' => 'engineer',
                'reported' => 'user',
                'reporter_role_id' => $engineerRole->id,
                'reported_role_id' => $userRole->id,
            ],

            [
                'reporter' => 'contractor',
                'reported' => 'engineer',
                'reporter_role_id' => $contractorRole->id,
                'reported_role_id' => $engineerRole->id,
            ],

            [
                'reporter' => 'engineer',
                'reported' => 'contractor',
                'reporter_role_id' => $engineerRole->id,
                'reported_role_id' => $contractorRole->id,
            ],

        ];
                /*
        |--------------------------------------------------------------------------
        | Create No Show Warnings
        |--------------------------------------------------------------------------
        */

        $warningsCount = 0;

        foreach ($projects as $project) {

            foreach ($combinations as $combination) {

                NoShowWarning::create([

                    'site_visit_id' => $project['site_visit']->id,

                    'reporter_id' => $project[$combination['reporter']]->id,

                    'reported_id' => $project[$combination['reported']]->id,

                    'reporter_role_id' => $combination['reporter_role_id'],

                    'reported_role_id' => $combination['reported_role_id'],

                    'type' => 'no_show',

                    'reason' => 'عدم الحضور إلى الزيارة الميدانية',

                    'description' => "عدم حضور المستخدم إلى الزيارة الميدانية رقم ({$project['site_visit']->id})",

                    'penalty_applied' => false,
                ]);

                $warningsCount++;
            }
        }

        $this->command->info('✅ NoShowWarningSeeder completed successfully.');
        $this->command->info('────────────────────────────────────────');

        $this->command->info('📊 Summary:');
        $this->command->info('   Projects: 4');
        $this->command->info('   Users: 4');
        $this->command->info('   Contractors: 4');
        $this->command->info('   Engineers: 4');
        $this->command->info('   Reconstruction Requests: 4');
        $this->command->info('   Inspection Requests: 4');
        $this->command->info('   Contractor Schedules: 4');
        $this->command->info('   Site Visits: 4');
        $this->command->info("   No Show Warnings: {$warningsCount}");

        $this->command->info('');
        $this->command->info('Role combinations (4 each):');
        $this->command->info('   User → Contractor');
        $this->command->info('   Contractor → User');
        $this->command->info('   User → Engineer');
        $this->command->info('   Engineer → User');
        $this->command->info('   Contractor → Engineer');
        $this->command->info('   Engineer → Contractor');
        $this->command->info('');
        $this->command->info('Total warnings created: 24');
    }
}