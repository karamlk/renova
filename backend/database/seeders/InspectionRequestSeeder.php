<?php

namespace Database\Seeders;

use App\Models\InspectionRequest;
use App\Models\ContractorSchedule;
use App\Models\SiteVisit;
use Illuminate\Database\Seeder;

class InspectionRequestSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // تأكد من وجود جداول مواعيد للمقاولين أولاً في قاعدة البيانات
        if (ContractorSchedule::count() === 0) {
            $this->command->warn('يرجى تشغيل ContractorScheduleSeeder أولاً لتوفير مواعيد مقاولين.');
            return;
        }

        // إنشاء 20 طلب فحص مقبول
        InspectionRequest::factory()->count(20)->create()->each(function ($inspection) {

            // جلب جدول مواعيد عشوائي يخص نفس المقاول صاحب الطلب (أو أي جدول مواعيد متاح)
            $schedule = ContractorSchedule::where('contractor_id', $inspection->contractor_id)->inRandomOrder()->first()
                ?? ContractorSchedule::inRandomOrder()->first();

            // إنشاء زيارة الموقع (SiteVisit) وربطها بالطلب المقبول والجدول
            SiteVisit::create([
                'inspection_request_id' => $inspection->id,
                'schedule_id'           => $schedule->id,
                'visit_date'            => \Carbon\Carbon::now()
                    ->next($schedule->day_of_week)
                    ->format('Y-m-d'),
            ]);
        });
    }
}
