<?php

use App\Http\Middleware\EnsureSiteOwner;
use App\Http\Middleware\EnsureSiteStaff;
use App\Http\Middleware\ResolveShopCustomer;
use App\Http\Middleware\ResolveSite;
use App\Http\Middleware\ResolveTenant;
use Illuminate\Contracts\Auth\Middleware\AuthenticatesRequests;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->alias([
            'tenant' => ResolveTenant::class,        // legacy: header only, no database lookup
            'site' => ResolveSite::class,            // X-Client-Code → clients → sites (404 / 403 inactive)
            'site.staff' => EnsureSiteStaff::class,  // after auth:sanctum: owner/staff of that site
            'site.owner' => EnsureSiteOwner::class,  // after site.staff: owner only
            'shop.customer' => ResolveShopCustomer::class, // guest token → customerProfile attribute
        ]);

        // Resolve the site (400 / 404 / 403 inactive) before Sanctum answers 401.
        $middleware->prependToPriorityList(AuthenticatesRequests::class, ResolveSite::class);

        // Pure API: an unauthenticated request gets a JSON 401, never a redirect to a
        // (non-existent) login page, whatever Accept header the client sent.
        $middleware->redirectGuestsTo(fn (Request $request) => $request->is('api/*') ? null : '/');
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->shouldRenderJsonWhen(
            fn (Request $request) => $request->is('api/*') || $request->expectsJson(),
        );
    })->create();
