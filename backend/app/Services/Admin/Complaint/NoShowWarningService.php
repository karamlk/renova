<?php

namespace App\Services\Admin\Complaint;

use App\Http\Resources\Complaint\NoShowWarningDetailsResource;
use App\Http\Resources\Complaint\NoShowWarningResource;
use App\Models\NoShowWarning;

class NoShowWarningService
{

    public function getAllNoShowWarnings()
    {
        $warnings = NoShowWarning::with([
            'reporter',
            'reported' => function ($query) {
                $query->withCount('noShowWarnings as complaints_count');
            },
            'siteVisit.inspectionRequest.request',
        ])
            ->latest()
            ->get();

        return NoShowWarningResource::collection($warnings);
    }

    public function getNoShowWarningDetails(NoShowWarning $noShowWarning): NoShowWarningDetailsResource
    {
        $noShowWarning->load([
            'reporter',
            'reported' => function ($query) {
                $query->withCount('noShowWarnings as complaints_count');
            },
            'siteVisit.inspectionRequest.request.user',
            'siteVisit.inspectionRequest.contractor',
        ]);

        $noShowWarning->reporter?->load(['profile', 'contractorProfile', 'engineerProfile']);
        $noShowWarning->reported?->load(['profile', 'contractorProfile', 'engineerProfile']);

        return new NoShowWarningDetailsResource ($noShowWarning);
    }


    public function archiveNoShowWarning(NoShowWarning $warning): NoShowWarningDetailsResource
    {
        $warning->update([
            'is_archived' => true,
            'archived_at' => now(),
        ]);

        $warning->load([
            'reporter',
            'reported' => function ($query) {
                $query->withCount('noShowWarnings as complaints_count');
            },
            'siteVisit.inspectionRequest.request.user',
            'siteVisit.inspectionRequest.contractor',
        ]);

        return new NoShowWarningDetailsResource($warning);
    }
}
