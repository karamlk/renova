<?php

namespace App\Services;

use App\Models\Payment;
use App\Models\PaymentAudit;
use Illuminate\Http\Request;

class PaymentAuditService
{
    public function index(
        Request $request
    )
    {
        $query = PaymentAudit::query()

            ->with([

                'payment',

                'fromUser',

                'toUser'

            ]);

        if ($request->filled('action')) {

            $query->where(

                'action',

                $request->action

            );

        }

        if ($request->filled('payment_id')) {

            $query->where(

                'payment_id',

                $request->payment_id

            );

        }

        if ($request->filled('from_user')) {

            $query->where(

                'from_user_id',

                $request->from_user

            );

        }

        if ($request->filled('to_user')) {

            $query->where(

                'to_user_id',

                $request->to_user

            );

        }

        return $query

            ->latest()

            ->paginate(15);
    }

    public function show(
        PaymentAudit $paymentAudit
    )
    {
        return $paymentAudit->load([
            'payment',
            'fromUser',
            'toUser'

        ]);
    }
}
