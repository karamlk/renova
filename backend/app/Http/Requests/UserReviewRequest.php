<?php

namespace App\Http\Requests;


use Illuminate\Foundation\Http\FormRequest;

class UserReviewRequest extends FormRequest
{
    public function authorize(): bool { return true; }

    public function rules(): array
    {
        return [
            'status'     => 'required|in:user_approved,user_rejected',
            'user_notes' => 'nullable|string',
        ];
    }
}
