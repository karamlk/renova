<?php

namespace App\Mail;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class ContractorRejectedMail extends Mailable
{
    use Queueable, SerializesModels;

    public $user;

    public function __construct(
        User $user
    ) {
        $this->user = $user;
    }

    public function build()
    {
        return $this->subject(
            'تم رفض تسجليك في المنصة راجع معلوماتك الشخصية و حاول مرة اخرى '
        )
            ->view(
                'emails.contractor-approved'
            );
    }
    public function envelope(): Envelope
    {
        return new Envelope(
            subject: 'Contractor Rejected Mail',
        );
    }

    /**
     * Get the message content definition.
     */
    public function content(): Content
    {
        return new Content(
            view: 'view.name',
        );
    }

    /**
     * Get the attachments for the message.
     *
     * @return array<int, \Illuminate\Mail\Mailables\Attachment>
     */
    public function attachments(): array
    {
        return [];
    }
}
