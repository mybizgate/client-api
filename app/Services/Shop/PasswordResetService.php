<?php

namespace App\Services\Shop;

use App\Mail\PasswordResetMail;
use App\Models\PasswordResetToken;
use App\Models\Site;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Validation\ValidationException;

/**
 * Tenant-aware password reset for owner/staff logins. The stock Password
 * broker keys on e-mail, but e-mails are only unique per site, so this
 * service owns `password_reset_tokens` (keyed by user) instead.
 *
 * The raw token travels only in the e-mail link; the table stores its
 * SHA-256. One outstanding token per user; a new request replaces it.
 */
class PasswordResetService
{
    public const string INVALID_TOKEN = 'Pautan tetapan semula tidak sah atau telah tamat tempoh. Sila minta pautan baharu.';

    /**
     * E-mail a reset link when the address belongs to an active owner/staff
     * of the site. Silently does nothing otherwise, so callers can always
     * answer the same way and never reveal which e-mails exist.
     *
     * @return string|null the raw token that was e-mailed (for callers that need the link), null when nothing was sent
     */
    public function request(Site $site, string $email): ?string
    {
        $user = $this->findUser($site, $email);

        if ($user === null || ! $user->isActive() || ! $user->isStaff()) {
            return null;
        }

        $token = bin2hex(random_bytes(32));
        $ttl = $this->ttlMinutes();

        PasswordResetToken::query()->updateOrCreate(
            ['user_id' => $user->id],
            ['token' => hash('sha256', $token), 'created_at' => now(), 'expires_at' => now()->addMinutes($ttl)],
        );

        Mail::to($user->email, $user->name)->send(new PasswordResetMail($user, $site, $this->url($site, $email, $token), $ttl));

        return $token;
    }

    /**
     * Set a new password from an e-mailed token, consume the token and revoke
     * every API token of the user (all devices must log in again).
     *
     * @throws ValidationException when the token is unknown, expired, for another user, or the account is disabled
     */
    public function reset(Site $site, string $email, string $token, string $password): User
    {
        return DB::transaction(function () use ($site, $email, $token, $password): User {
            $user = $this->findUser($site, $email);
            $row = $user === null ? null : PasswordResetToken::query()->whereKey($user->id)->lockForUpdate()->first();

            if ($user === null || $row === null || $row->isExpired() || ! hash_equals($row->token, hash('sha256', $token))) {
                throw ValidationException::withMessages(['token' => self::INVALID_TOKEN]);
            }

            if (! $user->isActive() || ! $user->isStaff()) {
                throw ValidationException::withMessages(['email' => 'Akaun ini tidak dibenarkan log masuk ke pengurusan.']);
            }

            $user->forceFill([
                'password' => $password,
                'email_verified_at' => $user->email_verified_at ?? now(),
                'remember_token' => null,
            ])->save();

            $row->delete();
            $user->tokens()->delete();

            return $user;
        });
    }

    /** The frontend reset page: configured base URL locally, the site's own https domain otherwise. */
    public function url(Site $site, string $email, string $token): string
    {
        $base = rtrim((string) (config('shop.frontend_url') ?: 'https://'.$site->domain), '/');

        return $base.'/reset-password?'.http_build_query(['token' => $token, 'email' => $email]);
    }

    public function ttlMinutes(): int
    {
        return max(5, (int) config('shop.password_reset.ttl_minutes', 60));
    }

    private function findUser(Site $site, string $email): ?User
    {
        return User::query()->where('site_id', $site->id)->where('email', mb_strtolower(trim($email)))->first();
    }
}
