<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});
use Illuminate\Support\Facades\Http;

Route::get('/test-shamcash', function () {

    $response = Http::withToken(env('SHAMCASH_API_TOKEN'))
        ->get(env('SHAMCASH_API_BASE') . '/transactions', [
            'account_id' => 'PUT_ACCOUNT_ID_HERE',
            'limit' => 5
        ]);

    return $response->json();
});
