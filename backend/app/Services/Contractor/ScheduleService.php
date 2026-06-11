<?php

namespace App\Services\Contractor;

use App\Models\ContractorSchedule;

class ScheduleService
{
    public function store(array $data)
    {
        $contractorId = auth()->id();

        $day = $data['day_of_week'];
        $start = $data['start_time'];
        $end = $data['end_time'];

        // 🔥 نجيب كل المواعيد لنفس اليوم
        $existingSchedules = ContractorSchedule::where('contractor_id', $contractorId)
            ->where('day_of_week', $day)
            ->get();

        foreach ($existingSchedules as $schedule) {

            // 🔥 شرط التداخل
            if (
                $start < $schedule->end_time &&
                $end > $schedule->start_time
            ) {
                throw new \Exception('يوجد تعارض مع موعد آخر');
            }
        }

        // إذا ما في تعارض → نحفظ
        return ContractorSchedule::create([
            'contractor_id' => $contractorId,
            'day_of_week' => $day,
            'start_time' => $start,
            'end_time' => $end,
        ]);
    }
}
