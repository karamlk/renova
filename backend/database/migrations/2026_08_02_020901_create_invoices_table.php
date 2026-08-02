<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('invoices', function (Blueprint $table) {

            $table->id();

            $table->string('invoice_number')->unique();

            $table->foreignId('payment_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->foreignId('project_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->foreignId('user_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->foreignId('contractor_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->decimal('amount',12,2);

            $table->enum('invoice_type',[

                'first_payment',

                'second_payment',

                'final_payment',

                'release'

            ]);

            $table->enum('status',[

                'issued',

                'paid',

                'cancelled'

            ])->default('issued');

            $table->string('pdf_file')->nullable();

            $table->text('notes')->nullable();

            $table->timestamp('issued_at')->nullable();

            $table->timestamps();

        });
    }

    public function down(): void
    {
        Schema::dropIfExists('invoices');
    }
};
