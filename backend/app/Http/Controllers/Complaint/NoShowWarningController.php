<?php

namespace App\Http\Controllers\Complaint;

use App\Http\Controllers\Controller;
use App\Http\Requests\Complaint\ReportNoShowRequest;
use App\Models\NoShowWarning;
use App\Models\User;
use App\Services\Complaint\NoShowWarningService;

class NoShowWarningController extends Controller
{
    public function __construct(
        protected NoShowWarningService $noShowWarningService
    ) {}

    // GET /api/no-show-warnings
    // تحذيرات أبلغ عنها المستخدم الحالي فقط
    public function index()
    {
        return response()->json([
            'data' => $this->noShowWarningService->getForUser()
        ]);
    }

    // GET /api/no-show-warnings/{noShowWarning}
    public function show(NoShowWarning $noShowWarning)
    {
        return response()->json([
            'data' => $this->noShowWarningService->show($noShowWarning)
        ]);
    }

    // POST /api/no-show-warnings
    // الفرونت يرسل: site_visit_id + reported_role
    public function store(ReportNoShowRequest $request)
    {
        $warning = $this->noShowWarningService->report(
            $request->site_visit_id,
            $request->reported_role,
        );

        $reported        = User::find($warning->reported_id);
        $accountDisabled = !$reported->is_active;

        $message = $accountDisabled
            ? 'تم تسجيل التحذير وتعطيل حساب المستخدم بسبب تجاوز الحد المسموح'
            : 'تم تسجيل التحذير بنجاح';

        return response()->json([
            'message'          => $message,
            'account_disabled' => $accountDisabled,
            'data'             => $warning->load(['reporterRole', 'reportedRole']),
        ], 201);
    }
}