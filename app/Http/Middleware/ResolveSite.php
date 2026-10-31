<?php

namespace App\Http\Middleware;

use App\Models\Client;
use Closure;
use Illuminate\Http\Exceptions\HttpResponseException;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Site resolution for the shop domain (SHOP_DESIGN.md §2): X-Client-Code →
 * clients.client_code → sites. Public reads have no user, so the header is the
 * only tenant signal; it is an identifier, never an authorisation.
 *
 *  - missing / malformed header → 400 (same contract as ResolveTenant)
 *  - unknown client or client without a site → 404
 *  - site not `active` → 403 with status, status_reason and remarks
 *
 * Exposes the `tenant` (client code), `client` and `site` request attributes.
 */
class ResolveSite
{
    public function handle(Request $request, Closure $next): Response
    {
        $code = $request->header('X-Client-Code');

        abort_unless(
            is_string($code) && preg_match(config('attachments.patterns.tenant'), $code) === 1,
            400,
            'The X-Client-Code header is required and must match ^[a-z0-9-]{2,50}$.'
        );

        $client = Client::query()->where('client_code', $code)->with('site')->first();

        abort_unless($client !== null && $client->site !== null, 404, 'Unknown client code.');

        $site = $client->site;

        if (! $site->isActive()) {
            throw new HttpResponseException(response()->json([
                'message' => 'This site is not active.',
                'status' => $site->status,
                'status_reason' => $site->status_reason,
                'remarks' => $site->remarks,
            ], 403));
        }

        $request->attributes->set('tenant', $code);
        $request->attributes->set('client', $client);
        $request->attributes->set('site', $site);

        return $next($request);
    }
}
