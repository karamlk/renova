<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    //

    public function up(): void
    {
        // For testing
        // SQLite doesn't support MODIFY COLUMN, 
        if (config('database.default') !== 'sqlite') {
            DB::statement("
            ALTER TABLE construction_forms
            MODIFY status ENUM(
                'pending_engineer',
                'engineer_rejected',
                'pending_user',
                'waiting_payment_otp',
                'user_approved',
                'user_rejected'
            )
        ");
        }
    }
    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('construction_forms', function (Blueprint $table) {
            //
        });
    }
};
