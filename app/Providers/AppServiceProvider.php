<?php

namespace App\Providers;

use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        $this->configureRateLimiting();
    }

    /**
     * Named limiters keep their own buckets; inline `throttle:5,1` shares one
     * bucket per IP across every route that uses it (login must stay alone).
     */
    private function configureRateLimiting(): void
    {
        // Mail-sending endpoint: tight, to prevent mailbombing an address.
        RateLimiter::for('password-reset-request', fn (Request $request) => Limit::perMinute(5)->by('password-reset-request|'.$request->ip()));

        // Token attempts: a 256-bit token cannot be guessed, but typo retries on the form must stay usable.
        RateLimiter::for('password-reset-attempt', fn (Request $request) => Limit::perMinute(10)->by('password-reset-attempt|'.$request->ip()));
    }
}
