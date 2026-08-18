<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::statement("
            ALTER TABLE notifications
            MODIFY type ENUM(
                'new_request',
                'campaign_donation',
                'inspection_request',
                'inspection_accepted',
                'inspection_rejected',
                'form'
            ) NOT NULL
        ");
    }

    public function down(): void
    {
        DB::statement("
            ALTER TABLE notifications
            MODIFY type ENUM(
                'new_request',
                'campaign_donation',
                'inspection_request',
                'inspection_accepted',
                'inspection_rejected'
            ) NOT NULL
        ");
    }
};
