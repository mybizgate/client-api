<?php

namespace App\Models;

use App\Models\Concerns\BelongsToSite;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;

/**
 * Deferred: product saved by a customer profile (SHOP_DESIGN.md §6.11).
 * Composite primary key (site_id, customer_profile_id, product_id); use
 * query-builder writes, never `find()`.
 *
 * @property int $site_id
 * @property int $customer_profile_id
 * @property int $product_id
 */
#[Fillable(['site_id', 'customer_profile_id', 'product_id', 'created_at'])]
class ShopFavourite extends Model
{
    use BelongsToSite;

    public const null UPDATED_AT = null;

    protected $table = 'shop_favourites';

    public $incrementing = false;

    protected $primaryKey = null;

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'customer_profile_id' => 'integer',
            'product_id' => 'integer',
            'created_at' => 'datetime',
        ];
    }
}
