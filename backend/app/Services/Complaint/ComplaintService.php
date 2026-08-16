<?php

namespace App\Services\Complaint;

use App\Models\Complaint;
use App\Models\ComplaintImage;
use App\Models\ConstructionForm;
use App\Models\NoShowWarning;
use App\Models\Project;
use App\Models\Role;
use App\Services\NotificationService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ComplaintService
{
    public function __construct(
        protected NotificationService $notificationService
    ) {}

    public function file(Request $request): Complaint
    {
        $complainant     = Auth::user();
        $complainantRole = $complainant->role;
        $data            = $request->validated();

        abort_if(
            !in_array($complainantRole->name, ['user', 'contractor']),
            403,
            'غير مصرح لك برفع شكوى'
        );

        $form = ConstructionForm::with('reconstructionRequest')->findOrFail($data['construction_form_id']);

        $customerId   = $form->reconstructionRequest->user_id;
        $contractorId = $form->contractor_id;

        abort_if(
            !in_array($complainant->id, [$customerId, $contractorId]),
            403,
            'لست طرفاً في هذا المشروع'
        );

        if ($complainantRole->name === 'user') {
            $complainedOnId   = $contractorId;
            $complainedOnRole = Role::where('name', 'contractor')->firstOrFail();
        } else {
            $complainedOnId   = $customerId;
            $complainedOnRole = Role::where('name', 'user')->firstOrFail();
        }
        $project = Project::where('construction_form_id', $form->id)->first();

        abort_if(
            is_null($project),
            422,
            'لا يمكن تقديم شكوى على مشروع لم يكتمل بعد'
        );

        abort_if(
            is_null($project->warranty_ends_at),
            422,
            'لم يكتمل المشروع بعد، الضمان لم يبدأ'
        );

        $now = now()->toDateString();

        abort_if(
            !($now >= $project->project_ends_at && $now <= $project->warranty_ends_at),
            422,
            'لا يمكن تقديم شكوى إلا خلال فترة الضمان بعد انتهاء المشروع'
        );
        $complaint = Complaint::create([
            'complainant_id'        => $complainant->id,
            'complained_on_id'      => $complainedOnId,
            'construction_form_id'  => $form->id,
            'complainant_role_id'   => $complainantRole->id,
            'complained_on_role_id' => $complainedOnRole->id,
            'type'                  => $data['type'] ?? 'general',
            'reason'                => $data['reason'],
            'description'           => $data['description'] ?? null,
            'status'                => 'open',
        ]);

        $this->notificationService->newComplaint(
            complaintId: $complaint->id,
            complainantName: Auth::user()->name,
        );

        $this->storeImages($request, $complaint);

        return $complaint->load('images');
    }

    // في ComplaintService.php
    public function getForUserMerged()
    {
        $complaints = Complaint::with([
            'complainedOn:id,name',
            'complainedOnRole:id,name',
            'constructionForm:id,total_cost,status',
        ])
            ->where('complainant_id', Auth::id())
            ->get()
            ->map(function ($complaint) {
                return [
                    'id'             => $complaint->id,
                    'complaint_type' => 'general',
                    'reason'         => $complaint->reason,
                    'status'         => $complaint->status,
                    'complained_on'  => $complaint->complainedOn->name,
                    'role'           => $complaint->complainedOnRole->name,
                    'created_at'     => $complaint->created_at,
                ];
            });

        $warnings = NoShowWarning::with([
            'reported:id,name',
            'reportedRole:id,name',
        ])
            ->where('reporter_id', Auth::id())
            ->get()
            ->map(function ($warning) {
                return [
                    'id'              => $warning->id,
                    'complaint_type'  => 'no_show',
                    'reason'          => $warning->reason,
                    'complained_on'        => $warning->reported->name,
                    'role'            => $warning->reportedRole->name,
                    'created_at'      => $warning->created_at,
                ];
            });

        return $complaints
            ->concat($warnings)
            ->sortByDesc('created_at')
            ->values();
    }

    // شكاوي رفعها المستخدم الحالي فقط
    public function getForUser()
    {
        return Complaint::with([
            'complainedOn',
            'constructionForm',
            'images',
            'complainantRole',
            'complainedOnRole',
        ])
            ->where('complainant_id', Auth::id())
            ->latest()
            ->get();
    }

    // تفاصيل شكوى واحدة — للمستخدم الذي رفعها فقط
    public function show(Complaint $complaint): array
    {
        abort_if(
            $complaint->complainant_id !== Auth::id(),
            403,
            'غير مصرح لك بعرض هذه الشكوى'
        );

        $complaint->load([
            'complainedOn:id,name',
            'complainedOnRole:id,name',
            'constructionForm:id,total_cost,status',
            'images:id,complaint_id,image',
        ]);

        return [
            'id'                    => $complaint->id,
            'reason'                => $complaint->reason,
            'description'           => $complaint->description,
            'type'                  => $complaint->type,
            'status'                => $complaint->status,
            'created_at'            => $complaint->created_at,
            'images'                => $complaint->images,
            'complained_on' => [
                'name' => $complaint->complainedOn->name,
                'role' => $complaint->complainedOnRole->name,
            ],
            'construction_form' => [
                'id'         => $complaint->constructionForm->id,
                'total_cost' => $complaint->constructionForm->total_cost,
                'status'     => $complaint->constructionForm->status,
            ],
        ];
    }

    private function storeImages(Request $request, Complaint $complaint): void
    {
        if (!$request->hasFile('images')) {
            return;
        }

        foreach ($request->file('images') as $image) {
            $path = $image->store('complaints', 'public');
            ComplaintImage::create([
                'complaint_id' => $complaint->id,
                'image'        => $path,
            ]);
        }
    }
}
