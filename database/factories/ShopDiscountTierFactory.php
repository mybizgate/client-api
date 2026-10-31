<?php

namespace Database\Factories;

use App\Models\ShopDiscountTier;
use App\Models\Site;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<ShopDiscountTier>
 */
class ShopDiscountTierFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'site_id' => Site::factory(),
            'minimum_quantity' => 5,
            'discount_basis_points' => 200,
            'is_active' => true,
        ];
    }
}
