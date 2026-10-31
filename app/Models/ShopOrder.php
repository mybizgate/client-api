<?php

namespace App\Models;

use App\Enums\FulfilmentMethod;
use App\Enums\OrderStatus;
use App\Models\Concerns\BelongsToSite;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Collection;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Carbon;

/**
 * Order header (SHOP_DESIGN.md §6.8). `reference_no` is Order.id for the
 * frontend. Money in minor units; totals are estimates confirmed over WhatsApp.
 *
 * @property int $id
 * @property int $site_id
 * @property string $reference_no
 * @property int $customer_profile_id
 * @property OrderStatus $status
 * @property string $source
 * @property string $store_name
 * @property string $contact_name
 * @property string $contact_phone
 * @property FulfilmentMethod $fulfilment_method
 * @property string|null $delivery_address
 * @property Carbon $requested_date
 * @property string $payment_method_code
 * @property string $payment_method_label
 * @property string $currency
 * @property int $subtotal_minor
 * @property int $discount_minor
 * @property int $delivery_fee_minor
 * @property int $total_minor
 * @property string|null $notes
 * @property Carbon|null $whatsapp_sent_at
 * @property Carbon|null $confirmed_at
 * @property Carbon|null $completed_at
 * @property Carbon|null $cancelled_at
 * @property Carbon|null $created_at
 * @property-read Collection<int, ShopOrderItem> $items
 * @property-read Collection<int, ShopOrderStatusHistory> $history
 */
#[Fillable([
    'site_id', 'reference_no', 'customer_profile_id', 'status', 'source', 'store_name', 'contact_name',
    'contact_phone', 'fulfilment_method', 'delivery_address', 'requested_date', 'payment_method_code',
    'payment_method_label', 'currency', 'subtotal_minor', 'discount_minor', 'delivery_fee_minor', 'total_minor',
    'notes', 'whatsapp_sent_at', 'confirmed_at', 'completed_at', 'cancelled_at',
])]
class ShopOrder extends Model
{
    use BelongsToSite;

    protected $table = 'shop_orders';

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'customer_profile_id' => 'integer',
            'status' => OrderStatus::class,
            'fulfilment_method' => FulfilmentMethod::class,
            'requested_date' => 'date:Y-m-d',
            'subtotal_minor' => 'integer',
            'discount_minor' => 'integer',
            'delivery_fee_minor' => 'integer',
            'total_minor' => 'integer',
            'whatsapp_sent_at' => 'datetime',
            'confirmed_at' => 'datetime',
            'completed_at' => 'datetime',
            'cancelled_at' => 'datetime',
        ];
    }

    /**
     * @return BelongsTo<ShopCustomerProfile, $this>
     */
    public function customerProfile(): BelongsTo
    {
        return $this->belongsTo(ShopCustomerProfile::class, 'customer_profile_id');
    }

    /**
     * @return HasMany<ShopOrderItem, $this>
     */
    public function items(): HasMany
    {
        return $this->hasMany(ShopOrderItem::class, 'order_id')->orderBy('line_number');
    }

    /**
     * @return HasMany<ShopOrderStatusHistory, $this>
     */
    public function history(): HasMany
    {
        return $this->hasMany(ShopOrderStatusHistory::class, 'order_id')->orderBy('created_at')->orderBy('id');
    }

    /**
     * @return HasMany<ShopInventoryMovement, $this>
     */
    public function movements(): HasMany
    {
        return $this->hasMany(ShopInventoryMovement::class, 'order_id');
    }
}
