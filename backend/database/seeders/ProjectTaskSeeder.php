<?php

namespace Database\Seeders;

use App\Models\Project;
use App\Models\ProjectTask;
use Illuminate\Database\Seeder;

class ProjectTaskSeeder extends Seeder
{
    public function run(): void
    {
        /*
        |--------------------------------------------------------------------------
        | Find the seeded project
        |--------------------------------------------------------------------------
        */

        $project = Project::first();

        if (!$project) {
            $this->command->warn(
                'No project found. Run ProjectSeeder first.'
            );

            return;
        }

        /*
        |--------------------------------------------------------------------------
        | Create Project Tasks
        |--------------------------------------------------------------------------
        */

        $tasks = [
            [
                'title'        => 'Site Preparation',
                'description' => 'Prepare the construction site and remove existing obstacles.',
                'percentage'   => 15.00,
                'is_completed' => true,
            ],
            [
                'title'        => 'Foundation Work',
                'description' => 'Complete excavation and foundation construction.',
                'percentage'   => 25.00,
                'is_completed' => true,
            ],
            [
                'title'        => 'Structural Construction',
                'description' => 'Construct the main structural elements of the building.',
                'percentage'   => 30.00,
                'is_completed' => false,
            ],
            [
                'title'        => 'Electrical and Plumbing',
                'description' => 'Install electrical wiring and plumbing systems.',
                'percentage'   => 15.00,
                'is_completed' => false,
            ],
            [
                'title'        => 'Finishing Work',
                'description' => 'Complete flooring, painting, doors, windows, and other finishing work.',
                'percentage'   => 15.00,
                'is_completed' => false,
            ],
        ];


        foreach ($tasks as $task) {
            ProjectTask::firstOrCreate(
                [
                    'project_id' => $project->id,
                    'title'      => $task['title'],
                ],
                [
                    'description' => $task['description'],
                    'percentage'  => $task['percentage'],
                    'is_completed' => $task['is_completed'],
                ]
            );
        }


        $this->command->info(
            "✅ ProjectTaskSeeder done — tasks created for Project #{$project->id}."
        );
    }
}