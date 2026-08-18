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
        string $titleKey,
        string $messageKey,
        array $messageParams,
        string $targetPath,
        ?int $relatedId = null
    ): void {
        $admin = $this->getAdmin();

        if (!$admin) {
            return;
        }

        Notification::create([
            'user_id'     => $admin->id,
            'title'       => json_encode(['key' => $titleKey]),
            'message'     => json_encode(['key' => $messageKey, 'params' => $messageParams]),
            'type'        => $type,
            'target_path' => $targetPath,
            'related_id'  => $relatedId,
            'is_read'     => false,
        ]);
    }

    public function newUser(User $user): void
    {
        $this->notifyAdmin(
            type: 'new_user',
            titleKey: 'notifications.new_user_title',
            messageKey: 'notifications.new_user_message',
            messageParams: ['name' => $user->name],
            targetPath: 'users',
            relatedId: $user->id,
        );
    }

    public function newContractor(User $contractor): void
    {
        $this->notifyAdmin(
            type: 'new_contractor',
            titleKey: 'notifications.new_contractor_title',
            messageKey: 'notifications.new_contractor_message',
            messageParams: ['name' => $contractor->name],
            targetPath: 'requests',
            relatedId: $contractor->id,
        );
    }

    public function newInspectionRequest(int $inspectionRequestId, string $contractorName, string $requestTitle): void
    {
        $this->notifyAdmin(
            type: 'inspection_request',
            titleKey: 'notifications.inspection_request_title',
            messageKey: 'notifications.inspection_request_message',
            messageParams: ['contractor_name' => $contractorName, 'request_title' => $requestTitle],
            targetPath: 'inspection_requests',
            relatedId: $inspectionRequestId,
        );
    }

    public function newComplaint(int $complaintId, string $complainantName): void
    {
        $this->notifyAdmin(
            type: 'complaint',
            titleKey: 'notifications.complaint_title',
            messageKey: 'notifications.complaint_message',
            messageParams: ['name' => $complainantName],
            targetPath: 'complaints',
            relatedId: $complaintId,
        );
    }

    public function newNoShowWarning(int $warningId, string $reporterName): void
    {
        $this->notifyAdmin(
            type: 'complaint',
            titleKey: 'notifications.no_show_warning_title',
            messageKey: 'notifications.no_show_warning_message',
            messageParams: [
                'name' => $reporterName,
            ],
            targetPath: 'complaints',
            relatedId: $warningId,
        );
    }

    public function newPayment(int $paymentId, string $userName, float $amount): void
    {
        $this->notifyAdmin(
            type: 'payment',
            titleKey: 'notifications.payment_title',
            messageKey: 'notifications.payment_message',
            messageParams: ['name' => $userName, 'amount' => $amount],
            targetPath: 'userpayments',
            relatedId: $paymentId,
        );
    }

    public function engineerAcceptedVisit(int $visitId, string $engineerName): void
    {
        $this->notifyAdmin(
            type: 'inspection_request',
            titleKey: 'notifications.engineer_accepted_visit_title',
            messageKey: 'notifications.engineer_accepted_visit_message',
            messageParams: [
                'name' => $engineerName,
                'id'   => $visitId,
            ],
            targetPath: 'inspection_requests',
            relatedId: $visitId,
        );
    }

    public function engineerRejectedVisit(int $visitId, string $engineerName): void
    {
        $this->notifyAdmin(
            type: 'inspection_request',
            titleKey: 'notifications.engineer_rejected_visit_title',
            messageKey: 'notifications.engineer_rejected_visit_message',
            messageParams: [
                'name' => $engineerName,
                'id'   => $visitId,
            ],
            targetPath: 'inspection_requests',
            relatedId: $visitId,
        );
    }

    public function newFoundationVerification(int $verificationId, string $foundationName, string $userName): void
    {
        $this->notifyAdmin(
            type: 'foundation',
            titleKey: 'notifications.foundation_verification_title',
            messageKey: 'notifications.foundation_verification_message',
            messageParams: [
                'foundation_name' => $foundationName,
                'user_name'       => $userName,
            ],
            targetPath: 'verification_requests',
            relatedId: $verificationId,
        );
    }
}