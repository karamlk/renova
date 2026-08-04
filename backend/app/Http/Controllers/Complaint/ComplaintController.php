<?php

namespace App\Http\Controllers\Complaint;

use App\Http\Controllers\Controller;
use App\Http\Requests\Complaint\FileComplaintRequest;
use App\Models\Complaint;
use App\Services\Complaint\ComplaintService;

class ComplaintController extends Controller
{
    public function __construct(
        protected ComplaintService $complaintService
    ) {}

    // GET /api/my-complaints
    public function myComplaints()
    {
        return response()->json([
            'data' => $this->complaintService->getForUserMerged()
        ]);
    }

    // GET /api/complaints
    // شكاوي رفعها المستخدم الحالي فقط
    public function index()
    {
        return response()->json([
            'data' => $this->complaintService->getForUser()
        ]);
    }

    // GET /api/complaints/{complaint}
    public function show(Complaint $complaint)
    {
        return response()->json([
            'data' => $this->complaintService->show($complaint)
        ]);
    }

    // POST /api/complaints
    public function store(FileComplaintRequest $request)
    {
        $complaint = $this->complaintService->file($request);

        return response()->json([
            'message' => 'تم تقديم الشكوى بنجاح',
            'data'    => [
                'id'          => $complaint->id,
                'reason'      => $complaint->reason,
                'status'      => $complaint->status,
                'created_at'  => $complaint->created_at,
                'images'      => $complaint->images,
            ]
        ], 201);
    }
}
