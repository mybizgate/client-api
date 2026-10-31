<?php

namespace Database\Factories;

use App\Models\Client;
use App\Models\Site;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Site>
 */
class SiteFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'client_id' => Client::factory(),
            'site_name' => fake()->company(),
            'domain' => fake()->unique()->domainName(),
            'domain_type' => 'subdomain',
            'site_type' => 'web_application',
            'package_name' => 'standard',
            'first_year_price' => 0,
            'renewal_price' => 0,
            'billing_months' => 12,
            'start_date' => now()->toDateString(),
            'expiry_date' => now()->addYear()->toDateString(),
            'status' => Site::STATUS_ACTIVE,
            'status_reason' => null,
            'remarks' => null,
        ];
    }

    public function expired(): static
    {
        return $this->state(fn () => [
            'status' => 'expired',
            'status_reason' => 'Langganan tamat.',
            'remarks' => 'Hubungi MyBizGate untuk pembaharuan.',
        ]);
    }
}
