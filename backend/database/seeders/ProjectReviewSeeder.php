<?php

namespace Database\Seeders;

use App\Models\Project;
use App\Models\ProjectReview;
use Illuminate\Database\Seeder;

class ProjectReviewSeeder extends Seeder
{
    public function run(): void
    {

        $project = Project::first();

        if (!$project) {
            $this->command->warn(
                'No project found. Run ProjectSeeder first.'
            );

            return;
        }


        ProjectReview::firstOrCreate(
            [
                'project_id' => $project->id,
                'user_id'    => $project->user_id,
            ],
            [
                'contractor_id' => $project->contractor_id,
                'rating'        => 5,
            ]
        );

        $this->command->info(
            "✅ ProjectReviewSeeder done — review created for Project #{$project->id}."
        );
    }
}