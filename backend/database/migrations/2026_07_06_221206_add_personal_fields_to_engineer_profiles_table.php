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
        Schema::table('engineer_profiles', function (Blueprint $table) {
            // إضافة الحقول الشخصية بعد حقل user_id وجعلها قابلة للحذف (nullable) تجنباً للمشاكل مع البيانات القديمة
            $table->string('first_name')->nullable()->after('user_id');
            $table->string('last_name')->nullable()->after('first_name');
            $table->string('phone')->nullable()->after('last_name');
            $table->string('location')->nullable()->after('phone');
            $table->string('image')->nullable()->after('location');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('engineer_profiles', function (Blueprint $table) {
            // في حال التراجع عن الـ migration يتم حذف الحقول
            $table->dropColumn(['first_name', 'last_name', 'phone', 'location', 'image']);
        });
    }
};
