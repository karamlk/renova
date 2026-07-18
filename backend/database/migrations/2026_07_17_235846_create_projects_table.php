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
        Schema::create('projects', function (Blueprint $table) {

            $table->id();

            $table->foreignId(
                'construction_form_id'
            )->constrained()
                ->cascadeOnDelete();

            $table->foreignId(
                'contractor_id'
            )->constrained('users');

            $table->foreignId(
                'engineer_id'
            )->constrained('users');

            $table->foreignId(
                'user_id'
            )->constrained('users');

            $table->decimal(
                'progress',
                5,
                2
            )->default(0);

            $table->enum('status',[
                'active',
                'completed',
                'cancelled'
            ])->default('active');

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('projects');
    }
};
