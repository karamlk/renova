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
            'construction_form_id' => 'required|exists:construction_forms,id',
            'reason'               => 'required|string|max:255',
            'description'          => 'nullable|string|max:1000',
            'images' => 'nullable|array',
            'images.*' => 'image|mimes:jpg,jpeg,png|max:2048',
        ];
    }

    public function messages(): array
    {
        return [
            'construction_form_id.required' => 'يجب تحديد المشروع المرتبط بالشكوى',
            'construction_form_id.exists'   => 'المشروع غير موجود',
            'reason.required'               => 'يجب كتابة سبب الشكوى',
            'reason.max'                    => 'سبب الشكوى طويل جداً',
        ];
    }
}
