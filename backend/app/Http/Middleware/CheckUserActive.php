<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class CheckUserActive
{
    public function handle(
        Request $request,
        Closure $next
    )
    {

        if (
            auth()->check() &&
            ! auth()->user()->is_active
        ) {

            auth()->user()
                ->tokens()
                ->delete();

            return response()->json([
                'message' => 'تم تعطيل الحساب من قبل الإدارة'
            ], 403);
        }

        return $next($request);
    }
}
