
<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('inspection_requests', function (Blueprint $table) {

            $table->id();

            $table->foreignId('reconstruction_request_id')
                ->constrained()
                ->cascadeOnDelete();

            $table->foreignId('contractor_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->enum('status', [
                'pending',
                'accepted',
                'rejected',
            ])->default('pending');

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('inspection_requests');
    }
};
