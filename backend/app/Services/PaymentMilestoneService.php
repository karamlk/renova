<?php

namespace App\Services;

use App\Models\Payment;
use App\Models\Project;
use App\Models\Notification;

class PaymentMilestoneService
{
    public function checkMilestones(
        Project $project
    )
    {
        $progress =

            $project
               // ->constructionForm
                ->tasks()
                ->where(
                    'is_completed',
                    true
                )
                ->sum('percentage');

        if ($progress < 50) {

            return;
        }

        $exists = Payment::where(

            'construction_form_id',

            $project->construction_form_id

        )
            ->where(

                'type',

                'second_payment'

            )

            ->exists();

        if ($exists) {

            return;
        }

        $amount =

            $project
               // ->constructionForm
                ->total_cost

            * 0.20;

        $payment = Payment::create([

            'construction_form_id'

            =>

                $project->construction_form_id,

            'user_id'

            =>

                $project->user_id,

            'amount'

            =>

                $amount,

            'type'

            =>

                'second_payment',

            'status'

            =>

                'pending'

        ]);

        app(NotificationService::class)

            ->send(

                $project->user_id,

                'الدفعة الثانية',

                'اكتمل 50٪ من المشروع، يرجى دفع الدفعة الثانية.',

                'payment',

                $payment->id,

                $project->construction_form_id

            );
        if($progress >= 100){

            $this->createFinalPayment(
                $project
            );

        }
    }

    private function createFinalPayment(
        Project $project
    )
    {
        $exists = Payment::where(

            'construction_form_id',

            $project->construction_form_id

        )
            ->where(
                'type',
                'final_payment'
            )
            ->exists();

        if($exists){
            return;
        }

        $payment = Payment::create([

            'construction_form_id'=>$project->construction_form_id,

            'user_id'=>$project->user_id,

            'amount'=>$project->constructionForm->total_cost*0.20,

            'type'=>'final_payment',

            'status'=>'pending'

        ]);

        app(NotificationService::class)
            ->send(

                $project->user_id,

                'الدفعة الأخيرة',

                'اكتمل المشروع، يرجى دفع الدفعة الأخيرة.',

                'payment',

                $payment->id,

                $project->construction_form_id
            );
    }
}
