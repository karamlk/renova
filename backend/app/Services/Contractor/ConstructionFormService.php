<?php

namespace App\Services\Contractor;

use App\Models\ConstructionForm;
use Barryvdh\DomPDF\Facade\Pdf;
use Exception;
use Illuminate\Support\Facades\Storage;

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

        $finalStatus = ($status === 'engineer_approved') ? 'pending_user' : 'engineer_rejected';

        $form->update([
            'status' => $finalStatus,
            'engineer_notes' => $notes
        ]);

        return $form;
    }

    // 4. اعتماد المستخدم النهائي
    public function reviewByUser(ConstructionForm $form, string $status, ?string $notes): ConstructionForm
    {
        if ($form->status !== 'pending_user') {
            throw new Exception('لا يمكن اتخاذ إجراء من قبل المستخدم، الاستمارة لم يوافق عليها المهندس بعد.');
        }

        $form->update([
            'status' => $status,
            'user_notes' => $notes
        ]);

        return $form;
    }

    // داخل ملف app/Services/ConstructionFormService.php

     // استدعاء المكتبة الجديدة في أعلى الملف

    public function generatePdf(ConstructionForm $form)
    {
        if ($form->status !== 'user_approved') {
            throw new Exception('لا يمكن تحميل ملف الاستمارة إلا بعد الحصول على الموافقات والاعتماد النهائي.');
        }

        $form->load(['contractor', 'engineer']);

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

}
