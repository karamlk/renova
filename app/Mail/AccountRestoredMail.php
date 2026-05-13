<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class AccountRestoredMail extends Mailable
{
    use Queueable, SerializesModels;

    public string $userName;

    public function __construct(string $userName)
    {
        $this->userName = $userName;
    }

    public function build()
    {
        return $this->subject('Account Restored')
            ->view('emails.account_restored')
            ->with(['userName' => $this->userName]);
    }
}
