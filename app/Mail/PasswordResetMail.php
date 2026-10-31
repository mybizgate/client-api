<?php

namespace App\Mail;

use App\Models\Site;
use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

/** Password-reset link for an owner/staff login (API_CONTRACT §2). */
class PasswordResetMail extends Mailable
{
    use Queueable, SerializesModels;

    public function __construct(
        public readonly User $user,
        public readonly Site $site,
        public readonly string $url,
        public readonly int $ttlMinutes,
    ) {}

    public function envelope(): Envelope
    {
        return new Envelope(subject: "Tetapan semula kata laluan – {$this->site->site_name}");
    }

    public function content(): Content
    {
        return new Content(view: 'mail.password-reset', text: 'mail.password-reset-text');
    }
}
