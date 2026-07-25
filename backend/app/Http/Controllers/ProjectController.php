<?php

namespace App\Http\Controllers;

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
}
