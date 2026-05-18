<?php

namespace App\Services\Contractor;

use App\Models\ContractorPost;
use App\Models\ContractorPostImage;

class ContractorPostService
{
    public function store($request)
    {
        $progress =
            $request->status === 'completed'
                ? 100
                : $request->progress;

        $post = ContractorPost::create([

            'user_id' => auth()->id(),

            'title' => $request->title,

            'description' => $request->description,

            'status' => $request->status,

            'progress' => $progress,
        ]);

        foreach ($request->file('images') as $image) {

            $path = $image->store(
                'contractor-posts',
                'public'
            );

            ContractorPostImage::create([

                'contractor_post_id' => $post->id,

                'image' => $path,
            ]);
        }

        return $post->load([
            'images',
            'user.contractorProfile'
        ]);
    }

    public function index()
    {
        return ContractorPost::with([
            'images',
            'user.contractorProfile'
        ])->latest()->get();
    }

    public function show($id)
    {
        return ContractorPost::with([
            'images',
            'user.contractorProfile'
        ])->findOrFail($id);
    }

    // كل بوستات متعهد معين
    public function contractorPosts($contractorId)
    {
        return ContractorPost::with([
            'images',
            'user.contractorProfile'
        ])
            ->where('user_id', $contractorId)
            ->latest()
            ->get();
    }
    public function update($request, $id)
    {
        $post = ContractorPost::findOrFail($id);

        // حماية
        if ($post->user_id !== auth()->id()) {

            throw new \Exception(
                'غير مصرح لك'
            );
        }

        $data = $request->validated();

        // completed => progress = 100
        if (
            isset($data['status'])
            && $data['status'] === 'completed'
        ) {

            $data['progress'] = 100;
        }

        $post->update($data);

        // إذا رفع صور جديدة
        if ($request->hasFile('images')) {

            foreach (
                $request->file('images')
                as $image
            ) {

                $path = $image->store(
                    'contractor-posts',
                    'public'
                );

                ContractorPostImage::create([

                    'contractor_post_id' =>
                        $post->id,

                    'image' => $path,
                ]);
            }
        }

        return $post->load([
            'images',
            'user.contractorProfile'
        ]);
    }
    public function delete($id)
    {
        $post = ContractorPost::findOrFail($id);

        // حماية
        if ($post->user_id !== auth()->id()) {

            throw new \Exception(
                'غير مصرح لك'
            );
        }

        $post->delete();
    }
}
