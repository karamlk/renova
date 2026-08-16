<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('projects', function (Blueprint $table) {
            $table->date('project_ends_at')->nullable()->after('status');
            $table->date('warranty_ends_at')->nullable()->after('project_ends_at');
        });
    }

    public function down(): void
    {
        Schema::table('projects', function (Blueprint $table) {
            $table->dropColumn(['project_ends_at', 'warranty_ends_at']);
        });
    }
};
