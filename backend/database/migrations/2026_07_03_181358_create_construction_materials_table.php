<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('construction_materials', function (Blueprint $table) {
            $table->id();

            // الربط مع جدول الاستمارات (تأكدي من اسم الجدول لديكِ، هنا افترضت أن اسمه construction_forms)
            $table->foreignId('construction_form_id')
                ->constrained('construction_forms')
                ->cascadeOnDelete();

            $table->string('material_name'); // اسم المادة (مثال: أسمنت، حديد)
            $table->string('material_type'); // نوع المادة (مثال: مقاوم للكبريتات، مبروم 12 ملم)
            $table->double('quantity', 8, 2); // الكمية
            $table->string('unit'); // الوحدة (مثال: طن، متر مكعب، كيس)
            $table->double('unit_price', 10, 2); // سعر الوحدة
            $table->double('total_price', 12, 2); // السعر الإجمالي (الكمية × سعر الوحدة)

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('construction_materials');
    }
};
