<?php

namespace App\Services;

use App\Models\PaymentAudit;
use App\Models\Wallet;
use App\Models\WalletTransaction;
use Exception;
use Illuminate\Support\Facades\DB;

class WalletService
{
    public function deposit(
        Wallet $wallet,
        float $amount,
        string $description = null
    )
    {
        DB::transaction(function () use (
            $wallet,
            $amount,
            $description
        ) {

            $wallet->increment(
                'balance',
                $amount
            );

            WalletTransaction::create([
                'wallet_id' => $wallet->id,
                'amount' => $amount,
                'type' => 'deposit',
                'description' => $description
            ]);
        });
    }

    public function withdraw(
        Wallet $wallet,
        float $amount,
        string $description = null
    )
    {
        if (
            $wallet->balance < $amount
        ) {
             abort(422, 'الرصيد غير كافٍ');
        }

        DB::transaction(function () use (
            $wallet,
            $amount,
            $description
        ) {

            $wallet->decrement(
                'balance',
                $amount
            );

            WalletTransaction::create([
                'wallet_id' => $wallet->id,
                'amount' => $amount,
                'type' => 'withdraw',
                'description' => $description
            ]);
        });
    }

    public function myFinancialAccount()
    {
        $userId = auth()->id();

        $wallet = Wallet::where(
            'user_id',
            $userId
        )->firstOrFail();

        $audits = PaymentAudit::with([
            'fromUser:id,name',
            'toUser:id,name',
            'payment.invoice'
        ])
            ->where(function ($query) use ($userId) {
                $query->where('from_user_id', $userId)
                    ->orWhere('to_user_id', $userId);
            })
            ->latest()
            ->get();

        return [
            'balance' => $wallet->balance,

            'card_number' => $wallet->card_number,

            'transactions' => $audits
        ];
    }
}
