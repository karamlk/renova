<?php

namespace App\Http\Requests\User\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class OtpMail extends Mailable implements ShouldQueue
{
    use Queueable, SerializesModels;

    public function __construct(public string $code) {}

    public function build()
    {
        return $this
            ->subject('رمز التحقق OTP')
            ->text('emails.otp-plain', [
                'code' => $this->code,
            ]);
    }
}
