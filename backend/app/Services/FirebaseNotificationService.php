<?php

namespace App\Services;

use App\Models\User;
use Kreait\Firebase\Contract\Messaging;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification;

class FirebaseNotificationService
{
    public function __construct(
        private Messaging $messaging
    ) {}

    // إرسال لمستخدم مباشرة
    public function sendToUser(
        User $user,
        string $title,
        string $body
    ): void {

        if (!$user->fcm_token) {
            return;
        }

        $notification = Notification::create(
            $title,
            $body
        );

        $message = CloudMessage::withTarget(
            'token',
            $user->fcm_token
        )->withNotification(
            $notification
        );

        $this->messaging->send($message);
    }
}

//app(FirebaseNotificationService::class)->sendToUser(
//    $user,
//    'تم قبول الطلب',
//    'تم قبول طلب إعادة الإعمار الخاص بك.'
//);
