<?php

namespace App\Services;

use App\Models\Notification;
use App\Models\User;

class NotificationService
{
    private function getAdmin(): ?User
    {
        return User::whereHas('role', fn($q) => $q->where('name', 'admin'))->first();
    }

    public function notifyAdmin(
        string $type,
        string $title,
        string $message,
        string $targetPath,
        ?int $relatedId = null
    ): void {
        $admin = $this->getAdmin();

        if (!$admin) return;

        Notification::create([
            'user_id'     => $admin->id,
            'title'       => $title,
            'message'     => $message,
            'type'        => $type,
            'target_path' => $targetPath,
            'related_id'  => $relatedId,
            'is_read'     => false,
        ]);
    }

    // ── Specific notification methods ─────────────────

    public function newUser(User $user): void
    {
        $this->notifyAdmin(
            type: 'new_user',
            title: 'مستخدم جديد',
            message: "انضم مستخدم جديد إلى المنصة: {$user->name}",
            targetPath: 'users',
            relatedId: $user->id,
        );
    }

    public function newContractor(User $contractor): void
    {
        $this->notifyAdmin(
            type: 'new_contractor',
            title: 'متعهد جديد يطلب الموافقة',
            message: "تقدّم متعهد جديد للتسجيل: {$contractor->name}، يرجى مراجعة طلبه",
            targetPath: 'requests',
            relatedId: $contractor->id,
        );
    }

    public function newInspectionRequest(int $inspectionRequestId, string $contractorName, string $requestTitle): void
    {
        $this->notifyAdmin(
            type: 'inspection_request',
            title: 'طلب زيارة ميدانية جديد',
            message: "أرسل المتعهد {$contractorName} طلب زيارة ميدانية للطلب: {$requestTitle}",
            targetPath: 'inspection_requests',
            relatedId: $inspectionRequestId,
        );
    }

    public function newComplaint(int $complaintId, string $complainantName): void
    {
        $this->notifyAdmin(
            type: 'complaint',
            title: 'شكوى جديدة',
            message: "قدّم {$complainantName} شكوى جديدة تتطلب المراجعة",
            targetPath: 'complaints',
            relatedId: $complaintId,
        );
    }

    public function newNoShowWarning(int $warningId, string $reporterName): void
    {
        $this->notifyAdmin(
            type: 'complaint',
            title: 'تحذير غياب جديد',
            message: "أبلغ {$reporterName} عن غياب في زيارة ميدانية",
            targetPath: 'complaints',
            relatedId: $warningId,
        );
    }

    public function newPayment(int $paymentId, string $userName, float $amount): void
    {
        $this->notifyAdmin(
            type: 'payment',
            title: 'دفعة جديدة',
            message: "أجرى {$userName} دفعة بقيمة {$amount}",
            targetPath: 'userpayments',
            relatedId: $paymentId,
        );
    }
    public function engineerAcceptedVisit(int $visitId, string $engineerName): void
    {
        $this->notifyAdmin(
            type: 'inspection_request',
            title: 'مهندس قبل الزيارة الميدانية',
            message: "قبل المهندس {$engineerName} الزيارة الميدانية رقم ({$visitId})",
            targetPath: 'inspection_requests',
            relatedId: $visitId,
        );
    }

    public function engineerRejectedVisit(int $visitId, string $engineerName): void
    {
        $this->notifyAdmin(
            type: 'inspection_request',
            title: 'مهندس رفض الزيارة الميدانية',
            message: "رفض المهندس {$engineerName} الزيارة الميدانية رقم ({$visitId})، يرجى تعيين مهندس بديل",
            targetPath: 'inspection_requests',
            relatedId: $visitId,
        );
    }
}
