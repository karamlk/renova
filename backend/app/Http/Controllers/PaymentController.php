<?php

namespace App\Http\Controllers;

use App\Http\Requests\Admin\ReleasePaymentRequest;
use App\Http\Requests\ConfirmPaymentRequest;
use App\Models\Payment;
use App\Services\Auth\OtpService;
use App\Services\PaymentService;
use Exception;
use Illuminate\Http\Request;

class PaymentController extends Controller
{
    //
    public function pay(
        ConfirmPaymentRequest $request,
        Payment $payment
    )
    {
        if ($payment->status == 'paid') {
            throw new Exception('تم دفع هذه الدفعة مسبقاً');
        }

        app(OtpService::class)->verifyPaymentOtp(
            auth()->user(),
            $request->otp
        );

        app(PaymentService::class)
            ->pay($payment);

        return response()->json([
            'message' => 'تم الدفع بنجاح'
        ]);
    }
    public function pending()
    {
        return Payment::where(

            'user_id',

            auth()->id()

        )
            ->where(
                'status',
                'pending'
            )
            ->latest()
            ->get();
    }
    public function release(
        ReleasePaymentRequest $request,
        Payment $payment
    )
    {
        app(PaymentService::class)

            ->release(

                $payment,

                $request->amount

            );

        return response()->json([

            'message'=>'تم تحويل المبلغ بنجاح'

        ]);
    }
    public function sendOtp(Payment $payment)
    {
        if ($payment->user_id != auth()->id()) {
            abort(403);
        }

        app(OtpService::class)->send(auth()->user());

        return response()->json([
            'message' => 'تم إرسال رمز التحقق إلى بريدك الإلكتروني.'
        ]);
    }

    public function index(Request $request)
    {
        return response()->json(

            app(PaymentService::class)
                ->index($request)

        );
    }
    public function show(
        Payment $payment
    )
    {
        return response()->json(

            app(PaymentService::class)
                ->show($payment)

        );
    }
}
