<?php
namespace App\Http\Requests\Engineer;

use Illuminate\Foundation\Http\FormRequest;

class UpdateEngineerProfileRequest extends FormRequest {
    public function authorize(): bool { return true; }

    public function rules(): array {
        return [
            'first_name'           => 'required|string|max:100',
            'last_name'            => 'required|string|max:100',
            'phone'                => 'required|string',
            'location'             => 'required|string',
            'specialization'       => 'required|string',
            'syndicate_number'     => 'required|string|unique:engineer_profiles,syndicate_number,' . $this->user()->engineerProfile->id,
            'degree'               => 'required|string',
            'years_of_experience'  => 'required|integer|min:0',
            'covered_zones'        => 'required|string',
            'bio'                  => 'nullable|string',
            'image'                => 'nullable|image|max:2048', // صوره البروفايل العادي
            'syndicate_card_image' => 'nullable|image|max:2048', // صورة بطاقة النقابة
            'certificate_file'     => 'nullable|file|mimes:pdf,jpg,png|max:5120',
        ];
    }
}
