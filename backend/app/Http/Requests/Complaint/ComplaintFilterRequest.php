<?php

namespace App\Http\Requests\Complaint;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class ComplaintFilterRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'type' => [
                'nullable',
                Rule::in([
                    'general',
                    'no_show',
                ]),
            ],

            'complained_on_role' => [
                'nullable',
                'string',
                'regex:/^(user|contractor|engineer)(,(user|contractor|engineer))*$/',
            ],
        ];
    }

    public function messages(): array
    {
        return [
            'type.in' => 'نوع الشكاوي غير صالح',

            'complained_on_role.regex' => 'يجب أن تكون الأدوار: مستخدم، مقاول، أو مهندس مفصولة بفواصل.',

        ];
    }
}