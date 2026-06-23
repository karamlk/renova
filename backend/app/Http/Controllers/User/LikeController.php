<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Models\ContractorPost;
use App\Services\User\likeServices;
use Symfony\Component\HttpFoundation\JsonResponse;

class LikeController extends Controller
{
    //
    public function __construct(
        protected likeServices $likeService
    )
    {

    }
    public function toggleLike(
        ContractorPost $post
    ): JsonResponse
    {
        return response()->json(

            $this->likeService
                ->toggleLike($post->id)
        );
    }
}
