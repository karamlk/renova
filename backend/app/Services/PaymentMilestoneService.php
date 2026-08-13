<?php

namespace App\Services;

use App\Models\Payment;
use App\Models\Project;
use App\Services\NotificationService;
use Exception;

class PaymentMilestoneService
{
    public function checkMilestones(Project $project)
    {
        // جلب الاستمارة المرتبطة بالمشروع
        $form = $project->form;

        if (!$form) {
            throw new Exception(
                'استمارة الإعمار المرتبطة بالمشروع غير موجودة'
            );
        }

        // التأكد من وجود التكلفة الكلية
        $totalCost = (float) $form->total_cost;

        if ($totalCost <= 0) {
            throw new Exception(
                'إجمالي تكلفة المشروع غير صحيح'
            );
        }

        /*
        |--------------------------------------------------------------------------
        | حساب نسبة الإنجاز
        |--------------------------------------------------------------------------
        */

        $progress = $project
            ->tasks()
            ->where('is_completed', true)
            ->sum('percentage');

        /*
        |--------------------------------------------------------------------------
        | الدفعة الثانية - عند 50%
        |--------------------------------------------------------------------------
        */

        if ($progress >= 50) {

            $exists = Payment::where(
                'construction_form_id',
                $project->construction_form_id
            )
                ->where(
                    'type',
                    'second_payment'
                )
                ->exists();

            if (!$exists) {

                $amount = $totalCost * 0.20;

                $payment = Payment::create([

                    'construction_form_id'
                    => $project->construction_form_id,

                    'user_id'
                    => $project->user_id,

                    'amount'
                    => $amount,

                    'type'
                    => 'second_payment',

                    'status'
                    => 'pending',

                ]);

                app(NotificationService::class)->send(

                    $project->user_id,

                    'الدفعة الثانية',

                    'اكتمل 50٪ من المشروع، يرجى دفع الدفعة الثانية.',

                    'payment',

                    $payment->id,

                    $project->construction_form_id

                );
            }
        }

        /*
        |--------------------------------------------------------------------------
        | الدفعة الأخيرة - عند 100%
        |--------------------------------------------------------------------------
        */

        if ($progress >= 100) {

            $this->createFinalPayment(
                $project,
                $totalCost
            );
        }
    }


    private function createFinalPayment(
        Project $project,
        float $totalCost
    ) {

        $exists = Payment::where(

            'construction_form_id',

            $project->construction_form_id

        )
            ->where(

                'type',

                'final_payment'

            )
            ->exists();

        if ($exists) {

            return;
        }


        $amount = $totalCost * 0.20;


        $payment = Payment::create([

            'construction_form_id'
            => $project->construction_form_id,

            'user_id'
            => $project->user_id,

            'amount'
            => $amount,

            'type'
            => 'final_payment',

            'status'
            => 'pending',

        ]);


        app(NotificationService::class)->send(

            $project->user_id,

            'الدفعة الأخيرة',

            'اكتمل المشروع بنسبة 100٪، يرجى دفع الدفعة الأخيرة.',

            'payment',

            $payment->id,

            $project->construction_form_id

        );
    }
}
