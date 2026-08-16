<?php

namespace App\Http\Controllers;

use App\Services\FirebaseNotificationService;

class TestNotificationController extends Controller
{
    public function send(FirebaseNotificationService $firebase)
    {
        $user = auth()->user();

        if (!$user->fcm_token) {
            return response()->json([
                'message' => 'No FCM token found'
            ], 400);
        }

        $firebase->send(
            $user->fcm_token,
            'تجربة إشعار 🔔',
            'هذا إشعار تجريبي من Laravel',
            [
                'type' => 'test',
                'target_path' => 'notifications',
            ]
        );

        return response()->json([
            'message' => 'Notification sent successfully'
        ]);
    }
}
