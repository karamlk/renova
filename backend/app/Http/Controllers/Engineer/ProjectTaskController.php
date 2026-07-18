<?php

namespace App\Http\Controllers\Engineer;

use App\Http\Controllers\Controller;
use App\Http\Requests\CreateTaskRequest;
use App\Http\Requests\UpdateTaskRequest;
use App\Models\ConstructionForm;
use App\Models\Project;
use App\Models\ProjectTask;
use App\Services\Engineer\ProjectTaskService;
use Illuminate\Http\Request;

class ProjectTaskController extends Controller
{
    protected $taskService;

    public function __construct(
        ProjectTaskService $taskService
    ) {
        $this->taskService =
            $taskService;
    }

    public function store(
        CreateTaskRequest $request
    )
    {
        $task =
            $this->taskService
                ->createTask(
                    $request->validated()
                );

        return response()->json([
            'message' => 'تم إنشاء المهمة',
            'data' => $task
        ]);
    }
    public function complete(
        ProjectTask $task
    )
    {
        $task =
            $this->taskService
                ->completeTask($task);

        return response()->json([
            'message' =>
                'تم إنجاز المهمة',
            'data' => $task
        ]);
    }
    public function update(
        UpdateTaskRequest $request,
        ProjectTask $task
    )
    {
        $task =
            $this->taskService
                ->updateTask(
                    $task,
                    $request->validated()
                );

        return response()->json([
            'message' =>
                'تم تعديل المهمة',
            'data' => $task
        ]);
    }
    public function destroy(
        ProjectTask $task
    )
    {
        $this->taskService
            ->deleteTask($task);

        return response()->json([
            'message' =>
                'تم حذف المهمة'
        ]);
    }
    public function index(
        Project $project
    )
    {
        return response()->json(

            $this->taskService
                ->getProjectTasks($project)

        );
    }
    public function show(
        ProjectTask $task
    )
    {
        return response()->json([
            'data' => $task->load(
                'project'
            )
        ]);
    }
}
