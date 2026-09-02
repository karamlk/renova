<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class EngineerAccountCreated extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public string $email;
    public string $password;

    public function __construct(
        string $email,
        string $password
    ) {
        $this->email = $email;
        $this->password = $password;
    }

    public function build()
    {
        return $this
            ->subject('تم إنشاء حساب المهندس في منصة ReNova')
            ->view('emails.engineer-account');
    }
}
