<?php

namespace App\Http\Requests\User\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class OtpMail extends Mailable
{
    use Queueable, SerializesModels;

    public $code;

    public function __construct($code)
    {
        $this->code = $code;
    }

    public function build()
    {
        return $this->subject('رمز التحقق OTP')
            ->view('emails.otp')
            ->with(['code' => $this->code]);
    }
}
