<?php

namespace App\Services\Admin;

use App\Models\User;
use App\Models\Project;
use App\Models\WalletTransaction;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class AnalyticsService
{
    public function getAnalyticsSnapshot(): array
    {
        $currentYear = Carbon::now()->year;

        $totalProjects = Project::count();
        $completedProjects = Project::where('status', 'completed')->count();

        // $totalUsers = User::count();
        $totalUsers= User::where('is_active', true)->count();

        // Profit Calculation
        $adminUser = User::whereHas('role', function ($q) {
            $q->where('name', 'admin');
        })->first();

        $adminWalletId = $adminUser ? $adminUser->wallet->id : null;

        $totalProfit = WalletTransaction::where('type', 'deposit')
            ->where('wallet_id', $adminWalletId)
            ->sum('amount') * 0.02;

        //  Project Distribution Percentage Based on Form Types
        $typeDistribution = DB::table('projects')
            ->join('construction_forms', 'projects.construction_form_id', '=', 'construction_forms.id')
            ->join('reconstruction_requests', 'construction_forms.reconstruction_request_id', '=', 'reconstruction_requests.id')
            ->select('reconstruction_requests.type', DB::raw('count(*) as total'))
            ->groupBy('reconstruction_requests.type')
            ->get();

        $formattedPercentages = [
            'restoration'  => 0,
            'construction' => 0,
            'finishing'    => 0,
        ];

        if ($totalProjects > 0) {
            foreach ($typeDistribution as $item) {
                if (array_key_exists($item->type, $formattedPercentages)) {
                    $formattedPercentages[$item->type] = round(($item->total / $totalProjects) * 100, 2);
                }
            }
        }

        //  Completed Projects per Month
        $monthlyCompletedRaw = Project::where('status', 'completed')
            ->whereYear('updated_at', $currentYear)
            ->select(DB::raw('MONTH(updated_at) as month'), DB::raw('count(*) as total'))
            ->groupBy(DB::raw('MONTH(updated_at)'))
            ->pluck('total', 'month')
            ->all();

        $monthlyCompletedChartData = [];
        for ($month = 1; $month <= 12; $month++) {
            $monthlyCompletedChartData[] = [
                'month_name' => Carbon::create()->month($month)->locale('ar')->monthName,
                'count'      => $monthlyCompletedRaw[$month] ?? 0
            ];
        }

        // Latest 6 Projects
        $latestProjectsRaw = Project::with([
            'user:id,name',
            'form.reconstructionRequest:id,type,title,location'
        ])
            ->latest()
            ->take(6)
            ->get();

        $latestProjects = $latestProjectsRaw->map(function ($project) {
            return [
                'id'               => $project->id,
                'title'             => $project->form->reconstructionRequest->title,
                'user_name'        => $project->user->name ?? null,
                'location'         => $project->form->reconstructionRequest->location,
                'type'             => $project->form->reconstructionRequest->type,
                'status'           => $project->status,
                'created_at'       => $project->created_at ? $project->created_at->format('Y-m-d') : null,
                'progress'         => $project->progress,
            ];
        });

        
        return [
            'counters' => [
                'total_users'        => $totalUsers,
                'total_projects'     => $totalProjects,
                'completed_projects' => $completedProjects,
                'total_profit'       => $totalProfit,
            ],
            'project_type_percentages' => $formattedPercentages,
            'monthly_completions'      => $monthlyCompletedChartData,
            'latest_projects'          => $latestProjects
        ];
    }
}
