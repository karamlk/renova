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
        $admin = User::whereHas(
            'role',
            fn ($q) => $q->where('name', 'admin')
        )->first();

        if (!$admin) {
            return;
        }

        $user = User::where('email', 'seed_user@renova.com')->first();
        $contractor = User::where('email', 'seed_contractor@renova.com')->first();
        $engineer = User::where('email', 'seed_engineer@renova.com')->first();

        $inspection = InspectionRequest::first();
        $complaint = Complaint::first();
        $payment = Payment::first();

        // ─────────────────────────────────────────────
        // مستخدم جديد
        // ─────────────────────────────────────────────
        if ($user) {
            Notification::firstOrCreate(
                [
                    'user_id' => $admin->id,
                    'type' => 'new_user',
                    'related_id' => $user->id,
                ],
                [
                    'title' => 'مستخدم جديد',
                    'message' => "انضم مستخدم جديد إلى المنصة: {$user->name}",
                    'target_path' => 'users',
                    'is_read' => false,
                ]
            );
        }

        // ─────────────────────────────────────────────
        // متعهد جديد
        // ─────────────────────────────────────────────
        if ($contractor) {
            Notification::firstOrCreate(
                [
                    'user_id' => $admin->id,
                    'type' => 'new_contractor',
                    'related_id' => $contractor->id,
                ],
                [
                    'title' => 'متعهد جديد يطلب الموافقة',
                    'message' => "تقدّم متعهد جديد للتسجيل: {$contractor->name}، يرجى مراجعة طلبه",
                    'target_path' => 'requests',
                    'is_read' => false,
                ]
            );
        }

        // ─────────────────────────────────────────────
        // طلب زيارة ميدانية
        // ─────────────────────────────────────────────
        if ($inspection && $contractor) {
            Notification::firstOrCreate(
                [
                    'user_id' => $admin->id,
                    'type' => 'inspection_request',
                    'related_id' => $inspection->id,
                ],
                [
                    'title' => 'طلب زيارة ميدانية جديد',
                    'message' => "أرسل المتعهد {$contractor->name} طلب زيارة ميدانية",
                    'target_path' => 'inspection_requests',
                    'is_read' => false,
                ]
            );
        }

        // ─────────────────────────────────────────────
        // شكوى
        // ─────────────────────────────────────────────
        if ($complaint && $user) {
            Notification::firstOrCreate(
                [
                    'user_id' => $admin->id,
                    'type' => 'complaint',
                    'related_id' => $complaint->id,
                ],
                [
                    'title' => 'شكوى جديدة',
                    'message' => "قدّم {$user->name} شكوى جديدة تتطلب المراجعة",
                    'target_path' => 'complaints',
                    'is_read' => false,
                ]
            );
        }

        // ─────────────────────────────────────────────
        // تحذير غياب
        // ─────────────────────────────────────────────
        Notification::firstOrCreate(
            [
                'user_id' => $admin->id,
                'type' => 'complaint',
                'related_id' => 999,
            ],
            [
                'title' => 'تحذير غياب جديد',
                'message' => 'تم الإبلاغ عن غياب في زيارة ميدانية',
                'target_path' => 'complaints',
                'is_read' => false,
            ]
        );

        // ─────────────────────────────────────────────
        // دفعة جديدة
        // ─────────────────────────────────────────────
        if ($payment && $user) {
            Notification::firstOrCreate(
                [
                    'user_id' => $admin->id,
                    'type' => 'payment',
                    'related_id' => $payment->id,
                ],
                [
                    'title' => 'دفعة جديدة',
                    'message' => "أجرى {$user->name} دفعة بقيمة {$payment->amount}",
                    'target_path' => 'userpayments',
                    'is_read' => false,
                ]
            );
        }

        // ─────────────────────────────────────────────
        // مهندس قبل الزيارة
        // ─────────────────────────────────────────────
        if ($inspection && $engineer) {
            Notification::firstOrCreate(
                [
                    'user_id' => $admin->id,
                    'type' => 'inspection_request',
                    'related_id' => $inspection->id,
                ],
                [
                    'title' => 'مهندس قبل الزيارة الميدانية',
                    'message' => "قبل المهندس {$engineer->name} الزيارة الميدانية رقم ({$inspection->id})",
                    'target_path' => 'inspection_requests',
                    'is_read' => false,
                ]
            );
        }
    }
}