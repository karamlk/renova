<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;

class RoleMiddleware
{
    public function handle(Request $request, Closure $next, string ...$roles): mixed
    {
        $user = $request->user();

        // Role not in allowed list
        if (!in_array($user->role->name, $roles)) {
            return response()->json([
                'message' => 'غير مصرح لك بالوصول'
            ], 403);
        }

        return $next($request);
    }
}