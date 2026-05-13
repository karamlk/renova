<?php

namespace App\Services\User;

use App\Models\ReconstructionRequest;
use App\Models\ReconstructionRequestImage;

class ReconstructionRequestService
{
    public function store($request)
    {
        $reconstructionRequest =
            ReconstructionRequest::create([

                'user_id' => auth()->id(),

                'title' => $request->title,

                'description' => $request->description,

                'location' => $request->location,

                'type' => $request->type,
            ]);

        $this->storeImages(
            $request,
            $reconstructionRequest
        );

        return $reconstructionRequest->load('images');
    }

    private function storeImages(
        $request,
        $reconstructionRequest
    ): void
    {
        foreach ($request->file('images') as $image) {

            $path = $image->store(
                'reconstruction-requests',
                'public'
            );

            ReconstructionRequestImage::create([

                'reconstruction_request_id'
                => $reconstructionRequest->id,

                'image' => $path,
            ]);
        }
    }
    public function index()
    {
        return ReconstructionRequest::with([
            'images',
            'user'
        ])->latest()->get();
    }

    public function show($id)
    {
        return ReconstructionRequest::with([
            'images',
            'user'
        ])->findOrFail($id);
    }

    public function update($request, $id)
    {
        $reconstructionRequest =
            ReconstructionRequest::findOrFail($id);


        if (
            $reconstructionRequest->user_id !== auth()->id()
        ) {
            throw new \Exception('غير مصرح');
        }

        $reconstructionRequest->update(
            $request->validated()
        );


        if ($request->hasFile('images')) {

            foreach ($request->file('images') as $image) {

                $path = $image->store(
                    'reconstruction-requests',
                    'public'
                );

                $reconstructionRequest
                    ->images()
                    ->create([
                        'image' => $path
                    ]);
            }
        }

        return $reconstructionRequest->load('images');
    }

    public function destroy($id): void
    {
        $reconstructionRequest =
            ReconstructionRequest::findOrFail($id);


        if (
            $reconstructionRequest->user_id !== auth()->id()
        ) {
            throw new \Exception('غير مصرح');
        }

        $reconstructionRequest->delete();
    }
}
