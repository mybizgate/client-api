<?php

namespace App\Models;

use App\Enums\InventoryMovementType;
use App\Models\Concerns\BelongsToSite;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Append-only stock ledger row (SHOP_DESIGN.md §6.9).
 *
 * @property int $id
 * @property int $site_id
 * @property int $product_id
 * @property int|null $order_id
 * @property InventoryMovementType $movement_type
 * @property int $quantity_delta
 * @property int $balance_after
 * @property string|null $note
 * @property int|null $created_by_user_id
 */
#[Fillable(['site_id', 'product_id', 'order_id', 'movement_type', 'quantity_delta', 'balance_after', 'note', 'created_by_user_id', 'created_at'])]
class ShopInventoryMovement extends Model
{
    use BelongsToSite;

    public const null UPDATED_AT = null;

    protected $table = 'shop_inventory_movements';

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'product_id' => 'integer',
            'order_id' => 'integer',
            'movement_type' => InventoryMovementType::class,
            'quantity_delta' => 'integer',
            'balance_after' => 'integer',
            'created_by_user_id' => 'integer',
            'created_at' => 'datetime',
        ];
    }

    /**
     * @return BelongsTo<ShopProduct, $this>
     */
    public function product(): BelongsTo
    {
        return $this->belongsTo(ShopProduct::class, 'product_id')->withTrashed();
    }
}
