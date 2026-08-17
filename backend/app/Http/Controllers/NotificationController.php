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

        $transformed = $notifications->through(function ($notification) {
            return [
                'id'          => $notification->id,
                'user_id'     =>   Auth::id(),
                'is_read'     => (bool) $notification->is_read,
                'type'        => $notification->type,
                'target_path' => $notification->target_path,
                'related_id'  => $notification->related_id,
                'created_at'  => $notification->created_at ? $notification->created_at->format('Y-m-d H:i') : null,

                'ar' => [
                    'title'   => $this->translateField($notification->title, 'ar'),
                    'message' => $this->translateField($notification->message, 'ar'),
                ],
                'en' => [
                    'title'   => $this->translateField($notification->title, 'en'),
                    'message' => $this->translateField($notification->message, 'en'),
                ],
            ];
        });

        return response()->json($transformed, 200);
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

    protected function translateField(?string $rawField, string $lang): ?string
    {
        if (empty($rawField)) {
            return null;
        }

        $decoded = json_decode($rawField, true);

        if (json_last_error() === JSON_ERROR_NONE && is_array($decoded) && isset($decoded['key'])) {
            $key = $decoded['key'];
            $params = $decoded['params'] ?? [];

            return __($key, $params, $lang);
        }

        return $rawField;
    }
}
