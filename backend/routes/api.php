<?php


use App\Http\Controllers\AccountController;
use App\Http\Controllers\Auth\AccountDeletionController;
use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\Auth\ChangePasswordController;
use App\Http\Controllers\Auth\PasswordResetController;
use App\Http\Controllers\Contractor\ContractorPostController;
use App\Http\Controllers\Contractor\ContractorProfileController;
use App\Http\Controllers\InspectionRequestController;
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
Route::middleware('auth:sanctum')->group(function () {

    Route::post(
        '/contractor/profile',
        [ContractorProfileController::class, 'store']
    );
    Route::get(
        '/contractor/profile',
        [ContractorProfileController::class, 'show']
    );

    Route::post(
        '/contractor/profile/update',
        [ContractorProfileController::class, 'update']
    );

});
Route::middleware('auth:sanctum')->group(function () {

    Route::post(
        '/contractor/posts',
        [ContractorPostController::class, 'store']
    );
    Route::post(
        '/contractor/posts/{id}',
        [ContractorPostController::class, 'update']
    );

    Route::delete(
        '/contractor/posts/{id}',
        [ContractorPostController::class, 'delete']
    );

});

Route::get(
    '/contractor/posts',
    [ContractorPostController::class, 'index']
);

Route::get(
    '/contractor/posts/{id}',
    [ContractorPostController::class, 'show']
);

Route::get(
    '/contractors/{id}/posts',
    [ContractorPostController::class, 'contractorPosts']
);
Route::middleware('auth:sanctum')->group(function () {

    // إرسال طلب زيارة
    Route::post(
        '/inspection-requests',
        [InspectionRequestController::class,
            'store']
    );

    // قبول
    Route::post(
        '/inspection-requests/{id}/accept',
        [InspectionRequestController::class,
            'accept']
    );

    // رفض
    Route::post(
        '/inspection-requests/{id}/reject',
        [InspectionRequestController::class,
            'reject']
    );
});

// عرض طلبات الزيارة لطلب معين
Route::get(
    '/requests/{id}/inspection-requests',
    [InspectionRequestController::class,
        'requestInspections']
);
