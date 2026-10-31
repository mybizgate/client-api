<?php

namespace App\Services\Shop;

use App\Enums\FulfilmentMethod;
use App\Models\ShopDiscountTier;
use App\Models\ShopSetting;
use Illuminate\Support\Collection;

/**
 * Reproduces clients/client-lzhub/src/services/pricing.ts exactly
 * (SHOP_DESIGN.md §5.3) so the API and the prototype price identically.
 */
class OrderPricingService
{
    /**
     * Unit price after the highest qualifying tier. Mirrors
     * `Math.round(price * (1 - rate))`: the multiplication is done in doubles
     * with the same operands JavaScript uses, and rounding is half-up on the
     * double (PHP 8.3's round() pre-rounds, which would differ on .5 edges).
     *
     * @param  Collection<int, ShopDiscountTier>  $tiers  active tiers of the site
     */
    public function unitPrice(int $priceMinor, int $quantity, Collection $tiers): int
    {
        $tier = $tiers
            ->filter(fn (ShopDiscountTier $t) => $t->is_active && $quantity >= $t->minimum_quantity)
            ->sortByDesc('minimum_quantity')
            ->first();

        if ($tier === null) {
            return $priceMinor;
        }

        return self::jsRound($priceMinor * (1 - $tier->discount_basis_points / 10000));
    }

    /** `deliveryFee()` in pricing.ts. */
    public function deliveryFee(int $subtotalMinor, FulfilmentMethod $fulfilment, ShopSetting $settings): int
    {
        if ($fulfilment === FulfilmentMethod::Pickup) {
            return 0;
        }

        if ($settings->free_delivery_from_minor !== null && $subtotalMinor >= $settings->free_delivery_from_minor) {
            return 0;
        }

        return $settings->delivery_fee_minor;
    }

    /** JavaScript Math.round for non-negative values: floor(x) + (frac >= .5). */
    public static function jsRound(float $value): int
    {
        $floor = floor($value);

        return (int) ($value - $floor >= 0.5 ? $floor + 1 : $floor);
    }
}
