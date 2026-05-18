<?php

namespace App\Http\Requests\Contractor\profile;

use Illuminate\Foundation\Http\FormRequest;

class UpdateContractorProfileRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array<string, \Illuminate\Contracts\Validation\ValidationRule|array<mixed>|string>
     */
    public function rules(): array
    {
        return [
            //
            'first_name' => 'sometimes|string|max:255',

            'last_name' => 'sometimes|string|max:255',

            'phone' => 'nullable|string',

            'image' => 'nullable|image',

            'location' => 'nullable|string',

            'company_name' => 'sometimes|string|max:255',

            'commercial_record' =>
                'nullable|file|mimes:pdf,jpg,jpeg,png',
        ];
    }
}
