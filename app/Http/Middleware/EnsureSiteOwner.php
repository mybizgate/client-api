<?php

namespace App\Http\Middleware;

use App\Enums\UserRole;
use App\Models\User;
use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Owner-only routes (settings, discount tiers, payment methods). Runs after
 * `site.staff`, so the user is already known to belong to the site.
 */
class EnsureSiteOwner
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        abort_unless($user instanceof User && $user->role === UserRole::Owner, 403, 'Only the site owner may do this.');

        return $next($request);
    }
}
