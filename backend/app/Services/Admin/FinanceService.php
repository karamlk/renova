<?php

namespace App\Services\Admin;

use App\Models\Payment;
use App\Models\Project;
use App\Models\Wallet;

class FinanceService
{
    public function dashboard(): array
    {
        $adminWallet = Wallet::where('user_id', 1)->first();

        return [

            'admin_balance' => $adminWallet?->balance ?? 0,

            'total_received' => Payment::where('status', 'paid')
                ->sum('amount'),

            'total_released' => Payment::where('status', 'released')
                ->sum('released_amount'),

            'pending_payments' => Payment::where('status', 'pending')
                ->count(),

            'waiting_release' => Payment::where(function ($q) {

                $q->where('status', 'paid')
                    ->orWhere(function ($query) {

                        $query->where('status', 'released')
                            ->whereColumn(
                                'released_amount',
                                '<',
                                'amount'
                            );
                    });

            })->count()

        ];
    }
    public function report()
    {
        return [

            /*
             |-------------------------------------
             | المشاريع
             |-------------------------------------
             */

            'total_projects'=>

                Project::count(),

            'active_projects'=>

                Project::where(
                    'status',
                    'active'
                )->count(),

            'completed_projects'=>

                Project::where(
                    'status',
                    'completed'
                )->count(),

            /*
             |-------------------------------------
             | الدفعات
             |-------------------------------------
             */

            'payments_count'=>

                Payment::count(),

            'paid_payments'=>

                Payment::where(
                    'status',
                    'paid'
                )->count(),

            'pending_payments'=>

                Payment::where(
                    'status',
                    'pending'
                )->count(),

            /*
             |-------------------------------------
             | الأموال
             |-------------------------------------
             */

            'total_payments_amount'=>

                Payment::sum('amount'),

            'released_amount'=>

                Payment::sum('released_amount'),

            'remaining_amount'=>

                Payment::sum('amount')
                -
                Payment::sum('released_amount'),

            /*
             |-------------------------------------
             | حسب نوع الدفعة
             |-------------------------------------
             */

            'first_payment_total'=>

                Payment::where(
                    'type',
                    'first_payment'
                )->sum('amount'),

            'second_payment_total'=>

                Payment::where(
                    'type',
                    'second_payment'
                )->sum('amount'),

            'final_payment_total'=>

                Payment::where(
                    'type',
                    'final_payment'
                )->sum('amount'),

        ];
    }
}
