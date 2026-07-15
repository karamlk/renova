<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\NoShowWarning;

class AdminNoShowWarningController extends Controller
{
    // GET /api/admin/no-show-warnings
    // كل تحذيرات الغياب في النظام
    public function index()
    {
        $warnings = NoShowWarning::with([
            'reporter',
            'reported' => function ($query) {
                $query->withCount([
                    'noShowWarnings as warnings_count'
                ]);
            },
            'siteVisit.inspectionRequest.request',
        ])
            ->latest()
            ->get();

        return response()->json([
            'data' => $warnings
        ]);
    }

    // GET /api/admin/no-show-warnings/{noShowWarning}
    // تفاصيل تحذير واحد
    public function show(NoShowWarning $noShowWarning)
    {
        $noShowWarning->load([
            'reporter',
            'reported' => function ($query) {
                $query->withCount([
                    'noShowWarnings as warnings_count'
                ]);
            },
            'siteVisit.inspectionRequest.request.user',
            'siteVisit.inspectionRequest.contractor',
        ]);

        return response()->json([
            'data' => $noShowWarning
        ]);
    }
}
