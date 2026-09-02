<?php

namespace App\Http\Requests\User\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class ContractorApprovedMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public $user;

    public function __construct(User $user)
    {
        $this->user = $user;
    }

    public function build()
    {
        return $this->subject(
            'تم قبول طلبك يمكنك الان تسجيل الدخول '
        )
            ->view(
                'emails.contractor-approved'
            );
    }
}
