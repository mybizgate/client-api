<?php

namespace Tests\Feature\Shop;

use App\Http\Controllers\Api\Shop\AuthController;
use App\Models\Client;
use App\Models\ShopCategory;
use App\Models\ShopCustomerProfile;
use App\Models\ShopDiscountTier;
use App\Models\ShopPaymentMethod;
use App\Models\ShopProduct;
use App\Models\ShopSetting;
use App\Models\Site;
use App\Models\User;

/**
 * One lzhub-like site with the real settings, tiers and payment methods
 * (SHOP_DESIGN.md §11), plus helpers for staff and guest requests.
 */
trait InteractsWithShop
{
    protected Client $client;

    protected Site $site;

    protected ShopSetting $settings;

    protected ShopCategory $category;

    protected function setUpShop(string $code = 'lzhub'): void
    {
        $this->client = Client::factory()->create(['client_code' => $code]);
        $this->site = Site::factory()->create(['client_id' => $this->client->id]);
        $this->settings = ShopSetting::factory()->create(['site_id' => $this->site->id]);
        ShopDiscountTier::factory()->create(['site_id' => $this->site->id, 'minimum_quantity' => 5, 'discount_basis_points' => 200]);
        ShopDiscountTier::factory()->create(['site_id' => $this->site->id, 'minimum_quantity' => 10, 'discount_basis_points' => 400]);
        ShopPaymentMethod::factory()->create(['site_id' => $this->site->id]);
        ShopPaymentMethod::factory()->bankTransfer()->create(['site_id' => $this->site->id]);
        $this->category = ShopCategory::factory()->create(['site_id' => $this->site->id, 'name' => 'Rempah & Perencah', 'slug' => 'rempah-perencah', 'sort_order' => 1]);
    }

    /** A second, unrelated tenant for isolation tests. */
    protected function otherSite(string $code = 'other'): Site
    {
        $client = Client::factory()->create(['client_code' => $code]);
        $site = Site::factory()->create(['client_id' => $client->id]);
        ShopSetting::factory()->create(['site_id' => $site->id, 'reference_prefix' => 'OT']);

        return $site;
    }

    /**
     * @param  array<string, mixed>  $attributes
     */
    protected function product(array $attributes = []): ShopProduct
    {
        return ShopProduct::factory()->forCategory($this->category)->create($attributes);
    }

    /**
     * @return array<string, string>
     */
    protected function headers(?string $bearer = null, string $code = 'lzhub'): array
    {
        // The Sanctum request guard remembers the first resolved user for the
        // whole test; forget it so every request authenticates its own token.
        $this->app['auth']->forgetGuards();

        $headers = ['X-Client-Code' => $code, 'Accept' => 'application/json'];

        if ($bearer !== null) {
            $headers['Authorization'] = 'Bearer '.$bearer;
        }

        return $headers;
    }

    /**
     * @return array{0: User, 1: string} user and plain Sanctum token
     */
    protected function staff(string $role = 'owner', ?Site $site = null): array
    {
        $factory = User::factory()->for($site ?? $this->site);
        $user = ($role === 'owner' ? $factory->owner() : $factory->staff())->create(['password' => 'secret-pass']);

        return [$user, $user->createToken(AuthController::TOKEN_NAME)->plainTextToken];
    }

    /**
     * @return array{0: ShopCustomerProfile, 1: string} profile and plain guest token
     */
    protected function guest(?Site $site = null): array
    {
        $token = str_repeat('a', 63).((string) random_int(0, 9));
        $profile = ShopCustomerProfile::factory()->withToken($token)->create(['site_id' => ($site ?? $this->site)->id]);

        return [$profile, $token];
    }

    /**
     * @param  list<array{productId: int|string, qty: int}>  $items
     * @return array<string, mixed>
     */
    protected function draft(array $items, array $overrides = []): array
    {
        return array_replace_recursive([
            'customer' => ['storeName' => 'Kedai Maju Jaya', 'contactName' => 'Ali', 'phone' => '019 123 4567', 'address' => 'No 1, Jalan Melati 13, 53100 Kuala Lumpur'],
            'fulfilment' => 'delivery',
            'requestedDate' => now('Asia/Kuala_Lumpur')->addDays(2)->toDateString(),
            'paymentMethod' => 'Tunai semasa terima barang',
            'notes' => '',
            'items' => $items,
        ], $overrides);
    }
}
