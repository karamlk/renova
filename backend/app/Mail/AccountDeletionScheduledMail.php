<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class AccountDeletionScheduledMail extends Mailable
{
    use Queueable, SerializesModels;

    public string $userName;
    public string $scheduledDate;

    public function __construct(string $userName, string $scheduledDate)
    {
        $this->userName = $userName;
        $this->scheduledDate = $scheduledDate;
    }

    public function build()
    {
        return $this->subject('Account Scheduled for Deletion')
            ->view('emails.account_deletion_scheduled')
            ->with([
                'userName' => $this->userName,
                'scheduledDate' => $this->scheduledDate,
            ]);
    }
}
