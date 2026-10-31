<?php

namespace Tests\Unit\Services\Shop;

use App\Enums\FulfilmentMethod;
use App\Models\ShopDiscountTier;
use App\Models\ShopSetting;
use App\Services\Shop\OrderPricingService;
use Illuminate\Support\Collection;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;

/**
 * Parity with clients/client-lzhub/src/services/pricing.ts.
 */
class OrderPricingServiceTest extends TestCase
{
    private function tiers(): Collection
    {
        return collect([
            new ShopDiscountTier(['minimum_quantity' => 10, 'discount_basis_points' => 400, 'is_active' => true]),
            new ShopDiscountTier(['minimum_quantity' => 5, 'discount_basis_points' => 200, 'is_active' => true]),
            new ShopDiscountTier(['minimum_quantity' => 3, 'discount_basis_points' => 9000, 'is_active' => false]),
        ]);
    }

    /**
     * @return array<string, array{0: int, 1: int, 2: int}>
     */
    public static function unitPrices(): array
    {
        return [
            'below first tier' => [14520, 4, 14520],
            'first tier 2 %' => [14520, 5, 14230],
            'between tiers' => [14520, 9, 14230],
            'second tier 4 %' => [14520, 10, 13939],
            'large quantity keeps highest tier' => [14520, 100, 13939],
            'js rounding 25 * 0.98 = 24.5 exactly -> 25 (half up)' => [25, 5, 25],
            'js rounding 1250 * 0.98 = 1225' => [1250, 5, 1225],
            'js rounding 35 * 0.98 = 34.3 -> 34' => [35, 5, 34],
            'zero price' => [0, 10, 0],
        ];
    }

    #[DataProvider('unitPrices')]
    public function test_unit_price_matches_math_round_of_price_times_one_minus_rate(int $price, int $qty, int $expected): void
    {
        $this->assertSame($expected, (new OrderPricingService)->unitPrice($price, $qty, $this->tiers()));
    }

    public function test_js_round_is_half_up_on_the_double(): void
    {
        $this->assertSame(0, OrderPricingService::jsRound(0.49999999999999994));
        $this->assertSame(1, OrderPricingService::jsRound(0.5));
        $this->assertSame(2, OrderPricingService::jsRound(1.5));
        $this->assertSame(25, OrderPricingService::jsRound(25 * 0.98));
        $this->assertSame(34, OrderPricingService::jsRound(35 * 0.98));
    }

    public function test_delivery_fee_rules(): void
    {
        $settings = new ShopSetting(['delivery_fee_minor' => 1500, 'free_delivery_from_minor' => 50000]);
        $service = new OrderPricingService;

        $this->assertSame(0, $service->deliveryFee(10000, FulfilmentMethod::Pickup, $settings));
        $this->assertSame(1500, $service->deliveryFee(49999, FulfilmentMethod::Delivery, $settings));
        $this->assertSame(0, $service->deliveryFee(50000, FulfilmentMethod::Delivery, $settings));

        $noFree = new ShopSetting(['delivery_fee_minor' => 1500, 'free_delivery_from_minor' => null]);
        $this->assertSame(1500, $service->deliveryFee(999999, FulfilmentMethod::Delivery, $noFree));
    }
}
