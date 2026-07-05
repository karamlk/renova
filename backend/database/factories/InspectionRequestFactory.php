<?php

namespace Database\Factories;

use App\Models\InspectionRequest;
use App\Models\ReconstructionRequest;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class InspectionRequestFactory extends Factory
{
    protected $model = InspectionRequest::class;

    public function definition(): array
    {
        return [
            // جلب طلب إعادة إعمار موجود أو إنشاء واحد جديد
            'reconstruction_request_id' => ReconstructionRequest::inRandomOrder()->first()?->id ?? ReconstructionRequest::factory(),
            // جلب مقاول موجود أو إنشاء مستخدم جديد
            'contractor_id' => User::where('role_id', '3')->inRandomOrder()->first()?->id ?? User::factory(),
            // تحديد الحالة الافتراضية كـ 'accepted' بناءً على طلبك
            'status' => 'accepted',
        ];
    }
}
