<?php

namespace App\Services;

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
}
