<?php

namespace App\Models;

use App\Models\Concerns\BelongsToSite;
use Database\Factories\ShopDiscountTierFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

/**
 * Site-wide quantity discount tier (SHOP_DESIGN.md §6.5): 200 basis points = 2 %.
 *
 * @property int $id
 * @property int $site_id
 * @property int $minimum_quantity
 * @property int $discount_basis_points
 * @property bool $is_active
 */
#[Fillable(['site_id', 'minimum_quantity', 'discount_basis_points', 'is_active'])]
class ShopDiscountTier extends Model
{
    use BelongsToSite;

    /** @use HasFactory<ShopDiscountTierFactory> */
    use HasFactory;

    protected $table = 'shop_discount_tiers';

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'minimum_quantity' => 'integer',
            'discount_basis_points' => 'integer',
            'is_active' => 'boolean',
        ];
    }

    /** QuantityDiscount.rate as the frontend expects it (fraction). */
    public function rate(): float
    {
        return $this->discount_basis_points / 10000;
    }
}
