<?php

namespace App\Http\Requests\User;

use Illuminate\Foundation\Http\FormRequest;

class AcceptInspectionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'inspection_request_id' => [
                'required',
                'exists:inspection_requests,id'
            ],

            'schedule_id' => [
                'required',
                'exists:contractor_schedules,id'
            ],
        ];
    }
}
