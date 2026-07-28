<?php

namespace App\Services\Engineer;

use App\Models\Project;

class EngineerProjectService
{
    public function index()
    {
        return Project::with([

            'form.reconstructionRequest.user',

            'form.contractor'

        ])

            ->where(

                'engineer_id',

                auth()->id()

            )

            ->latest()

            ->get()

            ->map(function($project){

                return [

                    'id'=>$project->id,

                    'beneficiary'=>

                        $project
                            ->form
                            ->reconstructionRequest
                            ->user
                            ->name,

                    'contractor'=>

                        $project
                            ->form
                            ->contractor
                            ->name,

                    'progress'=>

                        $project->progress,

                    'status'=>

                        $this->status(

                            $project->status

                        )

                ];

            });

    }

    private function status($status)
    {
        return match($status){

            'active'=>'نشط',

            'completed'=>'مكتمل',

            'cancelled'=>'ملغي',

            default=>$status

        };
    }
    public function show(
        Project $project
    )
    {
        if(

            $project->engineer_id

            != auth()->id()

        ){

            abort(403);

        }

        $project->load([

            'form.reconstructionRequest.user.profile',

            'form.contractor',

            'tasks',

            'form.payments'

        ]);

        return [

            'id'=>$project->id,

            'beneficiary'=>[

                'id'=>

                    $project
                        ->user_id,

                'name'=>

                    $project
                        ->form
                        ->reconstructionRequest
                        ->user
                        ->name,

                'phone'=>

                    $project
                        ->form
                        ->reconstructionRequest
                        ->user
                        ->profile?->phone

            ],

            'contractor'=>[

                'id'=>

                    $project
                        ->contractor_id,

                'name'=>

                    $project
                        ->form
                        ->contractor
                        ->name

            ],

            'progress'=>

                $project->progress,

            'status'=>

                $this->status(

                    $project->status

                ),

            'total_cost'=>

                $project
                    ->form
                    ->total_cost,

            'tasks'=>

                $project
                    ->tasks,

            'payments'=>

                $project
                    ->form
                    ->payments

        ];

    }
}
