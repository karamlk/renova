<?php

namespace App\Http\Requests\Contractor\Schedule;

use Illuminate\Foundation\Http\FormRequest;

class UpdateRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [

            'day_of_week' => [
                'sometimes',
                'in:sunday,monday,tuesday,wednesday,thursday,friday,saturday'
            ],

            'start_time' => [
                'sometimes',
                'date_format:h:i A'
            ],

            'end_time' => [
                'sometimes',
                'date_format:h:i A'
            ]
        ];
    }
}
