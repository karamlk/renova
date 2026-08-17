<?php

namespace Database\Seeders;

use App\Models\Notification;
use App\Models\User;
use App\Models\InspectionRequest;
use App\Models\Complaint;
use App\Models\Payment;
use Illuminate\Database\Seeder;

class NotificationSeeder extends Seeder
{
    public function run(): void
    {
        $admin = User::whereHas('role', fn($q) => $q->where('name', 'admin'))->first();
        if (!$admin) {
            return;
        }

        $user = User::where('email', 'seed_user@renova.com')->first();
        $contractor = User::where('email', 'seed_contractor@renova.com')->first();
        $inspection = InspectionRequest::first();
        $payment = Payment::first();

        if ($user) {
            Notification::firstOrCreate(
                ['user_id' => $admin->id, 'type' => 'new_user', 'related_id' => $user->id],
                [
                    'title' => json_encode(['key' => 'notifications.new_user_title']),
                    'message' => json_encode(['key' => 'notifications.new_user_message', 'params' => ['name' => $user->name]]),
                    'target_path' => 'users',
                    'is_read' => false,
                ]
            );
        }

        if ($contractor) {
            Notification::firstOrCreate(
                ['user_id' => $admin->id, 'type' => 'new_contractor', 'related_id' => $contractor->id],
                [
                    'title' => json_encode(['key' => 'notifications.new_contractor_title']),
                    'message' => json_encode(['key' => 'notifications.new_contractor_message', 'params' => ['name' => $contractor->name]]),
                    'target_path' => 'requests',
                    'is_read' => false,
                ]
            );
        }

        // Attendance No-Show Warning Alert
        Notification::firstOrCreate(
            [
                'user_id'    => $admin->id,
                'type'       => 'complaint',
                'related_id' => 999,
                'title'      => json_encode(['key' => 'notifications.no_show_warning_title']),
            ],
            [
                'message'     => json_encode([
                    'key'    => 'notifications.no_show_warning_message',
                    'params' => ['name' => 'PlatformEngine'],
                ]),
                'target_path' => 'complaints',
                'is_read'     => false,
            ]
        );
        
        if ($payment && $user) {
            Notification::firstOrCreate(
                ['user_id' => $admin->id, 'type' => 'payment', 'related_id' => $payment->id],
                [
                    'title' => json_encode(['key' => 'notifications.payment_title']),
                    'message' => json_encode(['key' => 'notifications.payment_message', 'params' => ['name' => $user->name, 'amount' => $payment->amount]]),
                    'target_path' => 'userpayments',
                    'is_read' => false,
                ]
            );
        }

        $engineer = User::where('email', 'seed_engineer@renova.com')->first();

     // Engineer Accepted Visit
        if ($inspection && $engineer) {
            Notification::firstOrCreate(
                [
                    'user_id'    => $admin->id,
                    'type'       => 'inspection_request',
                    'related_id' => $inspection->id,
                    'title'      => json_encode(['key' => 'notifications.engineer_accepted_visit_title']),
                ],
                [
                    'message'     => json_encode([
                        'key'    => 'notifications.engineer_accepted_visit_message',
                        'params' => ['name' => $engineer->name, 'id' => $inspection->id],
                    ]),
                    'target_path' => 'inspection_requests',
                    'is_read'     => false,
                ]
            );
        }

        // Engineer Rejected Visit
        if ($inspection && $engineer) {
            Notification::firstOrCreate(
                [
                    'user_id'    => $admin->id,
                    'type'       => 'inspection_request',
                    'related_id' => $inspection->id,
                    'title'      => json_encode(['key' => 'notifications.engineer_rejected_visit_title']),
                ],
                [
                    'message'     => json_encode([
                        'key'    => 'notifications.engineer_rejected_visit_message',
                        'params' => ['name' => $engineer->name, 'id' => $inspection->id],
                    ]),
                    'target_path' => 'inspection_requests',
                    'is_read'     => false,
                ]
            );
        }
    }
}