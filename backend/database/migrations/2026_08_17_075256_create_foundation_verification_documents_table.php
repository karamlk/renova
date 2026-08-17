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
        Schema::create('foundation_verification_documents', function (Blueprint $table) {
            $table->id();

            $table->foreignId('foundation_verification_request_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->string('document');

            $table->string('type')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('foundation_verification_documents');
    }
};
