<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void {
        Schema::create('engineer_profiles', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->string('specialization'); // التخصص الإضافي
            $table->string('syndicate_number')->unique(); // رقم النقابة
            $table->string('degree'); // الشهادة العلمية
            $table->integer('years_of_experience')->default(0); // سنوات الخبرة
            $table->string('covered_zones'); // المناطق المغطاة
            $table->text('bio')->nullable(); // نبذة
            $table->string('syndicate_card_image')->nullable(); // صورة الهوية النقابية
            $table->string('certificate_file')->nullable(); // ملف الشهادة
            $table->boolean('is_verified')->default(false); // موافقة الآدمن
            $table->timestamps();
        });
    }

    public function down(): void {
        Schema::dropIfExists('engineer_profiles');
    }
};
