<?php

namespace App\Http\Controllers;

use App\Models\ReconstructionRequest;

class RequsesteController
{
    public function index()
    {
        $requests = ReconstructionRequest::with([
            'user',
            'images'
        ])
            ->latest()
            ->get();

        return response()->json([
            'data' => $requests
        ]);
    }
}
