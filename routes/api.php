<?php


use App\Http\Controllers\AccountController;
use App\Http\Controllers\Auth\AccountDeletionController;
use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\Auth\ChangePasswordController;
use App\Http\Controllers\Auth\PasswordResetController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('/register', [AuthController::class, 'register']);

Route::post('/otp/resend', [AuthController::class, 'resendOtp']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('logout',[AuthController::class,'logout'])->middleware('auth:sanctum');
Route::post('/verify-otp', [AuthController::class, 'verifyOtp']);
Route::post('/otp/verify', [AuthController::class, 'verify']);

Route::post('/password/forgot', [PasswordResetController::class, 'sendOtp']);
//Route::post('/password/reset', [PasswordResetController::class, 'resetPassword']);
Route::post('/password/change', [ChangePasswordController::class, 'change'])->middleware('auth:sanctum');
Route::post('/verify-otp/password', [PasswordResetController::class, 'verifyOtp']);

// خطوة 2: تغيير كلمة المرور الجديدة
Route::post('/set-new-password', [PasswordResetController::class, 'setNewPassword']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/delete-request', [AccountDeletionController::class, 'requestDeletion']);
    Route::post('/confirm-deletion', [AccountDeletionController::class, 'confirmDeletion']);
});

use App\Http\Controllers\Admin\ContractorController;

Route::prefix('admin')->group(function () {

    Route::get('/contractors/pending', [ContractorController::class, 'pending']);
    Route::post('/contractors/{id}/approve', [ContractorController::class, 'approve']);
    Route::post('/contractors/{id}/reject', [ContractorController::class, 'reject']);

});
use App\Http\Controllers\User\ProfileController;

Route::middleware('auth:sanctum')->group(function () {

    Route::post('/user/profile', [ProfileController::class, 'store']);
    Route::get('/user/profile', [ProfileController::class, 'show']);
    Route::post('/user/profile/update', [ProfileController::class, 'update']);

});

use App\Http\Controllers\User\ReconstructionRequestController;

Route::middleware('auth:sanctum')->group(function () {

    Route::post(
        '/reconstruction-requests',
        [ReconstructionRequestController::class, 'store']
    );
    Route::get(
        '/reconstruction-requests',
        [ReconstructionRequestController::class, 'index']
    );

    Route::get(
        '/reconstruction-requests/{id}',
        [ReconstructionRequestController::class, 'show']
    );

    Route::post(
        '/reconstruction-requests/{id}',
        [ReconstructionRequestController::class, 'update']
    );

    Route::delete(
        '/reconstruction-requests/{id}',
        [ReconstructionRequestController::class, 'destroy']
    );


});
