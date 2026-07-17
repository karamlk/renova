<?php

namespace App\Http\Controllers\Admin\Complaint;

use App\Http\Controllers\Controller;
use App\Models\NoShowWarning;
use App\Services\Admin\Complaint\NoShowWarningService;

class NoShowWarningController extends Controller
{
    public function __construct(
        protected NoShowWarningService $noShowWarningService,
    ) {}
    // GET /api/admin/no-show-warnings
    // كل تحذيرات الغياب في النظام

    public function archive(NoShowWarning $noShowWarning)
    {
        return response()->json([
            'message' => 'No-show warning archived successfully.',
            'data' => $this->noShowWarningService->archiveNoShowWarning($noShowWarning),
        ]);
    }

    public function index()
    {
        return response()->json([
            'data' => $this->noShowWarningService->getAllNoShowWarnings(),
        ]);
    }

    public function show(NoShowWarning $noShowWarning)
    {
        return response()->json([
            'data' => $this->noShowWarningService->getNoShowWarningDetails($noShowWarning),
        ]);
    }
}
