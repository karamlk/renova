<?php

namespace App\Services\Engineer;

use App\Models\SiteVisit;
use Illuminate\Support\Carbon;

class EngineerVisitService
{
    public function index(
        ?string $status = null
    )
    {
        $query = SiteVisit::with([

            'inspectionRequest.request.user',

            'inspectionRequest.contractor',

            'schedule'

        ])

            ->where(

                'engineer_id',

                auth()->id()

            );

        if ($status) {

            $query->where(
                'status',
                $status
            );

        }

        return $query

            ->latest()

            ->get()

            ->map(function ($visit) {

                return [

                    'id' => $visit->id,

                    'status' => $this->translateStatus(
                        $visit->status
                    ),

                    'user' => $visit
                        ->inspectionRequest
                        ->request
                        ->user
                        ->name,

                    'title' => $visit
                        ->inspectionRequest
                        ->request
                        ->title,

                    'location' => $visit
                        ->inspectionRequest
                        ->request
                        ->location,

                    'contractor' => $visit
                        ->inspectionRequest
                        ->contractor
                        ->name,

                    'day' => $this->translateDay(
                        $visit->schedule->day_of_week
                    ),

                    'start_time' => substr(
                        $visit->schedule->start_time,
                        0,
                        5
                    ),

                    'end_time' => substr(
                        $visit->schedule->end_time,
                        0,
                        5
                    )

                ];

            });

    }

    private function translateStatus(
        string $status
    )
    {
        return match ($status) {

            'pending' => 'بانتظار الموافقة',

            'approved' => 'مقبولة',

            'rejected' => 'مرفوضة',

            default => $status

        };
    }

    private function translateDay(
        string $day
    )
    {
        return match ($day) {

            'saturday' => 'السبت',

            'sunday' => 'الأحد',

            'monday' => 'الاثنين',

            'tuesday' => 'الثلاثاء',

            'wednesday' => 'الأربعاء',

            'thursday' => 'الخميس',

            'friday' => 'الجمعة',

            default => $day

        };
    }
    public function show(
        SiteVisit $visit
    )
    {
        if (

            $visit->engineer_id

            != auth()->id()

        ){

            abort(403);

        }

        $visit->load([

            'inspectionRequest.request.user',

            'inspectionRequest.request.images',

            'inspectionRequest.contractor',

            'schedule'

        ]);

        return [

            'id'=>$visit->id,

            'status'=>

                $this->translateStatus(

                    $visit->status

                ),

            'user'=>[

                'id'=>

                    $visit
                        ->inspectionRequest
                        ->request
                        ->user
                        ->id,

                'name'=>

                    $visit
                        ->inspectionRequest
                        ->request
                        ->user
                        ->name,

                'phone' => optional(
                    $visit
                        ->inspectionRequest
                        ->request
                        ->user
                        ->profile
                )->phone
            ],

            'request'=>[

                'title'=>

                    $visit
                        ->inspectionRequest
                        ->request
                        ->title,

                'description'=>

                    $visit
                        ->inspectionRequest
                        ->request
                        ->description,

                'location'=>

                    $visit
                        ->inspectionRequest
                        ->request
                        ->location,

                'type'=>

                    $visit
                        ->inspectionRequest
                        ->request
                        ->type

            ],

            'contractor'=>[

                'id'=>

                    $visit
                        ->inspectionRequest
                        ->contractor
                        ->id,

                'name'=>

                    $visit
                        ->inspectionRequest
                        ->contractor
                        ->name

            ],

            'visit'=>[

                'day'=>

                    $this->translateDay(

                        $visit
                            ->schedule
                            ->day_of_week

                    ),

                'start_time'=>

                    substr(

                        $visit
                            ->schedule
                            ->start_time,

                        0,

                        5

                    ),

                'end_time'=>

                    substr(

                        $visit
                            ->schedule
                            ->end_time,

                        0,

                        5

                    )

            ],

            'images'=>

                $visit
                    ->inspectionRequest
                    ->request
                    ->images
                   // ->pluck('getfullImageUrlAttribute')
                   ->values()

        ];


    }
    private function getVisitDate(string $dayOfWeek): string
    {
        return Carbon::now()
            ->nextOrSame($dayOfWeek)
            ->format('Y-m-d');
    }
}
