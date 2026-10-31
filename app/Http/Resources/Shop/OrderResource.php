<?php

namespace App\Http\Resources\Shop;

use App\Models\ShopOrder;
use App\Models\ShopOrderItem;
use App\Services\Shop\ProductImageResolver;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * API_CONTRACT §4 `Order`: `id` is the reference number, money in sen, item
 * image/art resolved from the current product (load `items.product` and
 * `history`, and run ProductImageResolver on the item products first).
 *
 * @property-read ShopOrder $resource
 */
class OrderResource extends JsonResource
{
    public static $wrap = 'data';

    public function __construct(ShopOrder $resource, private readonly bool $managed = false)
    {
        parent::__construct($resource);
    }

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $o = $this->resource;

        $data = [
            'id' => $o->reference_no,
            'createdAt' => $o->created_at?->toIso8601String(),
            'status' => $o->status->value,
            'customer' => [
                'storeName' => $o->store_name,
                'contactName' => $o->contact_name,
                'phone' => $o->contact_phone,
                'address' => $o->delivery_address ?? '',
            ],
            'fulfilment' => $o->fulfilment_method->value,
            'requestedDate' => $o->requested_date->format('Y-m-d'),
            'paymentMethod' => $o->payment_method_label,
            'notes' => $o->notes ?? '',
            'items' => $o->items->map(fn (ShopOrderItem $i) => $this->item($i))->values()->all(),
            'subtotal' => $o->subtotal_minor,
            'deliveryFee' => $o->delivery_fee_minor,
            'total' => $o->total_minor,
            'history' => $o->history->map(fn ($h) => ['status' => $h->status->value, 'at' => $h->created_at->toIso8601String()])->values()->all(),
        ];

        if ($this->managed) {
            $data['customerProfileId'] = (string) $o->customer_profile_id;
        }

        return $data;
    }

    /**
     * @return array<string, mixed>
     */
    private function item(ShopOrderItem $i): array
    {
        $product = $i->product;
        $images = $product ? ProductImageResolver::imagesOf($product) : [];

        return array_filter([
            'productId' => (string) $i->product_id,
            'sku' => $i->sku,
            'name' => $i->product_name,
            'slug' => $i->product_slug,
            'unit' => $i->selling_unit,
            'packQty' => $i->pack_quantity,
            'size' => $i->pack_size,
            'qty' => $i->quantity,
            'basePrice' => $i->base_price_minor,
            'unitPrice' => $i->unit_price_minor,
            'image' => $images[0] ?? null,
            'art' => $product?->placeholder_art_json,
        ], fn ($v) => $v !== null);
    }
}
