<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\WalletTransaction;
use Illuminate\Database\Seeder;

class WalletTransactionSeeder extends Seeder
{
    public function run(): void
    {

        $users = User::whereIn('email', [
            'seed_user@renova.com',
            'seed_contractor@renova.com',
        ])->get();

        if ($users->isEmpty()) {
            $this->command->warn(
                'No seeded users found. Run the user seeder first.'
            );

            return;
        }

        foreach ($users as $user) {

            $wallet = $user->wallet;

            if (!$wallet) {
                $this->command->warn(
                    "No wallet found for user #{$user->id}. Skipping."
                );

                continue;
            }

            $transactions = [];

            if ($user->email === 'seed_user@renova.com') {

                $transactions = [
                    [
                        'amount'      => 500000,
                        'type'        => 'deposit',
                        'reference'   => 'SEED-DEP-USER-001',
                        'description' => 'إيداع رصيد أولي للمستخدم',
                    ],
                    [
                        'amount'      => 600000,
                        'type'        => 'payment',
                        'reference'   => 'PAY-FIRST-001',
                        'description' => 'دفع الدفعة الأولى للمشروع',
                    ],
                    [
                        'amount'      => 100000,
                        'type'        => 'withdraw',
                        'reference'   => 'SEED-WD-USER-001',
                        'description' => 'عملية سحب تجريبية',
                    ],
                ];
            }


            elseif ($user->email === 'seed_contractor@renova.com') {

                $transactions = [
                    [
                        'amount'      => 300000,
                        'type'        => 'deposit',
                        'reference'   => 'SEED-DEP-CONT-001',
                        'description' => 'إيداع رصيد أولي للمتعهد',
                    ],
                    [
                        'amount'      => 10000,
                        'type'        => 'release',
                        'reference'   => 'RELEASE-001',
                        'description' => 'تحويل دفعة محررة للمتعهد',
                    ],
                    [
                        'amount'      => 5000,
                        'type'        => 'release',
                        'reference'   => 'RELEASE-002',
                        'description' => 'تحويل دفعة إضافية محررة للمتعهد',
                    ],
                    [
                        'amount'      => 200000,
                        'type'        => 'hold',
                        'reference'   => 'HOLD-001',
                        'description' => 'حجز مبلغ مستحق للمشروع',
                    ],
                ];
            }


            foreach ($transactions as $transaction) {

                WalletTransaction::firstOrCreate(
                    [
                        'wallet_id' => $wallet->id,
                        'reference' => $transaction['reference'],
                    ],
                    [
                        'amount'      => $transaction['amount'],
                        'type'        => $transaction['type'],
                        'description' => $transaction['description'],
                    ]
                );
            }
        }

        $this->command->info(
            '✅ WalletTransactionSeeder done.'
        );
    }
}
