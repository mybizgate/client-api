<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

/**
 * Tenant = X-Client-Code header (same contract as media-api). Routes that
 * write tenant data require it; the resolved code is exposed as the
 * "tenant" request attribute and is never taken from the request body.
 */
class ResolveTenant
{
    public function handle(Request $request, Closure $next): Response
    {
        $tenant = $request->header('X-Client-Code');

        abort_unless(
            is_string($tenant) && preg_match(config('attachments.patterns.tenant'), $tenant) === 1,
            400,
            'The X-Client-Code header is required and must match ^[a-z0-9-]{2,50}$.'
        );

        $request->attributes->set('tenant', $tenant);

        return $next($request);
    }
}
