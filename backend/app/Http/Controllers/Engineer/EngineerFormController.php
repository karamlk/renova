<?php

namespace App\Http\Controllers\Engineer;

use App\Http\Controllers\Controller;
//use App\Models\ConstructionForm;
use App\Models\ConstructionForm;
use App\Services\Engineer\EngineerFormService;
use Illuminate\Http\Request;

class EngineerFormController extends Controller
{
    public function index(
        Request $request,
        EngineerFormService $service
    )
    {
        return response()->json([

            'data'=>

                $service->index(
                    $request->status
                )

        ]);
    }
    public function show(
        ConstructionForm $form,
        EngineerFormService $service
    )
    {
        return response()->json([

            'data'=>

                $service->show($form)

        ]);
    }
}
