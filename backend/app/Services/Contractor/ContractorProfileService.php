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
    public function show()
    {
        return auth()
            ->user()
            ->contractorProfile()
            ->with('user')
            ->first();
    }

    public function update($request)
    {
        $profile = auth()
            ->user()
            ->contractorProfile;

        $data = $request->validated();

        // تحديث الصورة
        if ($request->hasFile('image')) {

            $data['image'] = $request
                ->file('image')
                ->store('contractors', 'public');
        }

        // تحديث السجل التجاري
        if ($request->hasFile('commercial_record')) {

            $data['commercial_record'] = $request
                ->file('commercial_record')
                ->store(
                    'commercial-records',
                    'public'
                );

            // يرجع pending بعد تغيير السجل
            auth()->user()->update([
                'status' => 'pending'
            ]);
        }

        $profile->update($data);

        return $profile->load('user');
    }
}
