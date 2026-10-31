<?php

namespace App\Http\Resources\Shop;

use App\Models\ShopPaymentMethod;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * Management view of a checkout payment method.
 *
 * @property-read ShopPaymentMethod $resource
 */
class PaymentMethodResource extends JsonResource
{
    public static $wrap = 'data';

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $m = $this->resource;

        return [
            'id' => (string) $m->id,
            'code' => $m->code,
            'label' => $m->label,
            'instructions' => $m->instructions,
            'sortOrder' => $m->sort_order,
            'active' => $m->is_active,
        ];
    }
}
