<?php

namespace App\Http\Middleware;

use App\Models\Site;
use App\Services\Shop\GuestTokenService;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Customer identity for /customer/* and /orders* (SHOP_DESIGN.md §5.6). Runs
 * after `site`. A 64-hex bearer token is looked up as a guest token; a
 * Sanctum-shaped (staff) token or no token leaves the customer unresolved
 * and the controller decides whether that is allowed (401 for reads, a new
 * guest profile for the first write). An unknown guest token is 401.
 */
class ResolveShopCustomer
{
    public function __construct(private readonly GuestTokenService $tokens) {}

    public function handle(Request $request, Closure $next): Response
    {
        $site = $request->attributes->get('site');
        abort_unless($site instanceof Site, 500, 'Site not resolved.');

        $token = $request->bearerToken();
        $profile = null;

        if (is_string($token) && $this->tokens->looksLikeGuestToken($token)) {
            $profile = $this->tokens->find($site, $token);

            abort_unless($profile !== null, 401, 'Unknown customer token.');

            if ($profile->last_seen_at === null || $profile->last_seen_at->lt(now()->subMinutes(5))) {
                $profile->forceFill(['last_seen_at' => now()])->saveQuietly();
            }
        }

        $request->attributes->set('customerProfile', $profile);

        return $next($request);
    }
}
