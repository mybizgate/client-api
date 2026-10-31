<?php

namespace Database\Factories;

use App\Models\ShopCustomerProfile;
use App\Models\Site;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * Guest profile by default; the plain token is `guest-token-<n>` and the
 * stored hash is its SHA-256, matching App\Services\Shop\GuestTokenService.
 *
 * @extends Factory<ShopCustomerProfile>
 */
class ShopCustomerProfileFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'site_id' => Site::factory(),
            'user_id' => null,
            'guest_token_hash' => hash('sha256', 'guest-token-'.fake()->unique()->numberBetween(1, 1_000_000)),
            'store_name' => 'Kedai '.fake()->lastName(),
            'contact_name' => fake()->name(),
            'phone' => '0191234567',
            'address' => fake()->address(),
            'last_seen_at' => now(),
        ];
    }

    public function withToken(string $plainToken): static
    {
        return $this->state(fn () => ['guest_token_hash' => hash('sha256', $plainToken)]);
    }
}
