<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('contractor_posts', function (Blueprint $table) {
            // نضيف index عادي حتى يبقى الـ Foreign Key مدعوم
            $table->index('project_id', 'contractor_posts_project_id_index');

            // بعدها نحذف الـ unique
            $table->dropUnique('contractor_posts_project_id_unique');
        });
    }

    public function down(): void
    {
        Schema::table('contractor_posts', function (Blueprint $table) {
            $table->unique('project_id', 'contractor_posts_project_id_unique');

            $table->dropIndex('contractor_posts_project_id_index');
        });
    }
};
