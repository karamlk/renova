<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        if (Schema::hasColumn('notifications', 'construction_form_id')) {

            Schema::table('notifications', function (Blueprint $table) {
                $table->dropForeign(['construction_form_id']);
            });

            Schema::table('notifications', function (Blueprint $table) {
                $table->dropColumn('construction_form_id');
            });
        }

        if (config('database.default') !== 'sqlite') {
            DB::statement("
                ALTER TABLE notifications
                MODIFY COLUMN type ENUM(
                    'new_user',
                    'new_contractor',
                    'inspection_request',
                    'complaint',
                    'payment',
                    'foundation',
                    'general'
                ) DEFAULT 'general'
            ");
        }

        if (!Schema::hasColumn('notifications', 'target_path')) {
            Schema::table('notifications', function (Blueprint $table) {
                $table->string('target_path')
                    ->nullable()
                    ->after('type');
            });
        }

        if (config('database.default') !== 'sqlite') {
            if (Schema::hasColumn('notifications', 'related_id')) {
                DB::statement("ALTER TABLE notifications MODIFY COLUMN related_id BIGINT UNSIGNED NULL AFTER target_path");
                
                DB::statement("ALTER TABLE notifications MODIFY COLUMN created_at TIMESTAMP NULL AFTER related_id");
            } else {
                DB::statement("ALTER TABLE notifications MODIFY COLUMN created_at TIMESTAMP NULL AFTER target_path");
            }
            
            DB::statement("ALTER TABLE notifications MODIFY COLUMN updated_at TIMESTAMP NULL AFTER created_at");
        }
    }

    public function down(): void
    {
        if (Schema::hasColumn('notifications', 'target_path')) {
            Schema::table('notifications', function (Blueprint $table) {
                $table->dropColumn('target_path');
            });
        }

        if (!Schema::hasColumn('notifications', 'construction_form_id')) {
            Schema::table('notifications', function (Blueprint $table) {
                $table->foreignId('construction_form_id')
                    ->nullable()
                    ->constrained('construction_forms')
                    ->nullOnDelete();
            });
        }

        if (config('database.default') !== 'sqlite') {
            DB::statement("
                ALTER TABLE notifications
                MODIFY COLUMN type ENUM(
                    'construction_form',
                    'payment',
                    'project',
                    'general'
                ) DEFAULT 'general'
            ");
        }
        
        if (config('database.default') !== 'sqlite') {
            DB::statement("ALTER TABLE notifications MODIFY COLUMN created_at TIMESTAMP NULL AFTER is_read");
            DB::statement("ALTER TABLE notifications MODIFY COLUMN updated_at TIMESTAMP NULL AFTER created_at");
        }
    }
};
