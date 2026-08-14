<?php

namespace Database\Seeders;

use App\Models\ContractorPost;
use App\Models\User;
use Illuminate\Database\Seeder;

class ContractorPostSeeder extends Seeder
{
    public function run(): void
    {

        $contractor = User::where(
            'email',
            'seed_contractor@renova.com'
        )->first();

        if (!$contractor) {
            $this->command->warn(
                'Seed contractor not found. Run your user seeder first.'
            );

            return;
        }


        $posts = [
            [
                'title' => 'Residential Building Renovation',
                'description' =>
                    'Completed a full residential renovation including structural repairs, '
                    . 'electrical work, plumbing, flooring and interior finishing.',
                'status' => 'completed',
                'progress' => 100,
            ],

            [
                'title' => 'Modern Kitchen Renovation',
                'description' =>
                    'Renovation of a residential kitchen including new cabinets, '
                    . 'flooring, electrical connections and plumbing.',
                'status' => 'completed',
                'progress' => 100,
            ],

            [
                'title' => 'Two-Story House Construction',
                'description' =>
                    'Construction of a two-story residential building currently in '
                    . 'the structural construction phase.',
                'status' => 'in_progress',
                'progress' => 65,
            ],

            [
                'title' => 'Commercial Building Finishing',
                'description' =>
                    'Interior and exterior finishing work for a commercial building, '
                    . 'including painting, flooring and installation work.',
                'status' => 'in_progress',
                'progress' => 40,
            ],
        ];

        foreach ($posts as $post) {
            ContractorPost::firstOrCreate(
                [
                    'user_id' => $contractor->id,
                    'title' => $post['title'],
                ],
                [
                    'description' => $post['description'],
                    'status' => $post['status'],
                    'progress' => $post['progress'],
                ]
            );
        }


        $this->command->info(
            "✅ ContractorPostSeeder done — posts created for contractor #{$contractor->id}."
        );
    }
}