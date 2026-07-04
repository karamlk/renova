<?php

namespace App\Http\Controllers;

use App\Models\ConstructionForm;
use App\Services\Payment\PaymentService;
use Faker\Provider\Payment;

class PaymentController
{
    public function verify(
        Payment $payment,
        PaymentService $service
    )
    {
        $accountId = request('account_id');

        $result = $service->verifyPayment(
            $payment,
            $accountId
        );

        if (!$result) {

            return response()->json([
                'message' =>
                    'لم يتم العثور على حوالة مطابقة'
            ], 404);
        }

        return response()->json([
            'message' =>
                'تم تأكيد الدفع بنجاح',
            'data' => $result
        ]);
    }
    public function createInitialPayment(ConstructionForm $form)
    {
        $amount = $form->total_cost * 0.60;

        $payment = Payment::create([
            'construction_form_id' => $form->id,
            'user_id' => auth()->id(),
            'amount' => $amount,
            'type' => 'initial_60',
            'status' => 'pending',
        ]);

        return response()->json([
            'message' => 'جاهز للدفع',
            'data' => $payment
        ]);
    }

    public function confirmPayment(Payment $payment)
    {
        $payment->update([
            'status' => 'paid',
            'paid_at' => now(),
        ]);

        return response()->json([
            'message' => 'تم تأكيد الدفع'
        ]);
    }
}
