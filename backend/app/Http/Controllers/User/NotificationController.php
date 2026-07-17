<?php

namespace App\Http\Controllers\User;

use App\Http\Controllers\Controller;
use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    public function index()
    {
        return Notification::where(
            'user_id',
            auth()->id()
        )
            ->latest()
            ->get();
    }

    public function unreadCount()
    {
        return response()->json([

            'count' => Notification::where(
                'user_id',
                auth()->id()
            )
                ->where(
                    'is_read',
                    false
                )
                ->count()

        ]);
    }

    public function markAllRead()
    {
        Notification::where(
            'user_id',
            auth()->id()
        )->update([

            'is_read' => true

        ]);

        return response()->json([
            'message' =>
                'تمت قراءة الإشعارات'
        ]);
    }
}
