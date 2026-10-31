<?php

namespace App\Http\Controllers\Api\Shop;

use App\Http\Controllers\Controller;
use App\Models\ShopCustomerProfile;
use App\Models\Site;
use App\Models\User;
use Illuminate\Http\Request;

/**
 * Shared accessors for the request attributes set by the `site`,
 * `shop.customer` and `auth:sanctum` middleware.
 */
abstract class ShopController extends Controller
{
    protected function site(Request $request): Site
    {
        $site = $request->attributes->get('site');
        abort_unless($site instanceof Site, 500, 'Site not resolved.');

        return $site;
    }

    protected function tenant(Request $request): string
    {
        return (string) $request->attributes->get('tenant');
    }

    protected function customer(Request $request): ?ShopCustomerProfile
    {
        $profile = $request->attributes->get('customerProfile');

        return $profile instanceof ShopCustomerProfile ? $profile : null;
    }

    protected function customerOrFail(Request $request): ShopCustomerProfile
    {
        return $this->customer($request) ?? abort(401, 'A customer token is required.');
    }

    protected function staff(Request $request): User
    {
        $user = $request->user();
        abort_unless($user instanceof User, 401, 'Unauthenticated.');

        return $user;
    }
}
