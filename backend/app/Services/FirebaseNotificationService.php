<?php

namespace App\Services;

use Kreait\Firebase\Factory;
use Kreait\Firebase\Messaging\CloudMessage;
use Kreait\Firebase\Messaging\Notification as FirebaseNotification;

class FirebaseNotificationService
{
    protected $messaging;

    public function __construct()
    {
        $factory = (new Factory)
            ->withServiceAccount(
                base_path('storage/firebase/firebase-credentials.json')
            );

        $this->messaging = $factory->createMessaging();
    }

    public function send(
        string $token,
        string $title,
        string $body,
        array $data = []
    ) {
        $message = CloudMessage::new()
            ->withChangedTarget('token', $token)
            ->withNotification(
                FirebaseNotification::create(
                    $title,
                    $body
                )
            );

        if (!empty($data)) {
            $message = $message->withData($data);
        }

        return $this->messaging->send($message);
    }
}