<?php

namespace App\Services\Engineer;

use App\Models\Project;
use App\Models\ProjectTask;
use App\Services\PaymentMilestoneService;
use Carbon\Carbon;
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

        /*
         * تحديث نسبة إنجاز المشروع
         */
        $this->updateProjectProgress(
            $task->project
        );

        /*
         * جلب المشروع مع النسبة الجديدة
         */
        $project = $task->project->fresh();

        /*
         * فحص الدفعات
         */
        app(PaymentMilestoneService::class)
            ->checkMilestones($project);

        /*
         * =====================================================
         * إشعار المستخدم حسب نسبة الإنجاز
         * =====================================================
         */

        $user = $project->user;

        if ($user) {

            /*
             * =================================================
             * المشروع وصل 100%
             * =================================================
             */

            if ($project->progress >= 100) {

                event(new \App\Events\AppEvent(
                    $user->id,
                    'اكتمل المشروع',
                    'اكتمل المشروع بنسبة 100%، يرجى دفع الدفعة الأخيرة.',
                    'payment',
                    'projects',
                    $project->id
                ));

                if ($user->fcm_token) {

                    app(
                        \App\Services\FirebaseNotificationService::class
                    )->send(
                        $user->fcm_token,
                        'اكتمل المشروع',
                        'اكتمل المشروع بنسبة 100%، يرجى دفع الدفعة الأخيرة.',
                        [
                            'type' => 'payment',
                            'target_path' => 'projects',
                            'related_id' =>
                                (string) $project->id,
                        ]
                    );
                }

                /*
                 * =================================================
                 * المشروع وصل 50% أو أكثر
                 * =================================================
                 */

            } elseif ($project->progress >= 50) {

                event(new \App\Events\AppEvent(
                    $user->id,
                    'وصل المشروع إلى 50%',
                    'وصل إنجاز المشروع إلى 50% أو أكثر، يرجى دفع الدفعة الثانية.',
                    'payment',
                    'projects',
                    $project->id
                ));

                if ($user->fcm_token) {

                    app(
                        \App\Services\FirebaseNotificationService::class
                    )->send(
                        $user->fcm_token,
                        'وصل المشروع إلى 50%',
                        'وصل إنجاز المشروع إلى 50% أو أكثر، يرجى دفع الدفعة الثانية.',
                        [
                            'type' => 'payment',
                            'target_path' => 'projects',
                            'related_id' =>
                                (string) $project->id,
                        ]
                    );
                }
            }
        }

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
             $projectEndsAt  = now()->toDateString();
            $warrantyEndsAt = $this->parseWarrantyPeriod(
                $project->constructionForm->warranty_period,
                    Carbon::parse($projectEndsAt)
                    )->toDateString();

            $project->update([
                'status' => 'completed',
                'project_ends_at' => $projectEndsAt,
                'warranty_ends_at'=> $warrantyEndsAt,
            ]);
        }
    }

    private function parseWarrantyPeriod(string $period, Carbon $from): Carbon
    {
        // English
        if (preg_match('/(\d+)\s*month/i', $period, $matches))
            return $from->copy()->addMonths((int) $matches[1]);

        if (preg_match('/(\d+)\s*year/i', $period, $matches))
            return $from->copy()->addYears((int) $matches[1]);

        if (preg_match('/(\d+)\s*week/i', $period, $matches))
            return $from->copy()->addWeeks((int) $matches[1]);

        // Arabic months
        if (preg_match('/(\d+)\s*(اشهر|أشهر|شهر|شهور)/u', $period, $matches))
            return $from->copy()->addMonths((int) $matches[1]);

        // Arabic years
        if (preg_match('/(\d+)\s*(سنوات|عام|أعوام)/u', $period, $matches))
            return $from->copy()->addYears((int) $matches[1]);

        // Arabic weeks
        if (preg_match('/(\d+)\s*(اسبوع|أسبوع|اسابيع|أسابيع)/u', $period, $matches))
            return $from->copy()->addWeeks((int) $matches[1]);

        // Arabic special cases without number
        if (preg_match('/أسبوعين|اسبوعين/u', $period))
            return $from->copy()->addWeeks(2);

        if (preg_match('/سنتين/u', $period))
            return $from->copy()->addYears(2);

        if (preg_match('/سنة/u', $period))
            return $from->copy()->addYear();

        // Nothing matched — tell the contractor to fix their input
        throw new \Exception(
            'صيغة فترة الضمان غير مدعومة، يرجى كتابتها بشكل واضح مثل: 3 اشهر، 6 months، 1 سنة'
        );
    }
}
