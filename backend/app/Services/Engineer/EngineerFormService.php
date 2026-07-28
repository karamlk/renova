<?php

namespace App\Services\Engineer;

use App\Models\ConstructionForm;

class EngineerFormService
{
    public function index(
        ?string $status=null
    )
    {
        $query = ConstructionForm::with([

            'contractor',

            'reconstructionRequest.user'

        ])

            ->where(

                'engineer_id',

                auth()->id()

            );

        if($status){

            $query->where(
                'status',
                $status
            );

        }

        return $query

            ->latest()

            ->get()

            ->map(function($form){

                return [

                    'id'=>$form->id,

                    'beneficiary'=>

                        $form
                            ->reconstructionRequest
                            ->user
                            ->name,

                    'contractor'=>

                        $form
                            ->contractor
                            ->name,

                    'total_cost'=>

                        $form
                            ->total_cost,

                    'status'=>

                        $this->status(
                            $form->status
                        ),

                    'created_at'=>

                        $form
                            ->created_at
                            ->format('Y-m-d')

                ];

            });

    }

    private function status(
        $status
    )
    {
        return match($status){

            'pending_engineer'=>

            'بانتظار المراجعة',

            'engineer_approved'=>

            'تمت الموافقة',

            'engineer_rejected'=>

            'مرفوضة',

            default=>$status

        };
    }
    public function show(
        ConstructionForm $form
    )
    {
        if(

            $form->engineer_id

            != auth()->id()

        ){

            abort(403);

        }

        $form->load([

            'contractor',

            'materials',

            'reconstructionRequest.user.profile',

            'reconstructionRequest'

        ]);

        return [

            'id'=>$form->id,

            'status'=>$this->status(

                $form->status

            ),

            'beneficiary'=>[

                'id'=>

                    $form
                        ->reconstructionRequest
                        ->user
                        ->id,

                'name'=>

                    $form
                        ->reconstructionRequest
                        ->user
                        ->name,

                'phone'=>

                    $form
                        ->reconstructionRequest
                        ->user
                        ->profile?->phone

            ],

            'contractor'=>[

                'id'=>

                    $form
                        ->contractor
                        ->id,

                'name'=>

                    $form
                        ->contractor
                        ->name

            ],

            'request'=>[

                'title'=>

                    $form
                        ->reconstructionRequest
                        ->title,

                'description'=>

                    $form
                        ->reconstructionRequest
                        ->description,

                'location'=>

                    $form
                        ->reconstructionRequest
                        ->location,

                'type'=>

                    $form
                        ->reconstructionRequest
                        ->type

            ],

            'form'=>[

                'building_description'=>

                    $form->building_description,

                'execution_duration'=>

                    $form->execution_duration,

                'warranty_period'=>

                    $form->warranty_period,

                'materials_cost'=>

                    $form->materials_cost,

                'labor_cost'=>

                    $form->labor_cost,

                'profit'=>

                    $form->profit,

                'total_cost'=>

                    $form->total_cost

            ],

            'materials'=>

                $form->materials,

            'pdf'=>

                $form->pdf_file

                    ? asset(

                    'storage/'.

                    $form->pdf_file

                )

                    : null

        ];

    }
}
