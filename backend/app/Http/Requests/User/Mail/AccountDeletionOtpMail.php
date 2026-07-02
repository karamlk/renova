<?php

namespace App\Http\Requests\User\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class AccountDeletionOtpMail extends Mailable
{
    use Queueable, SerializesModels;

    public String $userName;
    public String $otp;

    public function __construct(String $userName, String $otp)
    {
        $this->userName = $userName;
        $this->otp = $otp;
    }

    public function build()
    {
        return $this->subject('Confirm Account Deletion')
            ->view('emails.account_deletion_otp')
            ->with([
                'userName' => $this->userName,
                'otp' => $this->otp,
            ]);
    }
}
