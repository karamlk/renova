<?php

namespace App\Http\Requests\Complaint;

use Illuminate\Foundation\Http\FormRequest;

class ReportNoShowRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            // الفرونت يرسل id الزيارة و id الشخص المتغيب
            'site_visit_id' => 'required|exists:site_visits,id',
            'reported_id'   => 'required|exists:users,id',
        ];
    }

    public function messages(): array
    {
        return [
            'site_visit_id.required' => 'يجب تحديد الزيارة الميدانية',
            'site_visit_id.exists'   => 'الزيارة الميدانية غير موجودة',
            'reported_id.required'   => 'يجب تحديد الشخص المتغيب',
            'reported_id.exists'     => 'المستخدم غير موجود',
        ];
    }
}