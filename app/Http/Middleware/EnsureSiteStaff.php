<?php

namespace App\Http\Middleware;

use App\Models\Site;
use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Management guard (SHOP_DESIGN.md §9, §15.7). Runs after `site` and
 * `auth:sanctum`: the token's user must be an active owner or staff member
 * of the resolved site. Anything else is 403; a missing token is already 401.
 */
class EnsureSiteStaff
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();
        $site = $request->attributes->get('site');

        abort_unless($user instanceof User, 401, 'Unauthenticated.');
        abort_unless($site instanceof Site, 500, 'Site not resolved.');
        abort_unless($user->site_id === $site->id, 403, 'This account does not belong to this site.');
        abort_unless($user->isActive(), 403, 'This account is disabled.');
        abort_unless($user->isStaff(), 403, 'Management access requires an owner or staff account.');

        return $next($request);
    }
}
