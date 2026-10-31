<?php

namespace App\Http\Resources\Shop;

use App\Models\ShopDiscountTier;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * Management view of a quantity tier (frontend QuantityDiscount + id/active).
 *
 * @property-read ShopDiscountTier $resource
 */
class DiscountTierResource extends JsonResource
{
    public static $wrap = 'data';

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->resource->id,
            'minQty' => $this->resource->minimum_quantity,
            'rate' => $this->resource->rate(),
            'basisPoints' => $this->resource->discount_basis_points,
            'active' => $this->resource->is_active,
        ];
    }
}
