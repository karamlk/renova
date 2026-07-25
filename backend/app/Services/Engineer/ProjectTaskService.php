<?php

namespace App\Services\Engineer;

use App\Models\Project;
use App\Models\ProjectTask;
use App\Services\PaymentMilestoneService;
use Exception;

class ProjectTaskService
{
    public function createTask(
        array $data
    ): ProjectTask
    {
        $project = Project::findOrFail(
            $data['project_id']
        );

        if (
            $project->engineer_id != auth()->id()
        ) {
            throw new Exception(
                'لا يمكنك إدارة مشروع لا يخصك'
            );
        }

        if (
            $project->status != 'active'
        ) {
            throw new Exception(
                'لا يمكن إضافة مهام لمشروع غير نشط'
            );
        }

        $currentPercentage =
            $project->tasks()
                ->sum('percentage');

        if ($currentPercentage >= 100) {

            throw new Exception(
                'تم تقسيم المشروع بالكامل'
            );
        }

        if (
            $currentPercentage +
            $data['percentage']
            > 100
        ) {
            throw new Exception(
                'مجموع نسب المهام تجاوز 100%'
            );
        }

        return ProjectTask::create([

            'project_id' =>
                $data['project_id'],

            'title' =>
                $data['title'],

            'description' =>
                $data['description'] ?? null,

            'percentage' =>
                $data['percentage']
        ]);
    }

    public function completeTask(
        ProjectTask $task
    ): ProjectTask
    {
        if ($task->is_completed) {

            throw new Exception(
                'المهمة منجزة مسبقاً'
            );
        }

        if (
            $task->project->engineer_id
            != auth()->id()
        ) {
            throw new Exception(
                'لا يمكنك تعديل هذه المهمة'
            );
        }

        $task->update([
            'is_completed' => true
        ]);

        $this->updateProjectProgress(
            $task->project
        );
        $project =
            $task
                //->constructionForm
                ->project;

        app(PaymentMilestoneService::class)
            ->checkMilestones(
                $project
            );

        return $task->fresh();
    }

    public function updateTask(
        ProjectTask $task,
        array $data
    ): ProjectTask
    {
        if (
            $task->project->engineer_id
            != auth()->id()
        ) {
            throw new Exception(
                'لا يمكنك تعديل هذه المهمة'
            );
        }

        $task->update($data);

        $this->updateProjectProgress(
            $task->project
        );

        return $task->fresh();
    }

    public function deleteTask(
        ProjectTask $task
    ): void
    {
        if (
            $task->project->engineer_id
            != auth()->id()
        ) {
            throw new Exception(
                'لا يمكنك حذف هذه المهمة'
            );
        }

        $project = $task->project;

        $task->delete();

        $this->updateProjectProgress(
            $project
        );
    }

    public function getProjectTasks(
        Project $project
    ): array
    {
        $this->updateProjectProgress(
            $project
        );

        return [

            'project_id' =>
                $project->id,

            'progress' =>
                $project->progress,

            'tasks' =>
                $project->tasks
        ];
    }

    private function updateProjectProgress(
        Project $project
    ): void
    {
        $progress =
            $project->tasks()
                ->where(
                    'is_completed',
                    true
                )
                ->sum('percentage');

        $project->update([
            'progress' => $progress
        ]);

        if ($progress >= 100) {

            $project->update([
                'status' => 'completed'
            ]);
        }
    }
}
