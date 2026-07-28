<?php

namespace App\Services\Engineer;

use App\Models\ConstructionForm;
use App\Models\Project;
use App\Models\SiteVisit;

class EngineerDashboardService
{
    public function index()
    {
        $engineerId = auth()->id();

        return [

            'pending_visits'=>

                SiteVisit::where(

                    'engineer_id',

                    $engineerId

                )

                    ->where(

                        'status',

                        'pending'

                    )

                    ->count(),

            'pending_forms'=>

                ConstructionForm::where(

                    'engineer_id',

                    $engineerId

                )

                    ->where(

                        'status',

                        'pending_engineer'

                    )

                    ->count(),

            'active_projects'=>

                Project::where(

                    'engineer_id',

                    $engineerId

                )

                    ->where(

                        'status',

                        'active'

                    )

                    ->count(),

            'completed_projects'=>

                Project::where(

                    'engineer_id',

                    $engineerId

                )

                    ->where(

                        'status',

                        'completed'

                    )

                    ->count(),

        ];

    }
}
