<?php

namespace App\Services;

use App\Models\PaymentAudit;
use App\Models\Project;
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
    ) {
        DB::transaction(function () use (
            $wallet,
            $amount,
            $description
        ) {

            $wallet = Wallet::lockForUpdate()->find($wallet->id);

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
    ) {
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
            $wallet = Wallet::lockForUpdate()->find($wallet->id);

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

    /**
     * تحويل أموال من محفظة إلى أخرى عبر رقم المحفظة
     */
    public function transfer(string $toCardNumber, float $amount, ?string $description = null)
    {
        $senderWallet = Wallet::where('user_id', auth()->id())->firstOrFail();

        // 1. التحقق من أن الرصيد كافٍ
        if ($senderWallet->balance < $amount) {
            abort(422, 'الرصيد غير كافٍ لتنفيذ التحويل');
        }

        // 2. البحث عن محفظة المستلم
        $receiverWallet = Wallet::where('card_number', $toCardNumber)->first();

        if (!$receiverWallet) {
            abort(444, 'رقم المحفظة المستهدفة غير موجود');
        }

        // 3. منع التحويل لنفس المحفظة
        if ($senderWallet->id === $receiverWallet->id) {
            abort(422, 'لا يمكنك التحويل لنفس المحفظة');
        }

        // 4. تنفيذ عملية التحويل داخل Transaction لتضمن سلامة البيانات
        DB::transaction(function () use ($senderWallet, $receiverWallet, $amount, $description) {

            // الخصم من المنسل
            $senderWallet->decrement('balance', $amount);
            WalletTransaction::create([
                'wallet_id'   => $senderWallet->id,
                'amount'      => $amount,
                'type'        => 'withdraw',
                'description' => $description ?? 'تحويل إلى محفظة: ' . $receiverWallet->card_number
            ]);

            // الإضافة للمستلم
            $receiverWallet->increment('balance', $amount);
            WalletTransaction::create([
                'wallet_id'   => $receiverWallet->id,
                'amount'      => $amount,
                'type'        => 'deposit',
                'description' => $description ?? 'تحويل مالي وارد من: ' . auth()->user()->name
            ]);
        });

        return ['message' => 'تم التحويل بنجاح'];
    }

    /**
     * جلب المهندسين المرتبطين بمشاريع المقاول الحالي (لتسهيل اختيار المحفظة)
     */
    public function getMyContractorEngineers()
    {
        $contractorId = auth()->id();

        // جلب كل المهندسين المعينين على مشاريع هذا المقاول مع أرقام محافظهم
        return Project::where('contractor_id', $contractorId)
            ->with(['engineer.wallet:id,user_id,card_number'])
            ->get()
            ->pluck('engineer')
            ->unique('id')
            ->values()
            ->map(function ($engineer) {
                return [
                    'engineer_id'   => $engineer?->id,
                    'engineer_name' => $engineer?->name,
                    'card_number'   => $engineer?->wallet?->card_number,
                ];
            });
    }
}
