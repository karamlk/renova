<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        if (config('database.default') !== 'sqlite') {
        DB::statement("
            ALTER TABLE notifications
            MODIFY type ENUM(
                'new_request',
                'offer_accepted',
                'offer_rejected',
                'campaign_donation'
            ) NOT NULL
        ");
        }
    }

    public function down(): void
    {
        if (config('database.default') !== 'sqlite') {
        DB::statement("
            ALTER TABLE notifications
            MODIFY type ENUM(
                'new_request',
                'offer_accepted',
                'offer_rejected'
            ) NOT NULL
        ");
        }
    }
};
