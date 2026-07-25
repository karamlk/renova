<?php

namespace App\Http\Controllers;

use App\Models\Payment;
use App\Models\PaymentAudit;
use App\Services\PaymentAuditService;
use App\Services\PaymentService;
use Illuminate\Http\Request;

class PaymentAuditController extends Controller
{
    public function index(
        Request $request
    )
    {
        return response()->json(

            app(PaymentAuditService::class)
                ->index($request)

        );
    }
    public function show(
        PaymentAudit $paymentAudit
    )
    {
        return response()->json(

            app(PaymentAuditService::class)
                ->show($paymentAudit)

        );
    }
}
