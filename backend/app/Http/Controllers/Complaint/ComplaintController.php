<?php

namespace App\Http\Controllers\Complaint;

use App\Http\Controllers\Controller;
use App\Http\Requests\Complaint\FileComplaintRequest;
use App\Http\Requests\Complaint\ReportNoShowRequest;
use App\Services\Complaint\ComplaintService;
use App\Services\Complaint\NoShowWarningService;

class ComplaintController extends Controller
{
    public function __construct(
        protected ComplaintService     $complaintService,
        protected NoShowWarningService $noShowWarningService,
    ) {}

    // GET /api/complaints
    public function index()
    {
        return response()->json([
            'data' => $this->complaintService->getForUser()
        ]);
    }

    // POST /api/complaints
    public function store(FileComplaintRequest $request)
    {
        $complaint = $this->complaintService->file(
            $request
        );

        return response()->json([
            'message' => 'تم تقديم الشكوى بنجاح',
            'data'    => $complaint->load([
                'complainant',
                'complainedOn',
                'complainantRole',
                'complainedOnRole',
                'constructionForm',
                'images'
            ])
        ], 201);
    }

    // POST /api/no-show-warnings
    // الفرونت يرسل: site_visit_id, reported_id
    // الباك يحدد تلقائياً: reporter_role_id, reported_role_id, reason, description, type
    public function reportNoShow(ReportNoShowRequest $request)
    {
        $warning = $this->noShowWarningService->report(
            $request->site_visit_id,
            $request->reported_id,
        );

        // التحقق إذا تم تعطيل الحساب بعد هذا التحذير
        $reported        = \App\Models\User::find($request->reported_id);
        $accountDisabled = !$reported->is_active;

        $message = $accountDisabled
            ? 'تم تسجيل التحذير وتعطيل حساب المستخدم بسبب تجاوز الحد المسموح'
            : 'تم تسجيل التحذير بنجاح';

        return response()->json([
            'message'          => $message,
            'account_disabled' => $accountDisabled,
            'data'             => $warning->load(['reporterRole', 'reportedRole','images']),
        ], 201);
    }
}
