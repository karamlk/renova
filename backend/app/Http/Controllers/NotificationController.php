<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class NotificationController extends Controller
{
    public function index()
    {
        $notifications = Notification::where('user_id', Auth::id())
            ->latest()
            ->paginate(10);

        return response()->json(['data' => $notifications]);
    }

    public function unreadCount()
    {
        $count = Notification::where('user_id', Auth::id())
            ->where('is_read', false)
            ->count();

        return response()->json(['count' => $count]);
    }

    public function markAllRead()
    {
        Notification::where('user_id', Auth::id())
            ->where('is_read', false)
            ->update(['is_read' => true]);

        return response()->json([
            'message' => 'تم تحديد جميع الإشعارات كمقروءة'
        ]);
    }

    public function markRead(Notification $notification)
    {
        abort_if(
            $notification->user_id !== Auth::id(),
            403,
            'غير مصرح لك بتعديل هذا الإشعار'
        );

        $notification->update(['is_read' => true]);

        return response()->json([
            'message' => 'تم تحديد الإشعار كمقروء',
            'data'    => $notification,
        ]);
    }
    public function destroyAll()
    {
        Notification::where('user_id', Auth::id())->delete();

        return response()->json([
            'message' => 'تم حذف جميع الإشعارات بنجاح'
        ]);
    }
}
