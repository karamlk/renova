<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('donation_campaigns', function (Blueprint $table) {

            $table->id();

            // طلب توثيق الـ Foundation التي أنشأت الحملة
            $table->foreignId('foundation_verification_request_id');

            $table->foreign(
                'foundation_verification_request_id',
                'dc_foundation_request_fk'
            )
                ->references('id')
                ->on('foundation_verification_requests')
                ->cascadeOnDelete();


            // طلب إعادة الإعمار الذي تم إنشاء الحملة لأجله
            $table->foreignId('reconstruction_request_id');

            $table->foreign(
                'reconstruction_request_id',
                'dc_reconstruction_request_fk'
            )
                ->references('id')
                ->on('reconstruction_requests')
                ->cascadeOnDelete();


            $table->string('title');

            $table->text('description')->nullable();

            $table->decimal(
                'target_amount',
                12,
                2
            );

            $table->decimal(
                'collected_amount',
                12,
                2
            )->default(0);

            $table->date('starts_at');

            $table->date('ends_at');

            $table->enum('status', [
                'pending',
                'active',
                'completed',
                'expired',
                'cancelled',
                'transferred'
            ])->default('pending');

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('donation_campaigns');
    }
};
