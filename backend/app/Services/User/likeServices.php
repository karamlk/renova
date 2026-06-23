<?php

namespace App\Services\User;

use App\Models\Like;

class likeServices
{
    public function toggleLike($postId)
    {
        $like = Like::where(
            'user_id',
            auth()->id()
        )
            ->where(
                'contractor_post_id',
                $postId
            )
            ->first();

        if ($like) {

            $like->delete();

            return [
                'liked' => false
            ];
        }

        Like::create([

            'user_id' => auth()->id(),

            'contractor_post_id' => $postId
        ]);

        return [
            'liked' => true
        ];
    }
}
