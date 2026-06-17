<?php

namespace App\Services\Contractor;

use App\Models\ContractorSchedule;
use App\Models\SiteVisit;
use Carbon\Carbon;

class ScheduleService
{
    public function store(array $data): array
    {
        $contractorId = auth()->id();

        $startTime = Carbon::createFromFormat(
            'h:i A',
            $data['start_time']
        )->format('H:i:s');

        $endTime = Carbon::createFromFormat(
            'h:i A',
            $data['end_time']
        )->format('H:i:s');

        $this->validateNoOverlap(
            $contractorId,
            $data['day_of_week'],
            $startTime,
            $endTime
        );

        $schedule = ContractorSchedule::create([
            'contractor_id' => $contractorId,
            'day_of_week' => $data['day_of_week'],
            'start_time' => $startTime,
            'end_time' => $endTime,
        ]);

        return [
            'id' => $schedule->id,

            'date' => $this->getNextDate(
                $schedule->day_of_week
            ),

            'day' => ucfirst(
                $schedule->day_of_week
            ),

            'start_time' => Carbon::parse(
                $schedule->start_time
            )->format('h:i A'),

            'end_time' => Carbon::parse(
                $schedule->end_time
            )->format('h:i A'),
        ];
    }

    public function getSchedules(int $contractorId)
    {
        return ContractorSchedule::where(
            'contractor_id',
            $contractorId
        )
            ->orderBy('day_of_week')
            ->orderBy('start_time')
            ->get()
            ->map(fn ($schedule) => [
                'id' => $schedule->id,

                'date' => $this->getNextDate(
                    $schedule->day_of_week
                ),

                'day' => ucfirst(
                    $schedule->day_of_week
                ),

                'start_time' => Carbon::parse(
                    $schedule->start_time
                )->format('h:i A'),

                'end_time' => Carbon::parse(
                    $schedule->end_time
                )->format('h:i A'),
            ]);
    }

    private function validateNoOverlap(
        int $contractorId,
        string $day,
        string $startTime,
        string $endTime
    ): void {
        $existingSchedules = ContractorSchedule::where(
            'contractor_id',
            $contractorId
        )
            ->where('day_of_week', $day)
            ->get();

        foreach ($existingSchedules as $schedule) {

            if (
                $startTime < $schedule->end_time &&
                $endTime > $schedule->start_time
            ) {
                throw new \Exception(
                    'يوجد تعارض مع موعد آخر'
                );
            }
        }
    }

    private function getNextDate(string $day): string
    {
        return Carbon::now()
            ->next($day)
            ->format('Y-m-d');
    }

    public function index()
    {
        return $this->getSchedules(auth()->id());
    }

    public function show(int $scheduleId): array
    {
        $schedule = ContractorSchedule::where(
            'contractor_id',
            auth()->id()
        )->findOrFail($scheduleId);

        return $this->formatSchedule($schedule);
    }

    private function formatSchedule(
        ContractorSchedule $schedule
    ): array {

        return [

            'id' => $schedule->id,

            'date' => $this->getNextDate(
                $schedule->day_of_week
            ),

            'day' => ucfirst(
                $schedule->day_of_week
            ),

            'start_time' => Carbon::parse(
                $schedule->start_time
            )->format('h:i A'),

            'end_time' => Carbon::parse(
                $schedule->end_time
            )->format('h:i A'),
        ];
    }

    public function update(int $scheduleId, array $data)
    {
        // 1. جلب الموعد الخاص بالمقاول الحالي أو إرجاع 404 إذا لم يتم العثور عليه
        $schedule = ContractorSchedule::where(
            'contractor_id',
            auth()->id()
        )->findOrFail($scheduleId);

        // 2. التحقق مما إذا كان الموعد محجوزاً
        if ($schedule->is_booked) {
            throw new \Exception('لا يمكن تعديل موعد محجوز');
        }

        // 3. مصفوفة لتجميع البيانات المرسلة للتعديل فقط
        $updateData = [];

        // تحديث اليوم إذا تم إرساله
        if (isset($data['day_of_week'])) {
            $updateData['day_of_week'] = $data['day_of_week'];
        }

        // تحويل وتحديث وقت البداية إذا تم إرساله
        if (isset($data['start_time'])) {
            $updateData['start_time'] = \Carbon\Carbon::createFromFormat('h:i A', $data['start_time'])->format('H:i:s');
        }

        // تحويل وتحديث وقت النهاية إذا تم إرساله
        if (isset($data['end_time'])) {
            $updateData['end_time'] = \Carbon\Carbon::createFromFormat('h:i A', $data['end_time'])->format('H:i:s');
        }

        // 4. تنفيذ التعديل في قاعدة البيانات وفهرسة الكائن مجدداً بالبيانات الجديدة
        if (!empty($updateData)) {
            $schedule->update($updateData);
            $schedule->refresh(); // 👈 تحديث الكائن بالبيانات الجديدة من قاعدة البيانات مباشرة
        }

        // 5. إرجاع الموعد بعد التنسيق
        return $this->formatSchedule($schedule);
    }
    public function delete(
        int $scheduleId
    ): void {

        $schedule = ContractorSchedule::where(
            'contractor_id',
            auth()->id()
        )->findOrFail($scheduleId);

        if ($schedule->is_booked) {
            throw new \Exception(
                'لا يمكن حذف موعد محجوز'
            );
        }

        $schedule->delete();
    }

    public function availableSchedules($contractorId)
    {

        return ContractorSchedule::where(
            'contractor_id',
            $contractorId
        )
           // ->whereDoesntHave('siteVisit')
            ->get()
            ->map(function ($schedule) {

                return [

                    'id' => $schedule->id,

                    'date' => Carbon::now()
                        ->next($schedule->day_of_week)
                        ->format('Y-m-d'),

                    'day' => ucfirst(
                        $schedule->day_of_week
                    ),

                    'start_time' => Carbon::parse(
                        $schedule->start_time
                    )->format('h:i A'),

                    'end_time' => Carbon::parse(
                        $schedule->end_time
                    )->format('h:i A'),
                ];
            });
    }

}
