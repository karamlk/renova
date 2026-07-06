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

            // المشكو عليه
            $table->foreignId('complained_on_id')
                ->constrained('users')
                ->cascadeOnDelete();

            // الاستمارة المرتبطة بالشكوى
            $table->foreignId('construction_form_id')
                ->constrained('construction_forms')
                ->cascadeOnDelete();

            // أدوار الطرفين
            $table->enum('complainant_role', ['customer', 'contractor', 'engineer']);
            $table->enum('complained_on_role', ['customer', 'contractor', 'engineer']);

            // سبب الشكوى (المفتاح المرسل من الفرونت)
            $table->string('reason');

            // وصف اختياري
            $table->text('description')->nullable();

            // إخفاء هوية المشتكي عن المشكو عليه
            $table->boolean('is_anonymous')->default(false);

            // حالة الشكوى
            $table->enum('status', [
                'open',
                'under_review',
                'resolved',
                'dismissed'
            ])->default('open');

            // قرار الأدمن
            $table->text('admin_note')->nullable();

            // العقوبة المالية (فقط عند customer ↔ contractor)
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
