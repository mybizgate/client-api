<?php

namespace App\Http\Resources\Shop;

use App\Models\ShopProduct;
use App\Services\Shop\ProductImageResolver;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * API_CONTRACT §3 `Product`; with `managed` also §5 `ManagedProduct`.
 * Derived fields follow SHOP_DESIGN.md §5.2. Images must be attached first
 * with ProductImageResolver (one query per request).
 *
 * @property-read ShopProduct $resource
 */
class ProductResource extends JsonResource
{
    public static $wrap = 'data';

    public function __construct(ShopProduct $resource, private readonly bool $managed = false)
    {
        parent::__construct($resource);
    }

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $p = $this->resource;
        $promo = $p->isPromo();

        $data = [
            'id' => (string) $p->id,
            'sku' => $this->when($p->sku !== null, $p->sku),
            'name' => $p->name,
            'slug' => $p->slug,
            'description' => $this->when($p->description !== null, $p->description),
            'categoryId' => (string) $p->category_id,
            'images' => ProductImageResolver::imagesOf($p),
            'unit' => $p->selling_unit,
            'packQty' => $p->pack_quantity,
            'size' => $p->pack_size,
            'price' => $p->selling_price_minor,
            'oldPrice' => $this->when($promo, $p->compare_at_price_minor),
            'minimumQuantity' => $p->minimum_order_quantity,
            'stock' => $p->availableStock(),
            'stockStatus' => $p->stockStatus(),
            'featured' => $p->is_featured,
            'promo' => $promo,
            'brand' => $this->when($p->brand !== null, $p->brand),
            'active' => $p->isPubliclyVisible(),
            'art' => $this->when($p->placeholder_art_json !== null, $p->placeholder_art_json),
            'updatedAt' => $p->updated_at?->toIso8601String(),
        ];

        if ($this->managed) {
            $data['status'] = $p->status->value;
            $data['sortOrder'] = $p->sort_order;
            $data['stockQuantity'] = $p->stock_quantity;
            $data['unlimitedStock'] = $p->unlimited_stock;
            $data['lowStockThreshold'] = $p->low_stock_threshold;
        }

        return $data;
    }
}
