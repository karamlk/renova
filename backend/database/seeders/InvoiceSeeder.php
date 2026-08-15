<?php

namespace Database\Seeders;

use App\Models\Invoice;
use App\Models\Payment;
use App\Models\Project;
use Illuminate\Database\Seeder;

class InvoiceSeeder extends Seeder
{
    public function run(): void
    {

        $project = Project::first();

        if (!$project) {
            $this->command->warn(
                'No project found. Run ProjectSeeder first.'
            );

            return;
        }

        $payments = Payment::where(
            'construction_form_id',
            $project->construction_form_id
        )->get();

        if ($payments->isEmpty()) {
            $this->command->warn(
                'No payments found. Run PaymentsSeeder first.'
            );

            return;
        }

        foreach ($payments as $payment) {

            $invoiceNumber = 'INV-' .
                str_pad($payment->id, 6, '0', STR_PAD_LEFT);

            Invoice::firstOrCreate(
                [
                    'payment_id' => $payment->id,
                ],
                [
                    'invoice_number' => $invoiceNumber,

                    'project_id' => $project->id,

                    'user_id' => $project->user_id,

                    'contractor_id' => $project->contractor_id,

                    'amount' => $payment->amount,

                    'invoice_type' => $payment->type,

                    'status' => $payment->status === 'paid'
                        ? 'paid'
                        : 'issued',

                    'pdf_file' => null,

                    'notes' => match ($payment->type) {
                        'first_payment'  => 'فاتورة الدفعة الأولى للمشروع',
                        'second_payment' => 'فاتورة الدفعة الثانية للمشروع',
                        'final_payment'  => 'فاتورة الدفعة النهائية للمشروع',
                        default           => 'فاتورة المشروع',
                    },

                    'issued_at' => now(),
                ]
            );
        }

        $this->command->info(
            "✅ InvoiceSeeder done — invoices created for Project #{$project->id}."
        );
    }
}