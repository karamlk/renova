<?php

use Illuminate\Auth\Access\AuthorizationException;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpKernel\Exception\HttpException;
use Symfony\Component\HttpKernel\Exception\TooManyRequestsHttpException;
use Illuminate\Http\Request;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        //
        $middleware->alias([
            'role'   => \App\Http\Middleware\RoleMiddleware::class,
            'active' => \App\Http\Middleware\CheckUserActive::class,
        ]);

    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->render(function (Throwable $e, Request $request) {

            if ($request->expectsJson()) {

                // 429 — Too Many Requests (Throttle hit)
                if ($e instanceof TooManyRequestsHttpException) {
                    return response()->json([
                        'message'     => 'لقد تجاوزت الحد المسموح من الطلبات، يرجى الانتظار قليلاً',
                        'retry_after' => $e->getHeaders()['Retry-After'] ?? null,
                    ], 429);
                }

                // 404 — Model Not Found
                if ($e instanceof ModelNotFoundException) {
                    return response()->json([
                        'message' => 'العنصر المطلوب غير موجود في النظام',
                    ], 404);
                }

                // 403 — Authorization Exception- MD
                if ($e instanceof AuthorizationException) {
                    return response()->json([
                        'message' => 'ليس لديك الصلاحية الكافية لإتمام هذا الإجراء',
                    ], 403);
                }

                // 422 — Validation errors
                if ($e instanceof ValidationException) {
                    return response()->json([
                        'message' => collect($e->errors())->flatten()->first(),
                        'errors'  => $e->errors(),
                    ], 422);
                }

                // 401 — Unauthenticated
                if ($e instanceof AuthenticationException) {
                    return response()->json([
                        'message' => 'يرجى تسجيل الدخول أولاً',
                    ], 401);
                }

                // HTTP exceptions (403, 404, 500 manual aborts)
                if ($e instanceof HttpException) {
                    return response()->json([
                        'message' => $e->getMessage() ?: 'حدث خطأ في الطلب',
                    ], $e->getStatusCode());
                }

                // Unexpected structural server crashes
                if (!config('app.debug') && !app()->environment('testing')) {
                    return response()->json([
                        'message' => 'حدث خطأ غير متوقع، يرجى المحاولة لاحقاً',
                    ], 500);
                }
            }
        });
    })->create();
