<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Http\Requests\Complaint\ResolveComplaintRequest;
use App\Models\Complaint;
use App\Models\NoShowWarning;
use App\Services\Complaint\ComplaintService;

class AdminComplaintController extends Controller
{
    public function __construct(
        protected ComplaintService $complaintService
    ) {}

    public function getAllComplaints()
    {
        // ── جلب الشكاوي العادية ───────────────────────
        $complaints = Complaint::with([
            'complainant',
            'complainedOn',
            'constructionForm',
            'images',
        ])
        ->get()
        ->map(function ($complaint) {
            $complaint->complaint_type = 'general';
            return $complaint;
        });
 
        // ── جلب تحذيرات الغياب ────────────────────────
        $noShowWarnings = NoShowWarning::with([
            'reporter',
            'reported' => function ($query) {
                $query->withCount([
                    'noShowWarnings as warnings_count'
                ]);
            },
        ])
        ->get()
        ->map(function ($warning) {
            $warning->complaint_type = 'no_show';
            return $warning;
        });
 
        // ── دمج الاثنين وترتيب من الأحدث للأقدم ──────
        $merged = $complaints
            ->concat($noShowWarnings)
            ->sortByDesc('created_at')
            ->values();
 
        return response()->json(['data' => $merged]);
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
        $complaint->load([
            'complainant.profile',
            'complainedOn.profile',
            'constructionForm.reconstructionRequest',
            'images'
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