<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('site_visits', function (Blueprint $table) {
            // 1. إضافة حقل المهندس المفرز ويقبل قيم فارغة في البداية
            $table->foreignId('engineer_id')
                ->nullable()
                ->after('schedule_id') // لترتيب الحقول في الداتابيز
                ->constrained('users')
                ->nullOnDelete();

            // 2. إضافة حقل الحالة بعد حقل المهندس
            $table->string('status')
                ->default('pending')
                ->after('engineer_id'); // pending, accepted, rejected, completed
        });
    }

    public function down(): void
    {
        Schema::table('site_visits', function (Blueprint $table) {
            // تراجع عن التعديلات في حال عمل rollback
            $table->dropForeign(['engineer_id']);
            $table->dropColumn(['engineer_id', 'status']);
        });
    }
};
