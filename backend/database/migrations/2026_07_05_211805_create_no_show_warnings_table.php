<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('no_show_warnings', function (Blueprint $table) {
            $table->id();

            $table->foreignId('site_visit_id')
                ->constrained('site_visits')
                ->cascadeOnDelete();

            // من أبلغ
            $table->foreignId('reporter_id')
                ->constrained('users')
                ->cascadeOnDelete();

            // من تغيب
            $table->foreignId('reported_id')
                ->constrained('users')
                ->cascadeOnDelete();

            // id الدور بدل اسمه
            $table->foreignId('reporter_role_id')
                ->constrained('roles');

            $table->foreignId('reported_role_id')
                ->constrained('roles');

            // نوع الشكوى — ثابت دائماً
            $table->string('type')->default('no_show');

            // السبب — ثابت يُملأ تلقائياً
            $table->string('reason')->default('عدم الحضور إلى الزيارة الميدانية');

            // الوصف — يُملأ تلقائياً مع رقم الزيارة
            $table->text('description')->nullable();

            // هل تم احتساب هذا التحذير ضمن عقوبة (تعطيل الحساب)
            $table->boolean('penalty_applied')->default(false);

            // منع نفس الشخص من الإبلاغ على نفس الشخص في نفس الزيارة مرتين
            $table->unique(['site_visit_id', 'reporter_id', 'reported_id']);

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('no_show_warnings');
    }
};