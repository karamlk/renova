<?php

namespace App\Http\Requests\Complaint;

use Illuminate\Foundation\Http\FormRequest;

class ResolveComplaintRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'status'             => 'required|in:resolved,dismissed',
            'admin_note'         => 'nullable|string|max:1000',
            // النسبة المئوية للعقوبة — اختيارية، فقط عند resolved وبين مستخدم ومتعهد
            'penalty_percentage' => 'nullable|numeric|min:0|max:100',
        ];
    }

    public function messages(): array
    {
        return [
            'status.required'           => 'يجب تحديد قرار الشكوى',
            'status.in'                 => 'القرار يجب أن يكون resolved أو dismissed',
            'penalty_percentage.numeric' => 'نسبة العقوبة يجب أن تكون رقماً',
            'penalty_percentage.max'    => 'نسبة العقوبة لا تتجاوز 100%',
        ];
    }
}
