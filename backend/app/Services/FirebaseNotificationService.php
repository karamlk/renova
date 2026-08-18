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
               base_path(env('FIREBASE_CREDENTIALS','backend/firebase/firebase-credentials.json'))
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
            ->withToken($token)
            ->withNotification(
                FirebaseNotification::create($title, $body)
            )
            ->withData($data);

        return $this->messaging->send($message);
    }
}
//
//namespace App\Services;
//
//use App\Models\User;
//use Kreait\Firebase\Contract\Messaging;
//use Kreait\Firebase\Messaging\CloudMessage;
//use Kreait\Firebase\Messaging\Notification;
//
//class FirebaseNotificationService
//{
//    public function __construct(
//        private Messaging $messaging
//    ) {}
//
//    // إرسال لمستخدم مباشرة
//    public function sendToUser(
//        User $user,
//        string $title,
//        string $body
//    ): void {
//
//        if (!$user->fcm_token) {
//            return;
//        }
//
//        $notification = Notification::create(
//            $title,
//            $body
//        );
//
//        $message = CloudMessage::withTarget(
//            'token',
//            $user->fcm_token
//        )->withNotification(
//            $notification
//        );
//
//        $this->messaging->send($message);
//    }
//}

//app(FirebaseNotificationService::class)->sendToUser(
//    $user,
//    'تم قبول الطلب',
//    'تم قبول طلب إعادة الإعمار الخاص بك.'
//);
//$user = $request->user;
//
//if ($user?->fcm_token) {
//    app(FirebaseNotificationService::class)->send(
//        $user->fcm_token,
//        'تم قبول طلبك',
//        'تم قبول طلب إعادة الإعمار الخاص بك.'
//    );
//}

