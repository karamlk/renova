<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('inspection_requests', function (Blueprint $table) {
            $table->id();
            // الطلب الأساسي
            $table->foreignId('reconstruction_request_id')
                ->constrained()
                ->cascadeOnDelete();

            // المتعهد
            $table->foreignId('contractor_id')
                ->constrained('users')
                ->cascadeOnDelete();

            // حالة الطلب
            $table->enum('status', [

                'pending',

                'accepted',

                'rejected'

            ])->default('pending');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('inspection_requests');
    }
};
