<?php

namespace App\Services\Contractor;

use App\Models\ConstructionForm;
use App\Models\Notification;
use App\Models\PaymentAudit;
use App\Models\Project;
use App\Services\Auth\OtpService;
use Barryvdh\DomPDF\Facade\Pdf;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use App\Models\Payment;
use App\Models\Wallet;
use App\Services\WalletService;
use Mpdf\Mpdf;

class ConstructionFormService
{


    public function createForm(array $data, $file = null): ConstructionForm
    {
        $data['total_cost'] = $data['materials_cost'] + $data['labor_cost'] + $data['profit'];
        $data['status'] = 'pending_engineer';

        if ($file) {
            $data['pdf_file'] = $file->store('forms_pdf', 'public');
        }

        return ConstructionForm::create($data);
    }

    // 2. المتعهد يعدل الاستمارة
    public function updateForm(ConstructionForm $form, array $data, $file = null): ConstructionForm
    {
        if (!in_array($form->status, ['pending_engineer', 'engineer_rejected'])) {
            throw new Exception('لا يمكن تعديل هذه الاستمارة بعد تدقيقها وقبولها من المهندس.');
        }

        $materials = $data['materials_cost'] ?? $form->materials_cost;
        $labor = $data['labor_cost'] ?? $form->labor_cost;
        $profit = $data['profit'] ?? $form->profit;
        $data['total_cost'] = $materials + $labor + $profit;

        // تعود للمهندس عند أي تعديل
        $data['status'] = 'pending_engineer';

        if ($file) {
            if ($form->pdf_file) {
                Storage::disk('public')->delete($form->pdf_file);
            }
            $data['pdf_file'] = $file->store('forms_pdf', 'public');
        }

        $form->update($data);
        return $form;
    }

    // 3. تدقيق المهندس
    public function reviewByEngineer(ConstructionForm $form, string $status, ?string $notes): ConstructionForm
    {
        if ($form->status !== 'pending_engineer') {
            throw new Exception('هذه الاستمارة ليست في مرحلة تدقيق المهندس حالياً.');
        }

        $finalStatus = ($status === 'engineer_approved')
            ? 'pending_user' : 'engineer_rejected';

        $form->update([
            'status' => $finalStatus,
            'engineer_notes' => $notes
        ]);
        if ($status === 'engineer_approved') {

            app(\App\Services\NotificationService::class)
                ->send(

                    $form->reconstructionRequest->user_id,

                    'استمارة جديدة',

                    'وصلتك استمارة جديدة للمراجعة.',

                    'construction_form',

                    $form->id,

                    $form->id
                );

        }if($status === 'engineer_rejected'){

        Notification::create([

            'user_id' => $form->contractor_id,

            'title' => 'تم رفض الاستمارة',

            'message' => 'قام المهندس برفض الاستمارة، يرجى مراجعة الملاحظات وإعادة التعديل.',

            'construction_form_id' => $form->id

        ]);
    }
        return $form;
    }

    // 4. اعتماد المستخدم النهائي
    public function reviewByUser(
        ConstructionForm $form,
        string $status,
        ?string $notes
    ): ConstructionForm
    {
        if ($form->status !== 'pending_user') {
            throw new Exception(
                'لا يمكن اتخاذ إجراء من قبل المستخدم،
                 الاستمارة لم يوافق عليها المهندس بعد.'
            );
        }

        if ($status === 'user_rejected') {

            $form->update([
                'status' => 'user_rejected',
                'user_notes' => $notes
            ]);

            return $form;
        }

        $form->update([
            'status' => 'waiting_payment_otp',
            'user_notes' => $notes
        ]);

        app(OtpService::class)->send(
            $form->reconstructionRequest->user
        );

        return $form;
    }
    public function completePayment(
        ConstructionForm $form
    ): ConstructionForm
    {
        if ($form->status !== 'waiting_payment_otp') {
            throw new Exception(
                'الاستمارة ليست بانتظار تأكيد الدفع.'
            );
        }

        $amount = $form->total_cost * 0.60;

        $userWallet =
            $form->reconstructionRequest
                ->user
                ->wallet;

        $adminWallet =
            Wallet::where('user_id', 1)
                ->firstOrFail();

        $walletService =
            app(WalletService::class);

        $walletService->withdraw(
            $userWallet,
            $amount,
            "الدفعة الأولى للمشروع {$form->id}"
        );

        $walletService->deposit(
            $adminWallet,
            $amount,
            "استلام الدفعة الأولى للمشروع {$form->id}"
        );

           $payment= Payment::create([
            'construction_form_id' => $form->id,
            'user_id' => $form->reconstructionRequest->user_id,
            'amount' => $amount,
            'type' => 'first_payment',
            'status' => 'paid',
            'paid_at' => now()
        ]);
        PaymentAudit::create([

            'payment_id' => $payment->id,

            'from_user_id' =>
                $form->reconstructionRequest->user_id,

            'to_user_id' =>
                $form->contractor_id,

            'amount' => $amount,

            'action' => 'first_payment',

            'description' =>
                "تم تحويل الدفعة الأولى للمشروع {$form->id}"
        ]);
        $form->reconstructionRequest->update([
            'status' => 'closed'
        ]);
        Project::create([

            'construction_form_id' =>
                $form->id,

            'contractor_id' =>
                $form->contractor_id,

            'engineer_id' =>
                $form->engineer_id,

            'user_id' =>
                $form->reconstructionRequest->user_id,

            'status' => 'active'
        ]);
        app(\App\Services\NotificationService::class)
            ->send(

                $form->reconstructionRequest->user_id,

                'تم بدء المشروع',

                'تم اعتماد المشروع وبدأ التنفيذ.',

                'project',

                $form->id
            );
        ConstructionForm::where(
            'reconstruction_request_id',
            $form->reconstruction_request_id
        )
            ->where(
                'id',
                '!=',
                $form->id
            )
            ->update([
                'status' => 'user_rejected'
            ]);


        $form->update([
            'status' => 'user_approved'
        ]);

        return $form;
    }    // داخل ملف app/Services/ConstructionFormService.php

     // استدعاء المكتبة الجديدة في أعلى الملف

    public function generatePdf(ConstructionForm $form)
    {
        if ($form->status !== 'user_approved') {
            throw new Exception('لا يمكن تحميل ملف الاستمارة إلا بعد الحصول على الموافقات والاعتماد النهائي.');
        }

        $form->load(['contractor', 'engineer', 'materials']);

        // إعدادات mpdf الخاصة لدعم اللغة العربية وتوصيل الحروف بشكل صحيح
        $mpdf = new \Mpdf\Mpdf([
            'mode'          => 'utf-8',
            'format'        => 'A4',
            'margin_left'   => 15,
            'margin_right'  => 15,
            'margin_top'    => 15,
            'margin_bottom' => 15,
            'autoScriptToLang' => true, // سحري: يتعرف على النص العربي تلقائياً
            'autoLangToFont'   => true, // سحري: يختار خط عربي مناسب متوافق مع كل الأجهزة
        ]);

        // جلب كود الـ HTML من قالب الـ Blade
        $html = view('pdf.construction_form', compact('form'))->render();

        // كتابة الـ HTML داخل ملف PDF
        $mpdf->WriteHTML($html);

        // إرجاع محتوى الملف كمخرجات ثنائية (Binary)
        return $mpdf->Output('', 'S');
    }

    // 6. حذف الاستمارة
    public function deleteForm(ConstructionForm $form): void
    {
        if ($form->pdf_file) {
            Storage::disk('public')->delete($form->pdf_file);
        }
        $form->delete();
    }
    /**
     * إضافة مواد بناء إلى استمارة معينة وحساب السعر الإجمالي تلقائياً
     */
    public function addMaterialsToForm(int $formId, array $materialsData): void
    {
        foreach ($materialsData as $material) {
            // حساب السعر الإجمالي برمجياً لضمان الدقة والأمان
            $totalPrice = $material['quantity'] * $material['unit_price'];

            \App\Models\ConstructionMaterial::create([
                'construction_form_id' => $formId,
                'material_name'        => $material['material_name'],
                'material_type'        => $material['material_type'],
                'quantity'             => $material['quantity'],
                'unit'                 => $material['unit'],
                'unit_price'           => $material['unit_price'],
                'total_price'          => $totalPrice,
            ]);
        }
    }

    /**
     * جلب تفاصيل الاستمارة كاملة مدمجاً بداخلها جدول المواد الخاص بها (Eager Loading)
     */
    public function getFormWithMaterials(int $formId)
    {
        return \App\Models\ConstructionForm::with('materials')->findOrFail($formId);
    }

}
