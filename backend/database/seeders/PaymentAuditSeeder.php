<?php

namespace Database\Seeders;

use App\Models\ConstructionForm;
use App\Models\Payment;
use App\Models\PaymentAudit;
use Illuminate\Database\Seeder;

class PaymentAuditSeeder extends Seeder
{
    public function run(): void
    {
        PaymentAudit::truncate();

        $form = ConstructionForm::first();

        if (!$form) {
            return;
        }

        $adminId = 1;
        $contractorId = $form->contractor_id;

        $firstPayment = Payment::where(
            'construction_form_id',
            $form->id
        )
            ->where(
                'type',
                'first_payment'
            )
            ->first();

        $secondPayment = Payment::where(
            'construction_form_id',
            $form->id
        )
            ->where(
                'type',
                'second_payment'
            )
            ->first();

        /*
        |--------------------------------------
        | تدقيق الدفعة الأولى
        |--------------------------------------
        */
        if ($firstPayment) {

            PaymentAudit::create([

                'payment_id' => $firstPayment->id,

                'from_user_id' => $firstPayment->user_id,

                'to_user_id' => $adminId,

                'amount' => $firstPayment->amount,

                'action' => 'first_payment',

                'description' => 'تم دفع الدفعة الأولى'

            ]);

            /*
            |--------------------------------------
            | تحويل أول للمتعهد
            |--------------------------------------
            */

            PaymentAudit::create([

                'payment_id' => $firstPayment->id,

                'from_user_id' => $adminId,

                'to_user_id' => $contractorId,

                'amount' => 10000,

                'action' => 'release',

                'description' => 'تحويل أول للمتعهد'

            ]);

            /*
            |--------------------------------------
            | تحويل ثاني للمتعهد
            |--------------------------------------
            */

            PaymentAudit::create([

                'payment_id' => $firstPayment->id,

                'from_user_id' => $adminId,

                'to_user_id' => $contractorId,

                'amount' => 5000,

                'action' => 'release',

                'description' => 'تحويل ثاني للمتعهد'

            ]);
        }

        /*
        |--------------------------------------
        | تدقيق الدفعة الثانية
        |--------------------------------------
        */

        if ($secondPayment) {

            PaymentAudit::create([

                'payment_id' => $secondPayment->id,

                'from_user_id' => $secondPayment->user_id,

                'to_user_id' => $adminId,

                'amount' => $secondPayment->amount,

                'action' => 'second_payment',

                'description' => 'تم دفع الدفعة الثانية'

            ]);

            /*
            |--------------------------------------
            | تحويل من الدفعة الثانية
            |--------------------------------------
            */

            PaymentAudit::create([

                'payment_id' => $secondPayment->id,

                'from_user_id' => $adminId,

                'to_user_id' => $contractorId,

                'amount' => 7000,

                'action' => 'release',

                'description' => 'تحويل من الدفعة الثانية'

            ]);
        }
    }
}
