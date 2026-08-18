<?php

namespace App\Http\Controllers;

use App\Models\Project;
use App\Services\ProjectService;
use Illuminate\Http\Request;

class ProjectController extends Controller
{
    //
    public function waitingRelease()
    {
        return response()->json(

            app(ProjectService::class)
                ->waitingRelease()

        );
    }
    public function finishedPayments()
    {
        return response()->json(

            app(ProjectService::class)
                ->finishedPayments()

        );
    }

    public function myProjects()
    {
        return Project::where('contractor_id', auth()->id())
            ->with(['form', 'user', 'engineer'])
            ->get()
            ->map(function ($project) {
                return [
                    'id' => $project->id,
                    'status' => $project->status,
                    'progress' => $project->progress,
                    'construction_form_id' => $project->construction_form_id,

                    'user' => $project->user ? [
                        'id' => $project->user->id,
                        'name' => $project->user->name,
                    ] : null,

                    'engineer' => $project->engineer ? [
                        'id' => $project->engineer->id,
                        'name' => $project->engineer->name,
                    ] : null,

                    'total_cost' => $project->form->total_cost,
                ];
            });
    }
    public function show(Project $project)
    {
        $project->load([
            'form.materials',
            'contractor',
            'engineer',
            'user',
        ]);

        return response()->json([
            'message' => 'تفاصيل المشروع',
            'project' => $project,
        ]);
    }

    public function userProjects()
    {
        return response()->json(
            app(ProjectService::class)
                ->userProjects()
        );
    }

    public function userProject($id)
    {
        return response()->json(
            app(ProjectService::class)
                ->userProject($id)
        );
    }


    public function index()
    {
        // جلب جميع المشاريع مع كافة علاقاتها
        $projects = Project::with([
            'form.reconstructionRequest',
            'tasks',
            'review',
            'user',
            'engineer',
            'contractor',
        ])->get();

        return response()->json([
            'message' => 'تم جلب جميع المشاريع بنجاح',
            'data'    => $projects
        ], 200);
    }

    public function show_project($id)
    {
        // البحث عن المشروع وجلب كافة علاقاته أو إرجاع خطأ 404 إذا لم يوجد
        $project = Project::with([
            'form.reconstructionRequest',
            'tasks',
            'review',
            'user',
            'engineer',
            'contractor',
        ])->findOrFail($id);

        return response()->json([
            'message' => 'تم جلب تفاصيل المشروع بنجاح',
            'data'    => $project
        ], 200);
    }
}
