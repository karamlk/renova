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

            $table->foreignId('reporter_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->foreignId('reported_id')
                ->constrained('users')
                ->cascadeOnDelete();

            $table->enum('reported_role', ['user', 'contractor']);

            // هل هذا التحذير تم احتسابه ضمن عقوبة مطبقة
            $table->boolean('penalty_applied')->default(false);

            // مبلغ العقوبة — يُملأ فقط عند تطبيق العقوبة
            $table->decimal('penalty_amount', 12, 2)->nullable();

            // منع تكرار البلاغ من نفس الشخص على نفس الزيارة
            $table->unique(['site_visit_id', 'reporter_id']);

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('no_show_warnings');
    }
};
