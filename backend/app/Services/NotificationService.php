<?php

namespace App\Services;

use App\Models\Notification;

class NotificationService
{
    public function send(

        int $userId,

        string $title,

        string $message,

        string $type = 'general',

        ?int $relatedId = null,

        ?int $constructionFormId = null

    ): Notification {

        return Notification::create([

            'user_id' => $userId,

            'title' => $title,

            'message' => $message,

            'type' => $type,

            'related_id' => $relatedId,

            'construction_form_id' => $constructionFormId,

            'is_read' => false

        ]);
    }
}
