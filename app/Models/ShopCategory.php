<?php

namespace App\Models;

use App\Enums\PublicationStatus;
use App\Models\Concerns\BelongsToSite;
use Database\Factories\ShopCategoryFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

/**
 * Catalogue category (SHOP_DESIGN.md §6.3). The screens render a flat list;
 * parent_id is stored for a future tree.
 *
 * @property int $id
 * @property int $site_id
 * @property int|null $parent_id
 * @property string $name
 * @property string $slug
 * @property string|null $description
 * @property int $sort_order
 * @property PublicationStatus $status
 */
#[Fillable(['site_id', 'parent_id', 'name', 'slug', 'description', 'sort_order', 'status', 'created_by_user_id', 'updated_by_user_id'])]
class ShopCategory extends Model
{
    use BelongsToSite;

    /** @use HasFactory<ShopCategoryFactory> */
    use HasFactory;

    use SoftDeletes;

    protected $table = 'shop_categories';

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'parent_id' => 'integer',
            'sort_order' => 'integer',
            'status' => PublicationStatus::class,
        ];
    }

    public function isActive(): bool
    {
        return $this->status === PublicationStatus::Active && $this->deleted_at === null;
    }

    /**
     * @param  Builder<ShopCategory>  $query
     * @return Builder<ShopCategory>
     */
    public function scopeActive(Builder $query): Builder
    {
        return $query->where($this->qualifyColumn('status'), PublicationStatus::Active->value);
    }

    /**
     * @return BelongsTo<ShopCategory, $this>
     */
    public function parent(): BelongsTo
    {
        return $this->belongsTo(ShopCategory::class, 'parent_id');
    }

    /**
     * @return HasMany<ShopCategory, $this>
     */
    public function children(): HasMany
    {
        return $this->hasMany(ShopCategory::class, 'parent_id');
    }

    /**
     * @return HasMany<ShopProduct, $this>
     */
    public function products(): HasMany
    {
        return $this->hasMany(ShopProduct::class, 'category_id');
    }
}
