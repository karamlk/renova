<?php

namespace App\Http\Requests\Complaint;

use Illuminate\Foundation\Http\FormRequest;

class FileComplaintRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'complained_on_id'     => 'required|exists:users,id',
            'complained_on_role'   => 'required|in:user,contractor,engineer',
            'construction_form_id' => 'nullable|exists:construction_forms,id',
            'reason'               => 'required|string',
            'description'          => 'nullable|string|max:1000',
            'is_anonymous'         => 'boolean',
        ];
    }

    public function messages(): array
    {
        return [
            'complained_on_id.required'   => 'يجب تحديد الشخص المشكو عليه',
            'complained_on_id.exists'     => 'المستخدم المشكو عليه غير موجود',
            'complained_on_role.required' => 'يجب تحديد دور الشخص المشكو عليه',
            'complained_on_role.in'       => 'الدور غير صالح',
            'reason.required'             => 'يجب اختيار سبب الشكوى',
        ];
    }
}
