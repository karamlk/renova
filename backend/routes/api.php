<?php


use App\Http\Controllers\AccountController;
use App\Http\Controllers\Admin\Complaint\ComplaintController as AdminComplaintController ;
use App\Http\Controllers\Admin\Complaint\NoShowWarningController as AdminNoShowWarningController;
use App\Http\Controllers\Admin\FinanceController;
use App\Http\Controllers\Admin\UserManagementController;
use App\Http\Controllers\Auth\AccountDeletionController;
use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\Auth\ChangePasswordController;
use App\Http\Controllers\Auth\PasswordResetController;
use App\Http\Controllers\Contractor\ContractorPostController;
use App\Http\Controllers\Contractor\ContractorProfileController;
use App\Http\Controllers\Contractor\ScheduleController;
use App\Http\Controllers\Engineer\EngineerVisitController;
use App\Http\Controllers\Engineer\ProjectTaskController;
use App\Http\Controllers\InspectionRequestController;
use App\Http\Controllers\PaymentAuditController;
use App\Http\Controllers\PaymentController;
use App\Http\Controllers\ProjectController;
use App\Http\Controllers\SiteVisitController;
use App\Http\Controllers\User\LikeController;
use App\Http\Controllers\User\NotificationController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum', 'active');

Route::post('/register', [AuthController::class, 'register']);

Route::post('/otp/resend', [AuthController::class, 'resendOtp']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('logout',[AuthController::class,'logout'])->middleware('auth:sanctum');
Route::post('/verify-otp', [AuthController::class, 'verifyOtp']);
Route::post('/otp/verify', [AuthController::class, 'verify']);

Route::post('/password/forgot', [PasswordResetController::class, 'sendOtp']);
//Route::post('/password/reset', [PasswordResetController::class, 'resetPassword']);
Route::post('/password/reset', [ChangePasswordController::class, 'updatePassword']);
Route::post('/password/change', [ChangePasswordController::class, 'change'])->middleware('auth:sanctum');
Route::post('/verify-otp/password', [PasswordResetController::class, 'verifyOtp']);

// خطوة 2: تغيير كلمة المرور الجديدة
Route::post('/set-new-password', [PasswordResetController::class, 'setNewPassword']);

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/delete-request', [AccountDeletionController::class, 'requestDeletion']);
    Route::post('/confirm-deletion', [AccountDeletionController::class, 'confirmDeletion']);
});

use App\Http\Controllers\Admin\ContractorController;
use App\Http\Controllers\Complaint\ComplaintController;

Route::prefix('admin')->group(function () {

    Route::get('/contractors/pending', [ContractorController::class, 'pending']);
    Route::post('/contractors/{id}/approve', [ContractorController::class, 'approve']);
    Route::post('/contractors/{id}/reject', [ContractorController::class, 'reject']);

});
use App\Http\Controllers\User\ProfileController;

Route::middleware(['auth:sanctum','active'])->group(function () {

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
Route::middleware(['auth:sanctum','active'])->group(function () {
    Route::get(
        '/contractor/reconstruction-requests',
        [ReconstructionRequestController::class, 'index']);

    // إرسال طلب زيارة
    Route::post(
        '/inspection-requests',
        [InspectionRequestController::class,
            'store']
    );

    // قبول
    Route::post(
        '/inspection-requests/accept',
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
Route::get(
    '/user/offers',
    [InspectionRequestController::class, 'userOffers']
);
// عرض طلبات الزيارة لطلب معين
Route::get(
    '/requests/inspection-requests',
    [InspectionRequestController::class,
        'requestInspections']
);

Route::middleware(['auth:sanctum','active'])->group(function () {

    Route::post(
        '/contractor/schedules',
        [ScheduleController::class, 'store']
    );
    Route::get(
        '/contractor/schedules',
        [ScheduleController::class, 'index']
    );

    Route::get(
        '/contractor/schedule/{schedule}',
        [ScheduleController::class, 'show']
    );
    Route::delete(
        '/contractor/schedules/{schedule}',
        [ScheduleController::class, 'destroy']
    );
    Route::post(
        '/contractor/schedules/update/{scheduleId}',
        [ScheduleController::class, 'update']
    );

    Route::get(
        '/inspection-requests/{inspectionRequest}/schedules',
        [ScheduleController::class, 'availableSchedules']
    );

    Route::get(
        '/contractor/visits',
        [SiteVisitController::class,
            'contractorVisits']
    );
    Route::get(
        '/user/visits',
        [SiteVisitController::class,
            'userVisits']
    );
//لايكات بوسات المتعهد ------------------------
    Route::post(
        '/posts/{post}/like',
        [LikeController::class, 'toggleLike']
    );

    // شكاوي المستخدم الحالي
    Route::get('complaints',         [ComplaintController::class, 'index']);

    // رفع شكوى جديدة
    Route::post('complaints',        [ComplaintController::class, 'store']);

    // الإبلاغ عن غياب في زيارة ميدانية
    Route::post('no-show-warnings',  [ComplaintController::class, 'reportNoShow']);
});
//---------------ادارة مستخدمين


    Route::middleware([
        'auth:sanctum',
        'active'
    ])->prefix('admin')->group(function () {

        Route::get(
            '/users',
            [UserManagementController::class, 'index']
        );

        Route::get(
            '/users/{user}',
            [UserManagementController::class, 'show']
        );

        Route::patch(
            '/users/{user}/status',
            [UserManagementController::class, 'toggleStatus']
        );

        Route::patch(
            '/users/{user}/active',
            [UserManagementController::class, 'toggleActive']
        );

        Route::delete(
            '/users/{user}',
            [UserManagementController::class, 'destroy']
        );

        Route::get(
            '/contractors',
            [UserManagementController::class, 'contractors']
        );

        Route::get(
            '/engineers',
            [UserManagementController::class, 'engineers']
        );
        Route::post(
            '/create-engineer',
            [UserManagementController::class, 'createEngineerByAdmin']);
        Route::get('available-engineers', [SiteVisitController::class, 'availableEngineers']);
        Route::get('site-visits/pending-assignment', [SiteVisitController::class, 'unassignedOrRejectedVisits']);

        // فرز مهندس لزيارة معينة
        Route::post('site-visits/assign', [SiteVisitController::class, 'assignEngineer']);

        Route::get('all-complaints',                   [AdminComplaintController::class, 'getAllComplaints']);
        Route::get('archived-complaints',[AdminComplaintController::class, 'getArchivedComplaints']);

        Route::get('complaints',                        [AdminComplaintController::class, 'index']);
        Route::get('complaints/{complaint}',            [AdminComplaintController::class, 'show']);
        Route::patch('complaints/{complaint}/resolve',  [AdminComplaintController::class, 'resolve']);
        Route::patch('complaints/{complaint}/archive',[AdminComplaintController::class, 'archive']);

        Route::get('no-show-warnings',          [AdminNoShowWarningController::class, 'index']);
        Route::get('no-show-warnings/{noShowWarning}', [AdminNoShowWarningController::class, 'show']);
        Route::patch('no-show-warnings/{noShowWarning}/archive',[AdminNoShowWarningController::class, 'archive']);
        Route::post('/payments/{payment}/release', [PaymentController::class, 'release']);
        Route::get(
            '/finance/dashboard',
            [FinanceController::class, 'dashboard']
        );
        Route::get(
            '/payments',
            [PaymentController::class,'index']
        );
        Route::get(
            '/payments/{payment}',
            [PaymentController::class,'show']
        );
        Route::get(
            '/payment-audits',
            [PaymentAuditController::class,'index']
        );
        Route::get(
            '/payment-audits/{payment_audit}',
            [PaymentAuditController::class,'show']
        );
        Route::get(
            '/projects/waiting-release',
            [ProjectController::class,'waitingRelease']
        );
        Route::get(
            '/projects/finished-payments',
            [ProjectController::class,'finishedPayments']
        );
        Route::get(
            '/finance/report',
            [FinanceController::class,'report']
        );
    });


use App\Http\Controllers\ConstructionFormController;

// روابط المتعهد (إنشاء، تعديل، حذف)
Route::post('construction-forms', [ConstructionFormController::class, 'store']);
Route::post('construction-forms/{constructionForm}', [ConstructionFormController::class, 'update']);
Route::delete('construction-forms/{constructionForm}', [ConstructionFormController::class, 'destroy']);

// رابط تدقيق المهندس (قبول/رفض)
Route::put('construction-forms/{constructionForm}/engineer-review', [ConstructionFormController::class, 'engineerReview']);

// رابط اعتماد المستخدم المتضرر (قبول/رفض)
Route::put('construction-forms/{constructionForm}/user-review', [ConstructionFormController::class, 'userReview']);

// رابط تحميل المستند الـ PDF النهائي للمتضرر على جواله
Route::get('construction-forms/{constructionForm}/download-pdf', [ConstructionFormController::class, 'downloadPdf']);

use App\Http\Controllers\Engineer\EngineerProfileController;

// مسار خاص بالآدمن لإنشاء الحسابات

// مسارات المهندس الشخصية لإدارة البروفايل المدمج الفاخر
Route::middleware(['auth:sanctum'])->group(function () {
    Route::get('engineer/profile', [EngineerProfileController::class, 'show']);
    Route::post('engineer/profile', [EngineerProfileController::class, 'update']);
    Route::post('site-visits/respond', [EngineerVisitController::class, 'respondToVisit']);
    Route::post(
        'construction-forms/{constructionForm}/confirm-payment',
        [ConstructionFormController::class, 'confirmPayment']
    );
//------------------------------------------
    Route::middleware(
        'auth:sanctum'
    )->group(function () {

        Route::get(
            '/notifications',
            [NotificationController::class, 'index']
        );

        Route::get(
            '/notifications/count',
            [NotificationController::class, 'unreadCount']
        );

        Route::patch(
            '/notifications/read-all',
            [NotificationController::class, 'markAllRead']
        );

         Route::get(
             '/receivedForms',
             [ConstructionFormController::class, 'receivedForms']
         );
        Route::get(
            '/showForm/{id}',
            [ConstructionFormController::class, 'showForm']
        );
    });
    //----------------------------------------------------------
    Route::prefix('tasks')->group(function () {

        Route::post(
            '/',
            [ProjectTaskController::class,'store']
        );

        Route::put(
            '/{task}',
            [ProjectTaskController::class,'update']
        );

        Route::delete(
            '/{task}',
            [ProjectTaskController::class,'destroy']
        );

        Route::patch(
            '/{task}/complete',
            [ProjectTaskController::class,'complete']
        );
    });

    Route::get(
        '/projects/{project}/tasks',
        [ProjectTaskController::class,'index']
    );
    Route::get(
        '/tasks/{task}',
        [ProjectTaskController::class,'show']
    );
    Route::get(
        '/payments/pending',
        [PaymentController::class,'pending']
    );
    Route::post('/payments/{payment}/send-otp',[PaymentController::class,'sendOtp']);

    Route::post(
        '/payments/{payment}/pay',
        [PaymentController::class,'pay']
    );
});
