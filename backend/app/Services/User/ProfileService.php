<?php


namespace App\Services\User;
use App\Models\UserProfile;

class ProfileService{

    public function store($request)
    {
        $imagePath = $this->uploadImage($request);

        return UserProfile::create([

            'user_id' => auth()->id(),

            'first_name' => $request->first_name,

            'last_name' => $request->last_name,

            'phone' => $request->phone,

            'image' => $imagePath,

            'location' => $request->location,
        ]);
    }

    public function show()
    {
        $user = auth()->user()->load('profile','role');

//        if ($user->profile && $user->profile->image) {
//            $user->profile->image = asset('storage/' . $user->profile->image);
//        }

        return $user;
    }
    public function update($request)
    {
        $profile = auth()->user()->profile;

        $data = $request->validated();

        if ($request->hasFile('image')) {

            $data['image'] = $this->uploadImage($request);
        }
        $profile->update($data);

//        $profile->image = $profile->image
//            ? asset('storage/' . $profile->image)
//            : null;

        return $profile;
    }

    private function uploadImage($request): ?string
    {
        if (! $request->hasFile('image')) {
            return null;
        }

        return $request->file('image')
            ->store('profiles', 'public');
    }
}
