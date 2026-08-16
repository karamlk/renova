<?php

namespace App\Http\Requests\Contractor\ConstructionForm;


use Illuminate\Foundation\Http\FormRequest;

class StoreConstructionFormRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'reconstruction_request_id' => 'required|exists:reconstruction_requests,id',
            'contractor_id'             => 'required|exists:users,id',
            'engineer_id'               => 'required|exists:users,id',
            'building_description'      => 'required|string|min:10',
            'warranty_period' => [
                'required',
                'string',
                'regex:/^\s*\d+\s*(months?|years?|weeks?|اشهر|أشهر|شهر|شهور|سنوات|عام|أعوام|اسبوع|أسبوع|اسابيع|أسابيع)\s*$/iu',
            ],

            'execution_duration' => [
                'required',
                'string',
                'regex:/^\s*\d+\s*(months?|years?|weeks?|اشهر|أشهر|شهر|شهور|سنوات|عام|أعوام|اسبوع|أسبوع|اسابيع|أسابيع)\s*$/iu',
            ],
            'materials_cost'            => 'required|numeric|min:0',
            'labor_cost'                => 'required|numeric|min:0',
            'profit'                    => 'required|numeric|min:0',
            'pdf_file'                  => 'nullable|file|mimes:pdf|max:5120',
        ];
    }
    
    public function messages(): array
    {
        return [
            'warranty_period.regex' =>
            'صيغة فترة الضمان غير صحيحة. مثال: 3 أشهر أو 6 months أو سنة.',

            'execution_duration.regex' =>
            'صيغة مدة التنفيذ غير صحيحة. مثال: 3 أشهر أو 6 months أو سنة.',
        ];
    }
}
