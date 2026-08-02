<?php

namespace App\Http\Requests\Complaint;

use Illuminate\Foundation\Http\FormRequest;

class ReportNoShowRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'site_visit_id' => 'required|exists:site_visits,id',
            // الفرونت يرسل الدور فقط — الباك يجد الشخص تلقائياً
            'reported_role' => 'required|in:user,contractor,engineer',
        ];
    }

    public function messages(): array
    {
        return [
            'site_visit_id.required' => 'يجب تحديد الزيارة الميدانية',
            'site_visit_id.exists'   => 'الزيارة الميدانية غير موجودة',
            'reported_role.required' => 'يجب تحديد دور الشخص الغائب',
            'reported_role.in'       => 'الدور غير صالح',
        ];
    }
}