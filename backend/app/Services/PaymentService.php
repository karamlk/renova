<?php

namespace App\Services;

use App\Models\Payment;
use App\Models\PaymentAudit;
use App\Models\Wallet;
use Exception;
use Illuminate\Http\Request; //

class PaymentService
{
    public function pay(
        Payment $payment
    )
    {
        if ($payment->user_id != auth()->id()) {

            throw new Exception(
                'لا يمكنك دفع هذه الدفعة'
            );

        }

        if ($payment->status != 'pending') {

            throw new Exception(
                'هذه الدفعة مدفوعة مسبقاً'
            );

        }
        $form = $payment->form;

        if (!$form || !$form->reconstructionRequest) {
            throw new Exception('نموذج الإعمار أو طلب الإعمار المرتبط بهذه الدفعة غير موجود');
        }

// 2. التأكد من وجود المستخدم ومحفظته
        $user = $form->reconstructionRequest->user;

        if (!$user || !$user->wallet) {
            throw new Exception('المستخدم أو محفظة المستخدم غير موجودة');
        }

        $userWallet = $user->wallet;

        $adminWallet = Wallet::where('user_id', 1)->firstOrFail();

        app(WalletService::class)->withdraw(
            $userWallet,
            $payment->amount,
            "Payment {$payment->id}"
        );
        app(WalletService::class)
            ->withdraw(

                $userWallet,

                $payment->amount,

                "Payment {$payment->id}"
            );

        app(WalletService::class)
            ->deposit(

                $adminWallet,

                $payment->amount,

                "Payment {$payment->id}"
            );

        $payment->update([

            'status' => 'paid',

            'paid_at' => now()

        ]);

        PaymentAudit::create([

            'payment_id' => $payment->id,

            'from_user_id' => $payment->user_id,

            'to_user_id' => 1,

            'amount' => $payment->amount,

            'action' => $payment->type,

            'description' => "Payment {$payment->id}"

        ]);
    }
    public function release(

        Payment $payment,

        float $amount

    )
    {
        if($payment->status=='pending'){

            throw new Exception(
                'هذه الدفعة غير جاهزة للتحويل'
            );

        }

        $remaining =

            $payment->amount -

            $payment->released_amount;

        if($amount>$remaining){

            throw new Exception(
                'المبلغ أكبر من المتبقي.'
            );

        }

        $form = $payment->form;

        $adminWallet =
            Wallet::where(
                'user_id',
                1
            )->firstOrFail();

        $contractorWallet =
            $form->contractor->wallet;

        app(WalletService::class)
            ->withdraw(

                $adminWallet,

                $amount,

                'Release'

            );

        app(WalletService::class)
            ->deposit(

                $contractorWallet,

                $amount,

                'Release'

            );

        $payment->increment(

            'released_amount',

            $amount

        );

        if(

            $payment->released_amount >= 0 && $payment->released_amount <$payment->amount
            //$payment->amount

        ){

            $payment->update([

                'status'=>'released'

            ]);

        }

        PaymentAudit::create([

            'payment_id'=>$payment->id,

            'from_user_id'=>1,

            'to_user_id'=>$form->contractor_id,

            'amount'=>$amount,

            'action'=>'release',

            'description'=>'تحويل جزئي للمتعهد'

        ]);
    }

    public function index(Request $request)
    {
        $query = Payment::query()

            ->with([

                'user',

                'form.reconstructionRequest',

                'form.contractor',

                'form.engineer'

            ]);

        if ($request->filled('status')) {

            $query->where(
                'status',
                $request->status
            );

        }

        if ($request->filled('type')) {

            $query->where(
                'type',
                $request->type
            );

        }

        if ($request->filled('user_id')) {

            $query->where(
                'user_id',
                $request->user_id
            );

        }

        if ($request->filled('contractor_id')) {

            $query->whereHas(
                'form',
                function ($q) use ($request) {

                    $q->where(
                        'contractor_id',
                        $request->contractor_id
                    );

                }
            );

        }

        if ($request->filled('keyword')) {

            $keyword = $request->keyword;

            $query->whereHas(
                'user',
                function ($q) use ($keyword) {

                    $q->where(
                        'name',
                        'like',
                        "%{$keyword}%"
                    );

                }
            );

        }

        return $query
            ->latest()
            ->paginate(15);
    }

    public function show(
        Payment $payment
    )
    {
        return $payment->load([

            'user',

            'form.reconstructionRequest',

            'form.contractor',

            'form.engineer',

            'form.materials'

        ]);
    }
}
