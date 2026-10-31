<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Frontend base URL
    |--------------------------------------------------------------------------
    |
    | Where e-mailed links (password resets) point. Empty in production: the
    | site's own domain (`sites.domain`, https) is used, so links can never be
    | redirected to a caller-supplied host. Set it locally to the Vite dev
    | server so links open the local frontend.
    |
    */

    'frontend_url' => env('SHOP_FRONTEND_URL'),

    /*
    |--------------------------------------------------------------------------
    | Password reset
    |--------------------------------------------------------------------------
    */

    'password_reset' => [
        'ttl_minutes' => (int) env('SHOP_PASSWORD_RESET_TTL', 60),
    ],

];
