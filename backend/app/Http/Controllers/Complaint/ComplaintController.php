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

    // GET /api/complaints/reasons
    public function reasons()
    {
        return response()->json([
            'data' => $this->complaintService->getReasons()
        ]);
    }

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
        $complaint = $this->complaintService->file($request->validated());

        return response()->json([
            'message' => 'تم تقديم الشكوى بنجاح',
            'data'    => $complaint
        ], 201);
    }

    // POST /api/no-show-warnings
    // الفرونت يرسل site_visit_id فقط — الباقي يحسبه الباك أوتوماتيك
    public function reportNoShow(ReportNoShowRequest $request)
    {
        $warning = $this->noShowWarningService->report(
            $request->site_visit_id
        );

        $message = $warning->penalty_applied
            ? 'تم تسجيل التحذير الثاني وتطبيق الغرامة تلقائياً'
            : 'تم تسجيل التحذير بنجاح';

        return response()->json([
            'message' => $message,
            'data'    => $warning
        ], 201);
    }
}