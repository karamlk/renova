<?php

namespace App\Http\Requests\Engineer;


use Illuminate\Foundation\Http\FormRequest;

class EngineerReviewRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'status'         => 'required|in:engineer_approved,engineer_rejected',
            'engineer_notes' => 'required_if:status,engineer_rejected|string|nullable|min:5',
        ];
    }
}
