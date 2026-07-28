<?php

namespace App\Http\Controllers\Engineer;

use App\Http\Controllers\Controller;
use App\Models\Project;
use App\Services\Engineer\EngineerProjectService;

class EngineerProjectController extends Controller
{
    public function index(
        EngineerProjectService $service
    )
    {
        return response()->json([

            'data'=>

                $service->index()

        ]);
    }
    public function show(
        Project $project,
        EngineerProjectService $service
    )
    {
        return response()->json([

            'data'=>

                $service->show(

                    $project

                )

        ]);
    }
}
