<?php

namespace Database\Seeders;

use App\Models\ContractorProfile;
use App\Models\ContractorSchedule;
use App\Models\EngineerProfile;
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
        $userRole       = Role::where('name', 'user')->firstOrFail();
        $contractorRole = Role::where('name', 'contractor')->firstOrFail();
        $engineerRole   = Role::where('name', 'engineer')->firstOrFail();

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

            $user = User::firstOrCreate([
                'name'         => "User {$i}",
                'email'        => "nsw_user{$i}@renova.com",
                'password'     => Hash::make('password'),
                'role_id'      => $userRole->id,
                'status'       => 'approved',
                'otp_verified' => true,
                'is_active'    => true,
            ]);

            UserProfile::firstOrCreate([
                'user_id'    => $user->id,
                'first_name' => fake()->firstName(),
                'last_name'  => fake()->lastName(),
                'phone'      => fake()->numerify('09########'),
                'location'   => fake()->city(),
                'image'      => 'profiles/default_avatar.png',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Contractor
            |--------------------------------------------------------------------------
            */

            $contractor = User::firstOrCreate([
                'name'         => "Contractor {$i}",
                'email'        => "nsw_contractor{$i}@renova.com",
                'password'     => Hash::make('password'),
                'role_id'      => $contractorRole->id,
                'status'       => 'approved',
                'otp_verified' => true,
                'is_active'    => true,
            ]);

            ContractorProfile::firstOrCreate([
                'user_id'           => $contractor->id,
                'first_name'        => fake()->firstName(),
                'last_name'         => fake()->lastName(),
                'phone'             => fake()->numerify('09########'),
                'location'          => fake()->city(),
                'company_name'      => fake()->company(),
                'commercial_record' => 'contractors/request1.jpg',
                'image'             => 'profiles/default_avatar.png',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Engineer
            |--------------------------------------------------------------------------
            */

            $engineer = User::firstOrCreate([
                'name'         => "Engineer {$i}",
                'email'        => "nsw_engineer{$i}@renova.com",
                'password'     => Hash::make('password'),
                'role_id'      => $engineerRole->id,
                'status'       => 'approved',
                'otp_verified' => true,
                'is_active'    => true,
            ]);

            EngineerProfile::firstOrCreate([
                'user_id'             => $engineer->id,
                'first_name'          => fake()->firstName(),
                'last_name'           => fake()->lastName(),
                'phone'               => fake()->numerify('09########'),
                'location'            => fake()->city(),
                'image'               => 'profiles/default_avatar.png',
                'specialization'      => fake()->randomElement(['Civil Engineer', 'Architect', 'Electrical Engineer']),
                'syndicate_number'    => fake()->unique()->numberBetween(10000, 99999),
                'degree'              => fake()->randomElement(['Bachelor', 'Master', 'PhD']),
                'years_of_experience' => fake()->numberBetween(2, 20),
                'covered_zones'       => fake()->city(),
                'is_verified'         => true,
            ]);

            /*
            |--------------------------------------------------------------------------
            | Reconstruction Request
            |--------------------------------------------------------------------------
            */

            $request = ReconstructionRequest::firstOrCreate([
                'user_id'     => $user->id,
                'title'       => "No Show Project {$i}",
                'description' => "Project {$i} for testing no show warnings.",
                'location'    => fake()->city(),
                'type'        => fake()->randomElement(['restoration', 'construction', 'finishing']),
                'status'      => 'open',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Inspection Request
            |--------------------------------------------------------------------------
            */

            $inspectionRequest = InspectionRequest::firstOrCreate([
                'reconstruction_request_id' => $request->id,
                'contractor_id'             => $contractor->id,
                'status'                    => 'accepted',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Contractor Schedule
            |--------------------------------------------------------------------------
            */

            $schedule = ContractorSchedule::firstOrCreate([
                'contractor_id' => $contractor->id,
                'day_of_week'   => 'monday',
                'start_time'    => '09:00:00',
                'end_time'      => '12:00:00',
            ]);

            /*
            |--------------------------------------------------------------------------
            | Site Visit
            |--------------------------------------------------------------------------
            */

            $siteVisit = SiteVisit::firstOrCreate([
                'inspection_request_id' => $inspectionRequest->id,
                'schedule_id'           => $schedule->id,
                'engineer_id'           => $engineer->id,
                'status'                => 'accepted',
            ]);

            $projects[] = [
                'user'       => $user,
                'contractor' => $contractor,
                'engineer'   => $engineer,
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
                'reporter'         => 'user',
                'reported'         => 'contractor',
                'reporter_role_id' => $userRole->id,
                'reported_role_id' => $contractorRole->id,
            ],
            [
                'reporter'         => 'contractor',
                'reported'         => 'user',
                'reporter_role_id' => $contractorRole->id,
                'reported_role_id' => $userRole->id,
            ],
            [
                'reporter'         => 'user',
                'reported'         => 'engineer',
                'reporter_role_id' => $userRole->id,
                'reported_role_id' => $engineerRole->id,
            ],
            [
                'reporter'         => 'engineer',
                'reported'         => 'user',
                'reporter_role_id' => $engineerRole->id,
                'reported_role_id' => $userRole->id,
            ],
            [
                'reporter'         => 'contractor',
                'reported'         => 'engineer',
                'reporter_role_id' => $contractorRole->id,
                'reported_role_id' => $engineerRole->id,
            ],
            [
                'reporter'         => 'engineer',
                'reported'         => 'contractor',
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

        foreach (array_slice($projects, 1) as $project) {
            foreach ($combinations as $combination) {
                NoShowWarning::create([
                    'site_visit_id'    => $project['site_visit']->id,
                    'reporter_id'      => $project[$combination['reporter']]->id,
                    'reported_id'      => $project[$combination['reported']]->id,
                    'reporter_role_id' => $combination['reporter_role_id'],
                    'reported_role_id' => $combination['reported_role_id'],
                    'type'             => 'no_show',
                    'reason'           => 'عدم الحضور إلى الزيارة الميدانية',
                    'description'      => "عدم حضور المستخدم إلى الزيارة الميدانية رقم ({$project['site_visit']->id})",
                    'penalty_applied'  => false,
                ]);
            }
        }

        $this->command->info('');
        $this->command->info('   Each project has 6 warnings (all role combinations)');
        $this->command->info('   All penalty_applied = false');
        $this->command->info('');
    }
}
