<?php

use App\Http\Controllers\AccountController;
use App\Http\Controllers\Admin\Complaint\ComplaintController as AdminComplaintController;
use App\Http\Controllers\Admin\Complaint\NoShowWarningController as AdminNoShowWarningController;
use App\Http\Controllers\Admin\ContractorController;
use App\Http\Controllers\Admin\FinanceController;
use App\Http\Controllers\Admin\UserManagementController;
use App\Http\Controllers\Auth\AccountDeletionController;
use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\Auth\ChangePasswordController;
use App\Http\Controllers\Auth\PasswordResetController;
use App\Http\Controllers\Complaint\ComplaintController;
use App\Http\Controllers\Complaint\NoShowWarningController;
use App\Http\Controllers\Contractor\ContractorPostController;
use App\Http\Controllers\Contractor\ContractorProfileController;
use App\Http\Controllers\Contractor\ScheduleController;
use App\Http\Controllers\ConstructionFormController;
use App\Http\Controllers\Engineer\EngineerDashboardController;
use App\Http\Controllers\Engineer\EngineerFormController;
use App\Http\Controllers\Engineer\EngineerProfileController;
use App\Http\Controllers\Engineer\EngineerProjectController;
use App\Http\Controllers\Engineer\EngineerVisitController;
use App\Http\Controllers\Engineer\ProjectTaskController;
use App\Http\Controllers\FcmTokenController;
use App\Http\Controllers\InspectionRequestController;
use App\Http\Controllers\InvoiceController;
use App\Http\Controllers\PaymentAuditController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\ProjectController;
use App\Http\Controllers\ProjectReviewController;
use App\Http\Controllers\SiteVisitController;
use App\Http\Controllers\TestNotificationController;
use App\Http\Controllers\User\LikeController;
use App\Http\Controllers\NotificationController;
use App\Http\Controllers\User\ProfileController;
use App\Http\Controllers\User\ReconstructionRequestController;
use App\Http\Controllers\WalletController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

// ══════════════════════════════════════════════════════════════
// PUBLIC ROUTES — No auth required
// ══════════════════════════════════════════════════════════════

Route::post('/register',            [AuthController::class, 'register']);
Route::post('/login',               [AuthController::class, 'login']);
Route::post('/otp/resend',          [AuthController::class, 'resendOtp']);
Route::post('/otp/verify',          [AuthController::class, 'verify']);
Route::post('/verify-otp',          [AuthController::class, 'verifyOtp']);

Route::post('/password/forgot',     [PasswordResetController::class, 'sendOtp']);
Route::post('/verify-otp/password', [PasswordResetController::class, 'verifyOtp']);
Route::post('/set-new-password',    [PasswordResetController::class, 'setNewPassword']);
Route::post('/password/reset',      [ChangePasswordController::class, 'updatePassword']);

// Public contractor posts (visible without login)



// ══════════════════════════════════════════════════════════════
// AUTHENTICATED — Auth only (no role restriction)
// ══════════════════════════════════════════════════════════════

Route::middleware(['auth:sanctum'])->group(function () {

    Route::post('/logout', [AuthController::class, 'logout']);

    Route::post('/password/change', [ChangePasswordController::class, 'change']);

    Route::post('/delete-request',  [AccountDeletionController::class, 'requestDeletion']);
    Route::post('/confirm-deletion', [AccountDeletionController::class, 'confirmDeletion']);


    // Notifications — all roles
    Route::get('notifications',                    [NotificationController::class, 'index']);
    Route::get('notifications/unread-count',       [NotificationController::class, 'unreadCount']);
    Route::patch('notifications/read-all',         [NotificationController::class, 'markAllRead']);
    Route::patch('notifications/{notification}/read', [NotificationController::class, 'markRead']);
    Route::delete('notifications',                    [NotificationController::class, 'destroyAll']);

    // Reconstruction requests — read available to all (contractors browse them)
    Route::get('/reconstruction-requests',       [ReconstructionRequestController::class, 'index']);
    Route::get('/reconstruction-requests/{id}',  [ReconstructionRequestController::class, 'show']);


});

// ══════════════════════════════════════════════════════════════
// ACTIVE USERS — Auth + active account required
// ══════════════════════════════════════════════════════════════

// USER (customer) and ADMIN
Route::middleware(['auth:sanctum', 'active', 'role:user,admin'])->group(function () {
    Route::post('/user/profile',        [ProfileController::class, 'store']);
    Route::get('/user/profile',         [ProfileController::class, 'show']);
    Route::post('/user/profile/update', [ProfileController::class, 'update']);
});

Route::middleware(['auth:sanctum', 'active', 'role:user,contractor,engineer'])->group(function () {
    // Route::get('my-complaints',                  [ComplaintController::class, 'myComplaints']);
    // Route::get('complaints/{complaint}',         [ComplaintController::class, 'show']);
    Route::post('no-show-warnings',              [NoShowWarningController::class, 'store']);
    // Route::get('no-show-warnings/{warning}',     [NoShowWarningController::class, 'show']);
});

// User & contractor
Route::middleware(['auth:sanctum', 'active', 'role:user,contractor'])->group(function () {
    Route::post('complaints',[ComplaintController::class, 'store']);

    //invoices
    Route::get('/invoice/{invoice}',[InvoiceController::class,'show']);
    Route::get('/invoice/{invoice}/pdf',[InvoiceController::class,'pdf']);

    //Route::get('/contractor/profile/{id}',         [ContractorProfileController::class, 'show']);

    Route::get('/contractors/{id}/posts',     [ContractorPostController::class, 'contractorPosts']);

    Route::get('all_posts',[ContractorPostController::class,'allPosts']);

    Route::get('/post/{id}',[ContractorPostController::class,'post']);



});



Route::middleware(['auth:sanctum', 'active', 'role:user,contractor,engineer'])->group(function () {
    Route::get('/wallet', [WalletController::class, 'financialAccount']);
    Route::get('/payments/{payment}', [PaymentController::class, 'showPayment']);
    Route::post('/fcm-token', [FcmTokenController::class, 'update']);
    Route::get('/test-notification', [TestNotificationController::class, 'send']);
});

// ── USER (customer) ───────────────────────────────────────────
Route::middleware(['auth:sanctum', 'active', 'role:user'])->group(function () {

    // Reconstruction requests — write
    Route::post('/reconstruction-requests',       [ReconstructionRequestController::class, 'store']);
    Route::post('/reconstruction-requests/{id}',  [ReconstructionRequestController::class, 'update']);
    Route::delete('/reconstruction-requests/{id}', [ReconstructionRequestController::class, 'destroy']);

    // Inspection requests — customer accepts/rejects
    Route::get('/inspection-requests/{inspectionRequest}/schedules',   [ScheduleController::class, 'availableSchedules']);
    Route::post('/inspection-requests/accept',        [InspectionRequestController::class, 'accept']);
    Route::post('/inspection-requests/{id}/reject',   [InspectionRequestController::class, 'reject']);
    Route::get('/user/offers',                        [InspectionRequestController::class, 'userOffers']);
    Route::get('/requests/inspection-requests',       [InspectionRequestController::class, 'requestInspections']);

    // Site visits
    Route::get('/user/visits', [SiteVisitController::class, 'userVisits']);

    // Construction form — user review
    Route::put('construction-forms/{constructionForm}/user-review', [ConstructionFormController::class, 'userReview']);
    Route::get('construction-forms/{constructionForm}/download-pdf', [ConstructionFormController::class, 'downloadPdf']);
    Route::get('/receivedForms', [ConstructionFormController::class, 'receivedForms']);
    Route::get('/showForm/{id}', [ConstructionFormController::class, 'showForm']);

    // Payments
    Route::get('/payments/pending',                 [PaymentController::class, 'pending']);
    Route::post('/payments/{payment}/send-otp',     [PaymentController::class, 'sendOtp']);
    Route::post('/payments/{payment}/pay',          [PaymentController::class, 'pay']);
    Route::post('construction-forms/{constructionForm}/confirm-payment', [ConstructionFormController::class, 'confirmPayment']);

    // Likes
    Route::post('/posts/{post}/like', [LikeController::class, 'toggleLike']);

    //invoice
    Route::get('/my-invoices',[InvoiceController::class,'myInvoices']);

    //review
    Route::post('/projects/{project}/review', [ProjectReviewController::class, 'store']);

    Route::get('/user/projects', [ProjectController::class, 'userProjects']);
    Route::get('/user/projects/{id}', [ProjectController::class, 'userProject']);
});

// ── CONTRACTOR ────────────────────────────────────────────────
Route::middleware(['auth:sanctum', 'active', 'role:contractor'])->group(function () {

    // Profile
    Route::post('/contractor/profile',        [ContractorProfileController::class, 'store']);
    Route::get('/contractor/profile',         [ContractorProfileController::class, 'show']);
    Route::post('/contractor/profile/update', [ContractorProfileController::class, 'update']);

    // Posts
    Route::get('/contractor/projects/available-for-post', [ContractorPostController::class, 'availableProjects']);
    Route::post('/contractor/posts',       [ContractorPostController::class, 'store']);
    Route::post('/contractor/posts/{id}',  [ContractorPostController::class, 'update']);
    Route::delete('/contractor/posts/{id}', [ContractorPostController::class, 'delete']);
    Route::get('/contractor/posts',   [ContractorPostController::class, 'index']);
    Route::get('/contractor/posts/{id}',  [ContractorPostController::class, 'show']);

    // Schedules
    Route::post('/contractor/schedules',                               [ScheduleController::class, 'store']);
    Route::get('/contractor/schedules',                                [ScheduleController::class, 'index']);
    Route::get('/contractor/schedule/{schedule}',                      [ScheduleController::class, 'show']);
    Route::delete('/contractor/schedules/{schedule}',                  [ScheduleController::class, 'destroy']);
    Route::post('/contractor/schedules/update/{scheduleId}',           [ScheduleController::class, 'update']);
    //Route::get('/inspection-requests/{inspectionRequest}/schedules',   [ScheduleController::class, 'availableSchedules']);

    // Inspection requests — contractor sends
    Route::post('/inspection-requests', [InspectionRequestController::class, 'store']);
    Route::get('/contractor/reconstruction-requests',[ReconstructionRequestController::class,'index']);

    // Site visits
    Route::get('/contractor/visits', [SiteVisitController::class, 'contractorVisits']);

    // Construction forms
    Route::get('/contractor/forms/rejected',                    [ConstructionFormController::class, 'rejectedForms']);
    Route::post('construction-forms',                           [ConstructionFormController::class, 'store']);
    Route::post('construction-forms/{constructionForm}',        [ConstructionFormController::class, 'update']);
    Route::delete('construction-forms/{constructionForm}',      [ConstructionFormController::class, 'destroy']);
    Route::get('construction-forms',                            [ConstructionFormController::class, 'index']);
    Route::get('construction-forms/{form}',                     [ConstructionFormController::class, 'show']);

    // Likes
    Route::post('/posts/{post}/like', [LikeController::class, 'toggleLike']);

    //invoice
    Route::get('contractor/invoices',[InvoiceController::class,'contractorInvoices']);

    Route::get('/contractor/projects', [ProjectController::class, 'myProjects']);
    Route::get('/contractor/projects/{project}', [ProjectController::class, 'show']);

});

// ── ENGINEER ──────────────────────────────────────────────────
Route::middleware(['auth:sanctum', 'active', 'role:engineer'])->group(function () {

    // Profile
    Route::get('engineer/profile',  [EngineerProfileController::class, 'show']);
    Route::post('engineer/profile', [EngineerProfileController::class, 'update']);

    // Visits
    Route::get('/visits',              [EngineerVisitController::class, 'index']);
    Route::get('/visits/{visit}',      [EngineerVisitController::class, 'show']);
    Route::post('site-visits/respond', [EngineerVisitController::class, 'respondToVisit']);

    // Forms
    Route::get('/forms',         [EngineerFormController::class, 'index']);
    Route::get('/forms/{form}',  [EngineerFormController::class, 'show']);

    // Engineer review of construction form
    Route::put('construction-forms/{constructionForm}/engineer-review', [ConstructionFormController::class, 'engineerReview']);

    // Projects
    Route::get('/projects',           [EngineerProjectController::class, 'index']);
    Route::get('/projects/{project}', [EngineerProjectController::class, 'show']);

    // Tasks
    Route::prefix('tasks')->group(function () {
        Route::post('/',                [ProjectTaskController::class, 'store']);
        Route::put('/{task}',           [ProjectTaskController::class, 'update']);
        Route::delete('/{task}',        [ProjectTaskController::class, 'destroy']);
        Route::patch('/{task}/complete', [ProjectTaskController::class, 'complete']);
    });
    Route::get('/projects/{project}/tasks', [ProjectTaskController::class, 'index']);
    Route::get('/tasks/{task}',             [ProjectTaskController::class, 'show']);

    // Dashboard
    Route::get('/dashboard', [EngineerDashboardController::class, 'index']);

});

// ══════════════════════════════════════════════════════════════
// ADMIN
// ══════════════════════════════════════════════════════════════

Route::middleware(['auth:sanctum', 'active', 'role:admin'])->prefix('admin')->group(function () {

    // Contractor approval (old routes kept for compatibility)
    Route::get('/contractors/pending',      [ContractorController::class, 'pending']);
    Route::post('/contractors/{id}/approve', [ContractorController::class, 'approve']);
    Route::post('/contractors/{id}/reject', [ContractorController::class, 'reject']);

    // User management
    Route::get('/users',                    [UserManagementController::class, 'index']);
    Route::get('/users/{user}',             [UserManagementController::class, 'show']);
    Route::patch('/users/{user}/status',    [UserManagementController::class, 'toggleStatus']);
    Route::patch('/users/{user}/active',    [UserManagementController::class, 'toggleActive']);
    Route::delete('/users/{user}',          [UserManagementController::class, 'destroy']);
    Route::get('/contractors',              [UserManagementController::class, 'contractors']);
    Route::get('/engineers',                [UserManagementController::class, 'engineers']);
    Route::post('/create-engineer',         [UserManagementController::class, 'createEngineerByAdmin']);

    // Site visit management
    Route::get('available-engineers',                   [SiteVisitController::class, 'availableEngineers']);
    Route::get('site-visits/pending-assignment',        [SiteVisitController::class, 'unassignedOrRejectedVisits']);
    Route::post('site-visits/assign',                   [SiteVisitController::class, 'assignEngineer']);

    // Complaints
    Route::get('all-complaints',                        [AdminComplaintController::class, 'getAllComplaints']);
    Route::get('archived-complaints',                   [AdminComplaintController::class, 'getArchivedComplaints']);
    Route::get('complaints',                            [AdminComplaintController::class, 'index']);
    Route::get('complaints/{complaint}',                [AdminComplaintController::class, 'show']);
    Route::patch('complaints/{complaint}/resolve',      [AdminComplaintController::class, 'resolve']);
    Route::patch('complaints/{complaint}/archive',      [AdminComplaintController::class, 'archive']);

    // No-show warnings
    Route::get('no-show-warnings',                      [AdminNoShowWarningController::class, 'index']);
    Route::get('no-show-warnings/{noShowWarning}',      [AdminNoShowWarningController::class, 'show']);
    Route::patch('no-show-warnings/{noShowWarning}/archive', [AdminNoShowWarningController::class, 'archive']);

    // Finance & payments
    Route::get('/finance/dashboard',        [FinanceController::class, 'dashboard']);
    Route::get('/finance/report',           [FinanceController::class, 'report']);
    Route::get('/payments',                 [PaymentController::class, 'index']);
    Route::get('/payments/{payment}',       [PaymentController::class, 'show']);
    Route::post('/payments/{payment}/release', [PaymentController::class, 'release']);
    Route::get('/payment-audits',           [PaymentAuditController::class, 'index']);
    Route::get('/payment-audits/{payment_audit}', [PaymentAuditController::class, 'show']);

    // Projects
    Route::get('/projects/waiting-release',   [ProjectController::class, 'waitingRelease']);
    Route::get('/projects/finished-payments', [ProjectController::class, 'finishedPayments']);

    //invoices
    Route::get('/invoice/{invoice}',[InvoiceController::class,'show']);
    Route::get('/invoice/{invoice}/pdf',[InvoiceController::class,'pdf']);
    Route::get('invoices',[InvoiceController::class,'adminInvoices']);
});


use App\Services\FirebaseNotificationService;


Route::post('/test-firebase', function (
    FirebaseNotificationService $firebase
) {

    $token = request('token');

    return $firebase->send(
        $token,
        'تجربة إشعار 🔔',
        'هذا إشعار تجريبي من منصة ReNova'
    );

});
