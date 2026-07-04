<?php

namespace App\Services\Payment;

use App\Models\Payment;
use Carbon\Carbon;

class PaymentService
{
    public function __construct(
        protected ShamCashService $shamCash
    ) {
    }

    public function verifyPayment(
        Payment $payment,
        string $accountId
    ) {
        $transactions =
            $this->shamCash->transactions([
                'account_id' => $accountId,
                'limit' => 100
            ]);

        foreach (
            $transactions['transactions']
            as $transaction
        ) {

            if (
                (float)$transaction['amount']
                == (float)$payment->amount
            ) {

                $payment->update([

                    'status' => 'paid',

                    'transaction_id'
                    => $transaction['id'],

                    'paid_at'
                    => Carbon::now()
                ]);

                return $payment;
            }
        }

        return null;
    }
}
