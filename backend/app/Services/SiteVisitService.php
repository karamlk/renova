<?php

namespace App\Services;

use App\Models\SiteVisit;

class SiteVisitService
{
    public function contractorVisits()
    {
        return SiteVisit::with([
            'inspectionRequest.request',
            'schedule'
        ])
            ->whereHas(
                'inspectionRequest',
                function ($query) {

                    $query->where(
                        'contractor_id',
                        auth()->id()
                    );
                }
            )
            ->get();
    }

    public function userVisits()
    {
        return SiteVisit::with([
            'inspectionRequest.contractor',
            'schedule'
        ])
            ->whereHas(
                'inspectionRequest.request',
                function ($query) {

                    $query->where(
                        'user_id',
                        auth()->id()
                    );
                }
            )
            ->get();
    }
}
