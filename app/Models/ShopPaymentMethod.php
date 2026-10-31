<?php

namespace App\Models;

use App\Models\Concerns\BelongsToSite;
use Database\Factories\ShopPaymentMethodFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Checkout payment choice (SHOP_DESIGN.md §6.6). The frontend submits the
 * exact `label`, so active labels must never be renamed.
 *
 * @property int $id
 * @property int $site_id
 * @property string $code
 * @property string $label
 * @property string|null $instructions
 * @property int $sort_order
 * @property bool $is_active
 */
#[Fillable(['site_id', 'code', 'label', 'instructions', 'sort_order', 'is_active'])]
class ShopPaymentMethod extends Model
{
    use BelongsToSite;

    /** @use HasFactory<ShopPaymentMethodFactory> */
    use HasFactory;

    protected $table = 'shop_payment_methods';

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'sort_order' => 'integer',
            'is_active' => 'boolean',
        ];
    }
}
