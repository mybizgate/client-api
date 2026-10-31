<?php

namespace App\Services\Shop;

use App\Models\ShopCustomerProfile;
use App\Models\Site;

/**
 * Guest identity without a login screen (SHOP_DESIGN.md §5.6). The browser
 * receives a random 32-byte token once; only its SHA-256 is stored.
 */
class GuestTokenService
{
    public function generate(): string
    {
        return bin2hex(random_bytes(32));
    }

    public function hash(string $token): string
    {
        return hash('sha256', $token);
    }

    /** Sanctum tokens are `id|secret`; guest tokens are 64 hex characters. */
    public function looksLikeGuestToken(string $token): bool
    {
        return preg_match('/^[0-9a-f]{64}$/', $token) === 1;
    }

    public function find(Site $site, string $token): ?ShopCustomerProfile
    {
        if (! $this->looksLikeGuestToken($token)) {
            return null;
        }

        return ShopCustomerProfile::query()
            ->forSite($site)
            ->where('guest_token_hash', $this->hash($token))
            ->first();
    }
}
