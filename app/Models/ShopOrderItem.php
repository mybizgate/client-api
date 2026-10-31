<?php

namespace App\Models;

use App\Models\Concerns\BelongsToSite;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Immutable priced order line (SHOP_DESIGN.md §6.8). Product fields are
 * snapshots; the current image/packshot comes from the related product.
 *
 * @property int $id
 * @property int $site_id
 * @property int $order_id
 * @property int $line_number
 * @property int $product_id
 * @property string|null $sku
 * @property string $product_name
 * @property string $product_slug
 * @property string $selling_unit
 * @property int $pack_quantity
 * @property string $pack_size
 * @property int $quantity
 * @property int $base_price_minor
 * @property int $unit_price_minor
 * @property int $line_total_minor
 * @property-read ShopProduct|null $product
 */
#[Fillable([
    'site_id', 'order_id', 'line_number', 'product_id', 'sku', 'product_name', 'product_slug', 'selling_unit',
    'pack_quantity', 'pack_size', 'quantity', 'base_price_minor', 'unit_price_minor', 'line_total_minor',
])]
class ShopOrderItem extends Model
{
    use BelongsToSite;

    protected $table = 'shop_order_items';

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'order_id' => 'integer',
            'line_number' => 'integer',
            'product_id' => 'integer',
            'pack_quantity' => 'integer',
            'quantity' => 'integer',
            'base_price_minor' => 'integer',
            'unit_price_minor' => 'integer',
            'line_total_minor' => 'integer',
        ];
    }

    /**
     * @return BelongsTo<ShopOrder, $this>
     */
    public function order(): BelongsTo
    {
        return $this->belongsTo(ShopOrder::class, 'order_id');
    }

    /**
     * Includes soft-deleted products: order lines keep pointing at them.
     *
     * @return BelongsTo<ShopProduct, $this>
     */
    public function product(): BelongsTo
    {
        return $this->belongsTo(ShopProduct::class, 'product_id')->withTrashed();
    }
}
