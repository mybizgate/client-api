<?php

namespace App\Http\Resources\Shop;

use App\Models\ShopSetting;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * API_CONTRACT §5 `Settings` (owner management view).
 *
 * @property-read ShopSetting $resource
 */
class SettingsResource extends JsonResource
{
    public static $wrap = 'data';

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $s = $this->resource;

        return [
            'currency' => $s->currency,
            'minimumOrder' => $s->minimum_order_minor,
            'deliveryFee' => $s->delivery_fee_minor,
            'freeDeliveryFrom' => $s->free_delivery_from_minor,
            'allowWhatsappOrder' => $s->allow_whatsapp_order,
            'deductStockOnConfirm' => $s->deduct_stock_on_confirm,
            'referencePrefix' => $s->reference_prefix,
        ];
    }
}
