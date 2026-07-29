<?php
namespace Database\Seeders;
use App\Models\ConstructionForm;
use App\Models\Payment;
use App\Models\PaymentAudit;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class PaymentsSeeder extends Seeder
{
    public function run(): void
    {
        DB::statement('SET FOREIGN_KEY_CHECKS=0;');

        PaymentAudit::truncate();

        Payment::truncate();

        DB::statement('SET FOREIGN_KEY_CHECKS=1;');

        $form = ConstructionForm::first();

        if (!$form) {
            return;
        }

        $userId = $form->reconstructionRequest->user_id;

        Payment::create([
            'construction_form_id' => $form->id,
            'user_id' => $userId,
            'amount' => $form->total_cost * 0.60,
            'type' => 'first_payment',
            'status' => 'paid',
            'paid_at' => now(),
        ]);

        Payment::create([
            'construction_form_id' => $form->id,
            'user_id' => $userId,
            'amount' => $form->total_cost * 0.20,
            'type' => 'second_payment',
            'status' => 'pending',
        ]);

        Payment::create([
            'construction_form_id' => $form->id,
            'user_id' => $userId,
            'amount' => $form->total_cost * 0.20,
            'type' => 'final_payment',
            'status' => 'pending',
        ]);
    }
}
