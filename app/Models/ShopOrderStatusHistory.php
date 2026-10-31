<?php

namespace App\Models;

use App\Enums\ActorType;
use App\Enums\OrderStatus;
use App\Models\Concerns\BelongsToSite;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Carbon;

/**
 * One row per order status transition (SHOP_DESIGN.md §6.8); append-only.
 *
 * @property int $id
 * @property int $site_id
 * @property int $order_id
 * @property OrderStatus $status
 * @property ActorType $actor_type
 * @property int|null $changed_by_user_id
 * @property string|null $note
 * @property Carbon $created_at
 */
#[Fillable(['site_id', 'order_id', 'status', 'actor_type', 'changed_by_user_id', 'note', 'created_at'])]
class ShopOrderStatusHistory extends Model
{
    use BelongsToSite;

    public const null UPDATED_AT = null;

    protected $table = 'shop_order_status_history';

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'order_id' => 'integer',
            'status' => OrderStatus::class,
            'actor_type' => ActorType::class,
            'changed_by_user_id' => 'integer',
            'created_at' => 'datetime',
        ];
    }

    /**
     * @return BelongsTo<ShopOrder, $this>
     */
    public function order(): BelongsTo
    {
        return $this->belongsTo(ShopOrder::class, 'order_id');
    }
}
