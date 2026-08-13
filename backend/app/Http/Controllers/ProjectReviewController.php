<?php

namespace App\Http\Controllers;

use App\Models\Project;
use App\Models\ProjectReview;
use Illuminate\Http\Request;

class ProjectReviewController extends Controller
{
    public function store(
        Request $request,
        Project $project
    ) {
        $request->validate([
            'rating' => [
                'required',
                'integer',
                'min:1',
                'max:5'
            ],
        ]);

        // المشروع لازم يكون مكتمل
        if ($project->progress < 100) {
            return response()->json([
                'message' =>
                    'لا يمكنك تقييم المشروع قبل اكتماله'
            ], 422);
        }

        // المشروع لازم يكون للمستخدم الحالي
        if ($project->user_id != auth()->id()) {
            return response()->json([
                'message' =>
                    'لا يمكنك تقييم هذا المشروع'
            ], 403);
        }

        // منع التقييم أكثر من مرة
        if (
            ProjectReview::where(
                'project_id',
                $project->id
            )
                ->where(
                    'user_id',
                    auth()->id()
                )
                ->exists()
        ) {
            return response()->json([
                'message' =>
                    'لقد قمت بتقييم هذا المشروع مسبقاً'
            ], 422);
        }

        $review = ProjectReview::create([

            'project_id'
            => $project->id,

            'user_id'
            => auth()->id(),

            'contractor_id'
            => $project->contractor_id,

            'rating'
            => $request->rating,

        ]);

        return response()->json([
            'message' =>
                'تم تقييم المشروع بنجاح',

            'rating'
            => $review->rating,

        ], 201);
    }
}
