<?php

namespace App\Http\Requests\Engineer;

use Illuminate\Foundation\Http\FormRequest;

class UpdateEngineerProfileRequest extends FormRequest {
    public function authorize(): bool {
        return true;
    }

    public function rules(): array {
        // جلب الـ ID الخاص بالمستخدم الحالي المسجل دخول لمنع مشاكل الـ null
        $userId = $this->user()?->id;

        return [
            'first_name'           => 'required|string|max:100',
            'last_name'            => 'required|string|max:100',
            'phone'                => 'required|string',
            'location'             => 'required|string',
            'specialization'       => 'required|string',

            // تم التعديل هنا ليفحص العمود بناءً على user_id الحالي لتجنب الخطأ تماماً
            'syndicate_number'     => 'required|string|unique:engineer_profiles,syndicate_number,' . $userId . ',user_id',

            'degree'               => 'required|string',
            'years_of_experience'  => 'required|integer|min:0',
            'covered_zones'        => 'required|string',
            'bio'                  => 'nullable|string',
            'image'                => 'nullable|image|max:2048',
            'syndicate_card_image' => 'nullable|image|max:2048',
            'certificate_file'     => 'nullable|file|mimes:pdf,jpg,png|max:5120',
        ];
    }
}
