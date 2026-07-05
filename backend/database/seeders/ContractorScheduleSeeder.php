<?php

namespace Database\Seeders;

use App\Models\ContractorSchedule;
use Illuminate\Database\Seeder;

class ContractorScheduleSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // إنشاء 50 سجل جدول مواعيد وهمي للمقاولين
        ContractorSchedule::factory()->count(50)->create();
    }
}
