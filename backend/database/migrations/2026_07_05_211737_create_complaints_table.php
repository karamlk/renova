<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('complaints', function (Blueprint $table) {
            $table->id();

            // من رفع الشكوى
            $table->foreignId('complainant_id')
                ->constrained('users')
                ->cascadeOnDelete();

            // المشكو عليه — يُحدَّد تلقائياً من الباك
            $table->foreignId('complained_on_id')
                ->constrained('users')
                ->cascadeOnDelete();

            // الاستمارة المرتبطة — إلزامية لأن الشكوى دائماً مرتبطة بمشروع
            $table->foreignId('construction_form_id')
                ->constrained('construction_forms')
                ->cascadeOnDelete();

            $table->foreignId('complainant_role_id')
                ->constrained('roles');

            $table->foreignId('complained_on_role_id')
                ->constrained('roles');

            // نوع الشكوى — general افتراضياً
            $table->string('type')->default('general');

            // السبب — string حر
            $table->string('reason');

            // وصف اختياري
            $table->text('description')->nullable();

            // حالة الشكوى  
            $table->enum('status', [
                'open',
                'resolved',
                'dismissed',
            ])->default('open');

            // ملاحظة الأدمن عن طريقة المعالجة
            $table->string('admin_processing_note')->nullable();

            // العقوبة المالية
            $table->decimal('penalty_percentage', 5, 2)->nullable();
            $table->decimal('penalty_amount', 12, 2)->nullable();
            $table->decimal('compensation_amount', 12, 2)->nullable();

            $table->timestamp('resolved_at')->nullable();
            $table->softDeletes();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('complaints');
    }
};