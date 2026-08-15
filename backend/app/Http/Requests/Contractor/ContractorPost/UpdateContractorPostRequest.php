<?php

namespace App\Http\Requests\Contractor\ContractorPost;

use Illuminate\Foundation\Http\FormRequest;

class UpdateContractorPostRequest extends FormRequest
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
            'description' => ['sometimes', 'string'],
            'status' => ['sometimes', 'in:completed,in_progress'],
            'progress' => ['sometimes', 'nullable', 'integer', 'min:0', 'max:100'],
            'images' => ['sometimes', 'array'],
            'images.*' => ['image', 'max:5120'],
        ];

    }
}
