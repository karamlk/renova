<?php

namespace App\Http\Controllers;

use App\Http\Requests\ConfirmPaymentRequest;
use App\Http\Requests\Contractor\ConstructionForm\StoreConstructionFormRequest;
use App\Http\Requests\Engineer\EngineerReviewRequest;
use App\Models\ConstructionForm;
//use App\Http\Requests\StoreConstructionFormRequest;
//use App\Http\Requests\EngineerReviewRequest;
use App\Http\Requests\UserReviewRequest;
//use App\Services\ConstructionFormService;
use App\Models\User;
use App\Services\Auth\OtpService;
use App\Services\Contractor\ConstructionFormService;
use App\Services\Engineer\EngineerFormService;
use Exception;
use App\Models\Payment;
use App\Models\Wallet;
use App\Services\WalletService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ConstructionFormController extends Controller
{
    protected $formService;

    // حقن الخدمة (Dependency Injection)
    public function __construct(ConstructionFormService $formService)
    {
        $this->formService = $formService;
    }

    // 1. المتعهد: إنشاء
    public function store(StoreConstructionFormRequest $request)
    {
        $form = $this->formService->createForm(
            $request->validated(),
            $request->file('pdf_file')
        );

        if ($request->has('materials')) {

            $materials = json_decode(
                $request->materials,
                true
            );

            $this->formService->addMaterialsToForm(
                $form->id,
                $materials
            );
        }

        $form->load('materials');

        if ($form->pdf_file) {
            $form->pdf_file = asset(
                'storage/' . $form->pdf_file
            );
        }

        return response()->json([
            'message' =>
                'تم إنشاء الاستمارة وإرسالها للمهندس بانتظار التدقيق',
            'data' => $form
        ], 201);
    }

    // 2. المتعهد: تعديل
    public function update(
        StoreConstructionFormRequest $request,
        ConstructionForm $constructionForm)
    {
        try {
            $form = $this->formService
                ->updateForm($constructionForm, $request->validated(), $request
                    ->file('pdf_file'));
            if ($form->pdf_file) {
                $form->pdf_file = asset('storage/' . $form->pdf_file);
            }
            if ($request->has('materials')) {

                $constructionForm
                    ->materials()
                    ->delete();

                $materials = json_decode(
                    $request->materials,
                    true
                );

                $this->formService->addMaterialsToForm(
                    $constructionForm->id,
                    $materials
                );
            }
            return response()->json(['message' => 'تم تحديث بيانات الاستمارة بنجاح وأعيدت للمهندس', 'data' => $form]);
        } catch (Exception $e) {
            return response()->json(['error' => $e->getMessage()], 422);
        }
    }

    // 3. المهندس: قبول أو رفض
    public function engineerReview(EngineerReviewRequest $request, ConstructionForm $constructionForm)
    {
        try {
            $form = $this->formService->reviewByEngineer($constructionForm, $request->status, $request->engineer_notes);
            $msg = $request->status === 'engineer_approved' ? 'تم قبول الاستمارة وتحويلها للمستخدم' : 'تم رفض الاستمارة وإعادتها للمتعهد للتعديل';
            if ($form->pdf_file) {
                $form->pdf_file = asset('storage/' . $form->pdf_file);
            }
            return response()->json(['message' => $msg, 'data' => $form]);
        } catch (Exception $e) {
            return response()->json(['error' => $e->getMessage()], 422);
        }
    }

    // 4. المستخدم: قبول أو رفض نهائي
    public function userReview(UserReviewRequest $request, ConstructionForm $constructionForm)
    {
        try {
            $form = $this->formService
                ->reviewByUser($constructionForm, $request->status, $request->user_notes);
            $msg = $request->status === 'user_approved' ?
                'تم الاعتماد النهائي للاستمارة بنجاح من المستفيد' :
                'تم رفض الاستمارة من قبل المستفيد';
            if ($form->pdf_file) {
                $form->pdf_file = asset('storage/' . $form->pdf_file);
            }
            return response()->json(['message' => $msg, 'data' => $form]);
        } catch (Exception $e) {
            return response()->json(['error' => $e->getMessage()], 422);
        }

    }
    public function confirmPayment(
        ConfirmPaymentRequest $request,
        ConstructionForm $constructionForm
    )
    {
        try {

            app(OtpService::class)
                ->verifyPaymentOtp(
                    auth()->user(),
                    $request->otp
                );

            $form = $this->formService
                ->completePayment(
                    $constructionForm
                );

            return response()->json([
                'message' =>
                    'تم تأكيد الدفع بنجاح',
                'data' => $form
            ]);

        } catch (Exception $e) {

            return response()->json([
                'message' => $e->getMessage()
            ], 422);
        }
    }
    // 5. تحميل الـ PDF على الجوال
    // داخل ملف app/Http/Controllers/ConstructionFormController.php

    public function downloadPdf(ConstructionForm $constructionForm)
    {
        try {
            $pdfContent = $this->formService->generatePdf($constructionForm);
            $fileName = "construction_form_{$constructionForm->id}.pdf";

            return response($pdfContent)
                ->header('Content-Type', 'application/pdf')
                ->header('Content-Disposition', 'attachment; filename="' . $fileName . '"');

        } catch (Exception $e) {
            return response()->json(['error' => $e->getMessage()], 422);
        }
    }
    // 6. حذف الاستمارة
    public function destroy(ConstructionForm $constructionForm)
    {
        $this->formService->deleteForm($constructionForm);
        return response()->json(['message' => 'تم حذف الاستمارة نهائياً بنجاح']);
    }
    public function receivedForms()
    {
        $forms = ConstructionForm::with([
            'contractor'
        ])
            ->whereHas(
                'reconstructionRequest',
                function ($q) {
                    $q->where(
                        'user_id',
                        auth()->id()
                    );
                }
            )
            ->whereIn('status', [
                'pending_user',
                'waiting_payment_otp',
                'user_approved'
            ])
            ->latest()
            ->get();

        return response()->json($forms);
    }

    public function showForm($id)
    {
        $form = ConstructionForm::with([
            'contractor',
            'engineer',
            'materials',
            'reconstructionRequest'
        ])->findOrFail($id);

        if (
            $form->reconstructionRequest->user_id
            != auth()->id()
        ) {
            return response()->json([
                'message' => 'غير مصرح لك بعرض هذه الاستمارة'
            ], 403);
        }

        return response()->json([
            'data' => $form
        ]);
    }
    public function index(

    ) {
        return ConstructionForm::with([
            'engineer',
            'reconstructionRequest.user'
        ])  ->where('contractor_id', auth()->id())
            ->get();

    }
    public function show(ConstructionForm $form)
    {


        $form->load([

            'contractor:id,name,email',

            'engineer:id,name,email',

            'reconstructionRequest.user:id,name,email',

            'materials'

        ]);

        return response()->json($form);
    }

    public function rejectedForms()
    {
        return response()->json(

            ConstructionForm::with([

                'engineer:id,name',

                'reconstructionRequest.user:id,name'

            ])
                ->where('contractor_id', auth()->id())
                ->where('status', 'engineer_rejected')
                ->latest()
                ->get()

        );
    }
}
