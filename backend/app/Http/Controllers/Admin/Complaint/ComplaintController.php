<?php

namespace App\Http\Controllers\Admin\Complaint;

use App\Http\Controllers\Controller;
use App\Http\Requests\Complaint\ComplaintFilterRequest;
use App\Http\Requests\Complaint\ResolveComplaintRequest;
use App\Models\Complaint;
use App\Services\Admin\Complaint\ComplaintService;


class ComplaintController extends Controller
{
    public function __construct(
        protected ComplaintService $complaintService
    ) {}

    public function getAllComplaints(ComplaintFilterRequest $request)
    {
        return response()->json([
            'data' => $this->complaintService
                ->getAllComplaints($request->validated()),
        ]);
    }

    public function getArchivedComplaints(ComplaintFilterRequest $request)
    {
        return response()->json([
            'data' => $this->complaintService
                ->getArchivedComplaints($request->validated()),
        ]);
    }

    public function archive(Complaint $complaint)
    {
        return response()->json([
            'message' => 'تمت ارشفة الشكوى بنجاح',
            'data' => $this->complaintService->archiveComplaint($complaint),
        ]);
    }

    // GET /api/admin/complaints
    public function index()
    {
        return response()->json([
            'data' => $this->complaintService->getForAdmin()
        ]);
    }

    // GET /api/admin/complaints/{complaint}
    public function show(Complaint $complaint)
    {
        return response()->json([
            'data' => $this->complaintService->getComplaintDetails($complaint)
        ]);
    }

    // PATCH /api/admin/complaints/{complaint}/resolve
    public function resolve(ResolveComplaintRequest $request, Complaint $complaint)
    {
        abort_if(
            in_array($complaint->status, ['resolved', 'dismissed']),
            422,
            ' تمت معالجةهذه الشكوى مسبقاً'
        );

        $complaint = $this->complaintService->resolve($complaint, $request->validated());

        return response()->json([
            'message' => 'تمت معالجة الشكوى بنجاح',
            'data'    => $complaint
        ]);
    }
}
