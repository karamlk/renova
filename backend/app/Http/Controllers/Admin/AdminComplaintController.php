<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Complaint\ResolveComplaintRequest;
use App\Models\Complaint;
use App\Services\Complaint\ComplaintService;

class AdminComplaintController extends Controller
{
    public function __construct(
        protected ComplaintService $complaintService
    ) {}

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
        $complaint->load([
            'complainant.profile',
            'complainedOn.profile',
            'constructionForm.reconstructionRequest',
        ]);

        return response()->json(['data' => $complaint]);
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