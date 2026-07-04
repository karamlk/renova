<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('construction_forms', function (Blueprint $table) {
            $table->id();

            // حقول الربط مع الجداول الأخرى (تأكد أن الجداول المرتبطة منشأة مسبقاً)
            $table->foreignId('reconstruction_request_id')->constrained('reconstruction_requests')->onDelete('cascade');
            $table->foreignId('contractor_id')->constrained('users')->onDelete('cascade');
            $table->foreignId('engineer_id')->constrained('users')->onDelete('cascade');

            // التفاصيل الفنية
            $table->text('building_description');
            $table->string('warranty_period');
            $table->string('execution_duration');

            // التكاليف المالية (الحسابات)
            $table->decimal('materials_cost', 12, 2);
            $table->decimal('labor_cost', 12, 2);
            $table->decimal('profit', 12, 2);
            $table->decimal('total_cost', 12, 2);

            // خانات الملاحظات
            $table->text('engineer_notes')->nullable();
            $table->text('user_notes')->nullable();

            // الحالات الخاصة بسير العمل (Workflow Status)
            $table->enum('status', [
                'pending_engineer',
                'engineer_approved',
                'engineer_rejected',
                'pending_user',

                'user_approved',
                'user_rejected'
            ])->default('pending_engineer');

            $table->string('pdf_file')->nullable(); // لحفظ مسار الملف إن وجد
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('construction_forms');
    }
};
