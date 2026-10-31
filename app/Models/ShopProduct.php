<?php

namespace App\Models;

use App\Enums\PublicationStatus;
use App\Models\Concerns\BelongsToSite;
use Database\Factories\ShopProductFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Support\Carbon;

/**
 * Product of a site (SHOP_DESIGN.md §6.4). Money is in minor units (sen),
 * quantities are whole selling units. Derived frontend fields (stockStatus,
 * promo, active, stock null when unlimited) are computed here, never stored.
 *
 * @property int $id
 * @property int $site_id
 * @property int $category_id
 * @property string|null $sku
 * @property string $name
 * @property string $slug
 * @property string|null $short_description
 * @property string|null $description
 * @property string|null $brand
 * @property string $selling_unit
 * @property int $pack_quantity
 * @property string $pack_size
 * @property int $selling_price_minor
 * @property int|null $compare_at_price_minor
 * @property int $minimum_order_quantity
 * @property int $stock_quantity
 * @property bool $unlimited_stock
 * @property int $low_stock_threshold
 * @property int $sort_order
 * @property bool $is_featured
 * @property PublicationStatus $status
 * @property array<string, mixed>|null $placeholder_art_json
 * @property Carbon|null $published_at
 * @property Carbon|null $updated_at
 * @property-read ShopCategory $category
 */
#[Fillable([
    'site_id', 'category_id', 'sku', 'name', 'slug', 'short_description', 'description', 'brand', 'selling_unit',
    'pack_quantity', 'pack_size', 'selling_price_minor', 'compare_at_price_minor', 'minimum_order_quantity',
    'stock_quantity', 'unlimited_stock', 'low_stock_threshold', 'sort_order', 'is_featured', 'status',
    'placeholder_art_json', 'published_at', 'created_by_user_id', 'updated_by_user_id',
])]
class ShopProduct extends Model
{
    use BelongsToSite;

    /** @use HasFactory<ShopProductFactory> */
    use HasFactory;

    use SoftDeletes;

    public const string STOCK_IN = 'in_stock';

    public const string STOCK_LOW = 'low';

    public const string STOCK_OUT = 'out';

    protected $table = 'shop_products';

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'category_id' => 'integer',
            'pack_quantity' => 'integer',
            'selling_price_minor' => 'integer',
            'compare_at_price_minor' => 'integer',
            'minimum_order_quantity' => 'integer',
            'stock_quantity' => 'integer',
            'unlimited_stock' => 'boolean',
            'low_stock_threshold' => 'integer',
            'sort_order' => 'integer',
            'is_featured' => 'boolean',
            'status' => PublicationStatus::class,
            'placeholder_art_json' => 'array',
            'published_at' => 'datetime',
        ];
    }

    /**
     * @return BelongsTo<ShopCategory, $this>
     */
    public function category(): BelongsTo
    {
        return $this->belongsTo(ShopCategory::class, 'category_id');
    }

    /**
     * @return HasMany<ShopInventoryMovement, $this>
     */
    public function movements(): HasMany
    {
        return $this->hasMany(ShopInventoryMovement::class, 'product_id');
    }

    /**
     * Customer-visible: active, not deleted, and in an active category
     * (SHOP_DESIGN.md §5.2). Requires the category to be joined or loaded.
     *
     * @param  Builder<ShopProduct>  $query
     * @return Builder<ShopProduct>
     */
    public function scopePubliclyVisible(Builder $query): Builder
    {
        return $query
            ->where($this->qualifyColumn('status'), PublicationStatus::Active->value)
            ->whereHas('category', fn (Builder $q) => $q->where('status', PublicationStatus::Active->value));
    }

    public function isPubliclyVisible(): bool
    {
        return $this->status === PublicationStatus::Active
            && $this->deleted_at === null
            && $this->category !== null
            && $this->category->isActive();
    }

    public function isPromo(): bool
    {
        return $this->compare_at_price_minor !== null && $this->compare_at_price_minor > $this->selling_price_minor;
    }

    /** Product.stock: null means "no limit". */
    public function availableStock(): ?int
    {
        return $this->unlimited_stock ? null : $this->stock_quantity;
    }

    public function stockStatus(): string
    {
        if ($this->unlimited_stock) {
            return self::STOCK_IN;
        }

        if ($this->stock_quantity < $this->minimum_order_quantity) {
            return self::STOCK_OUT;
        }

        return $this->stock_quantity < $this->low_stock_threshold ? self::STOCK_LOW : self::STOCK_IN;
    }

    /** Whether `quantity` units may be ordered right now (ignores the minimum). */
    public function hasStockFor(int $quantity): bool
    {
        return $this->unlimited_stock || $this->stock_quantity >= $quantity;
    }
}
