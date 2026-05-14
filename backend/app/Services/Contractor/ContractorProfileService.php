<?php

namespace App\Services\Contractor;

use App\Models\ContractorProfile;

class ContractorProfileService
{
    public function store($request)
    {
        $data = [

            'user_id' => auth()->id(),

            'first_name' => $request->first_name,

            'last_name' => $request->last_name,

            'phone' => $request->phone,

            'location' => $request->location,

            'company_name' => $request->company_name,
        ];

        // صورة البروفايل
        if ($request->hasFile('image')) {

            $data['image'] = $request
                ->file('image')
                ->store('contractors', 'public');
        }

        // السجل التجاري
        $data['commercial_record'] = $request
            ->file('commercial_record')
            ->store(
                'commercial-records',
                'public'
            );

        return ContractorProfile::create($data);
    }
}
