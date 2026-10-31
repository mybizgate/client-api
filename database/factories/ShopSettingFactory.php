<?php

namespace Database\Factories;

use App\Models\ShopSetting;
use App\Models\Site;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * Defaults mirror the lzhub frontend config (SHOP_DESIGN.md §11).
 *
 * @extends Factory<ShopSetting>
 */
class ShopSettingFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'site_id' => Site::factory(),
            'currency' => 'MYR',
            'minimum_order_minor' => 15000,
            'delivery_fee_minor' => 1500,
            'free_delivery_from_minor' => 50000,
            'allow_whatsapp_order' => true,
            'deduct_stock_on_confirm' => false,
            'reference_prefix' => 'LZ',
            'next_order_number' => 1,
        ];
    }

    public function deductingStock(): static
    {
        return $this->state(fn () => ['deduct_stock_on_confirm' => true]);
    }
}
