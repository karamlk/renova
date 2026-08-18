<?php

namespace App\Listeners;

use App\Events\AppEvent;
use App\Models\Notification;
use Illuminate\Support\Facades\Log;

class StoreNotification
{
    public function handle(AppEvent $event): void
    {
        Notification::create([
            'user_id' => $event->userId,
            'title' => $event->title,
            'message' => $event->message,
            'type' => $event->type,
            'target_path' => $event->targetPath,
            'related_id' => $event->relatedId,
        ]);
        Log::info('StoreNotification HANDLE', [
            'user_id' => $event->userId,
            'type' => $event->type,
            'related_id' => $event->relatedId,
        ]);
    }
}
