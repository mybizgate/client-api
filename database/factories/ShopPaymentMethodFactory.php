<?php

namespace Database\Factories;

use App\Models\ShopPaymentMethod;
use App\Models\Site;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<ShopPaymentMethod>
 */
class ShopPaymentMethodFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'site_id' => Site::factory(),
            'code' => 'cod',
            'label' => 'Tunai semasa terima barang',
            'instructions' => null,
            'sort_order' => 1,
            'is_active' => true,
        ];
    }

    public function bankTransfer(): static
    {
        return $this->state(fn () => ['code' => 'bank_transfer', 'label' => 'Pindahan bank selepas disahkan', 'sort_order' => 2]);
    }
}
