<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    //
    public function index()
    {
        return response()->json(

            auth()->user()

                ->notifications()

                ->latest()

                ->get()

        );
    }
    public function markAsRead(
        Notification $notification
    )
    {
        if (

            $notification->user_id

            != auth()->id()

        ) {

            abort(403);

        }

        $notification->update([

            'is_read' => true

        ]);

        return response()->json([

            'message' =>

                'تمت قراءة الإشعار'

        ]);
    }

}
