<?php

namespace Database\Seeders;

use App\Models\ConstructionForm;
use App\Models\Project;
use Illuminate\Database\Seeder;

class ProjectSeeder extends Seeder
{
    public function run(): void
    {

        $form = ConstructionForm::where('status', 'user_approved')
            ->first();

        if (!$form) {
            $this->command->warn(
                'No user-approved construction form found. Run the construction form seeder first.'
            );

            return;
        }

        $project = Project::firstOrCreate(
            [
                'construction_form_id' => $form->id,
            ],
            [
                'contractor_id' => $form->contractor_id,
                'engineer_id'   => $form->engineer_id,
                'user_id'       => $form->reconstructionRequest->user_id,

                'progress'      => 35.00,
                'status'        => 'active',
            ]
        );


        if ($project->wasRecentlyCreated) {
            $this->command->info(
                "✅ ProjectSeeder done — Project #{$project->id} created."
            );
        } else {
            $this->command->info(
                "ℹ️ Project #{$project->id} already exists. Nothing duplicated."
            );
        }
    }
}