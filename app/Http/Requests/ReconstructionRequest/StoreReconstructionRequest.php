<?php

namespace App\Http\Requests\ReconstructionRequest;

use Illuminate\Foundation\Http\FormRequest;

class StoreReconstructionRequest extends FormRequest
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
            'title' => 'required|string|max:255',

            'description' => 'required|string',

            'location' => 'required|string',

            'type' => 'required|in:restoration,construction,finishing',

            'images' => 'required|array',

            'images.*' => 'image|mimes:jpg,jpeg,png|max:2048',
        ];
    }
}
