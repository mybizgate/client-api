<?php

namespace App\Models;

use App\Models\Concerns\BelongsToSite;
use Database\Factories\ShopSettingFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * One row per site (primary key site_id): minimum order, delivery fee,
 * reference sequence and the owner's stock switch (SHOP_DESIGN.md §6.2).
 *
 * @property int $site_id
 * @property string $currency
 * @property int $minimum_order_minor
 * @property int $delivery_fee_minor
 * @property int|null $free_delivery_from_minor
 * @property bool $allow_whatsapp_order
 * @property bool $deduct_stock_on_confirm
 * @property string $reference_prefix
 * @property int $next_order_number
 */
#[Fillable([
    'site_id', 'currency', 'minimum_order_minor', 'delivery_fee_minor', 'free_delivery_from_minor',
    'allow_whatsapp_order', 'deduct_stock_on_confirm', 'reference_prefix', 'next_order_number',
])]
class ShopSetting extends Model
{
    use BelongsToSite;

    /** @use HasFactory<ShopSettingFactory> */
    use HasFactory;

    protected $table = 'shop_settings';

    protected $primaryKey = 'site_id';

    public $incrementing = false;

    protected $keyType = 'int';

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'minimum_order_minor' => 'integer',
            'delivery_fee_minor' => 'integer',
            'free_delivery_from_minor' => 'integer',
            'allow_whatsapp_order' => 'boolean',
            'deduct_stock_on_confirm' => 'boolean',
            'next_order_number' => 'integer',
        ];
    }
}
