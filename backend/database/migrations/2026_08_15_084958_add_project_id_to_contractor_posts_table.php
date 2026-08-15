<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('contractor_posts', function (Blueprint $table) {

            $table->foreignId('project_id')
                ->nullable()
                ->after('id')
                ->constrained('projects')
                ->cascadeOnDelete();

            $table->unique('project_id');
        });
    }

    public function down(): void
    {
        Schema::table('contractor_posts', function (Blueprint $table) {

            $table->dropForeign([
                'project_id'
            ]);

            $table->dropUnique([
                'contractor_posts_project_id_unique'
            ]);

            $table->dropColumn('project_id');
        });
    }
};
