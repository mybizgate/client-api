<?php

namespace App\Services\Shop;

use App\Enums\InventoryMovementType;
use App\Enums\PublicationStatus;
use App\Models\ShopCategory;
use App\Models\ShopProduct;
use App\Models\Site;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

/**
 * Management writes on products (SHOP_DESIGN.md §15.4–§15.6, API_CONTRACT §5):
 * camelCase input → columns, slug generation, promotion price rule, stock
 * edits recorded as `adjustment` movements, audit columns.
 */
class ShopProductService
{
    public function __construct(private readonly StockService $stock) {}

    /**
     * @param  array<string, mixed>  $input  validated ProductInput
     */
    public function create(Site $site, User $actor, array $input): ShopProduct
    {
        return DB::transaction(function () use ($site, $actor, $input): ShopProduct {
            $category = $this->category($site, (int) $input['categoryId']);

            $product = new ShopProduct(['site_id' => $site->id, 'category_id' => $category->id]);
            $this->fill($product, $input);
            $product->slug = $this->uniqueSlug($site, $input['slug'] ?? null, $product->name, $product->pack_size);
            $product->stock_quantity = 0;
            $product->created_by_user_id = $actor->id;
            $product->updated_by_user_id = $actor->id;
            $product->published_at = $product->status === PublicationStatus::Active ? now() : null;
            $product->save();

            $opening = (int) ($input['stockQuantity'] ?? 0);

            if ($opening > 0 && ! $product->unlimited_stock) {
                // Writes the balance and the `opening` ledger row together.
                $this->stock->adjust($product, $opening, InventoryMovementType::Opening, null, $actor->id, 'Stok permulaan');
            } elseif ($opening > 0) {
                $product->stock_quantity = $opening;
                $product->save();
            }

            return $product->refresh();
        });
    }

    /**
     * @param  array<string, mixed>  $input  validated ProductInput (full)
     */
    public function update(ShopProduct $product, User $actor, array $input): ShopProduct
    {
        return DB::transaction(function () use ($product, $actor, $input): ShopProduct {
            $product = ShopProduct::query()->lockForUpdate()->findOrFail($product->id);
            $site = $product->site;
            $category = $this->category($site, (int) $input['categoryId']);

            $wasActive = $product->status === PublicationStatus::Active;
            $previousStock = $product->stock_quantity;

            $product->category_id = $category->id;
            $this->fill($product, $input);

            if (array_key_exists('slug', $input) && $input['slug'] !== null && $input['slug'] !== $product->slug) {
                $product->slug = $this->uniqueSlug($site, $input['slug'], $product->name, $product->pack_size, $product->id);
            }

            if (! $wasActive && $product->status === PublicationStatus::Active && $product->published_at === null) {
                $product->published_at = now();
            }

            $product->updated_by_user_id = $actor->id;
            $product->save();

            $newStock = (int) ($input['stockQuantity'] ?? $previousStock);

            if (! $product->unlimited_stock && $newStock !== $previousStock) {
                $this->stock->adjust($product, $newStock - $previousStock, InventoryMovementType::Adjustment, null, $actor->id, 'Kemas kini stok dari borang produk');
            }

            return $product->refresh();
        });
    }

    /** POST /manage/products/{id}/inventory */
    public function recordMovement(ShopProduct $product, User $actor, InventoryMovementType $type, int $delta, ?string $note): ShopProduct
    {
        return DB::transaction(function () use ($product, $actor, $type, $delta, $note): ShopProduct {
            $product = ShopProduct::query()->lockForUpdate()->findOrFail($product->id);

            if ($product->unlimited_stock) {
                throw ValidationException::withMessages(['quantityDelta' => ['Produk ini ditanda stok tanpa had.']]);
            }

            $this->stock->adjust($product, $delta, $type, null, $actor->id, $note);

            return $product->refresh();
        });
    }

    public function archive(ShopProduct $product, User $actor): void
    {
        DB::transaction(function () use ($product, $actor): void {
            $product->status = PublicationStatus::Archived;
            $product->updated_by_user_id = $actor->id;
            $product->save();
            $product->delete();
        });
    }

    /**
     * @param  array<string, mixed>  $input
     */
    private function fill(ShopProduct $product, array $input): void
    {
        $price = (int) $input['price'];
        $oldPrice = isset($input['oldPrice']) ? (int) $input['oldPrice'] : null;

        $product->fill([
            'sku' => self::blankToNull($input['sku'] ?? null),
            'name' => trim($input['name']),
            'short_description' => self::blankToNull($input['shortDescription'] ?? null),
            'description' => self::blankToNull($input['description'] ?? null),
            'brand' => self::blankToNull($input['brand'] ?? null),
            'selling_unit' => trim($input['unit']),
            'pack_quantity' => (int) $input['packQty'],
            'pack_size' => trim($input['size']),
            'selling_price_minor' => $price,
            // SHOP_DESIGN §5.2: a promotion price that is not above the price is cleared, never rejected.
            'compare_at_price_minor' => $oldPrice !== null && $oldPrice > $price ? $oldPrice : null,
            'minimum_order_quantity' => (int) $input['minimumQuantity'],
            'unlimited_stock' => (bool) ($input['unlimitedStock'] ?? false),
            'low_stock_threshold' => (int) ($input['lowStockThreshold'] ?? $product->low_stock_threshold ?? 10),
            'sort_order' => (int) ($input['sortOrder'] ?? $product->sort_order ?? 0),
            'is_featured' => (bool) ($input['featured'] ?? $product->is_featured ?? false),
            'status' => PublicationStatus::from($input['status']),
            'placeholder_art_json' => $input['art'] ?? $product->placeholder_art_json,
        ]);
    }

    private function category(Site $site, int $categoryId): ShopCategory
    {
        $category = ShopCategory::query()->forSite($site)->find($categoryId);

        if ($category === null) {
            throw ValidationException::withMessages(['categoryId' => ['Kategori tidak ditemui.']]);
        }

        return $category;
    }

    /** `Str::slug(name + size)` unless given; a numeric suffix keeps it unique within the site. */
    private function uniqueSlug(Site $site, ?string $wanted, string $name, string $size, ?int $ignoreId = null): string
    {
        $base = Str::slug(self::blankToNull($wanted) ?? "{$name} {$size}");
        $base = $base === '' ? 'produk' : Str::limit($base, 200, '');
        $slug = $base;

        for ($n = 2; $this->slugTaken($site, $slug, $ignoreId); $n++) {
            $slug = "{$base}-{$n}";
        }

        return $slug;
    }

    private function slugTaken(Site $site, string $slug, ?int $ignoreId): bool
    {
        return ShopProduct::query()->withTrashed()->forSite($site)->where('slug', $slug)
            ->when($ignoreId !== null, fn ($q) => $q->whereKeyNot($ignoreId))
            ->exists();
    }

    private static function blankToNull(mixed $value): ?string
    {
        if (! is_string($value)) {
            return null;
        }

        $value = trim($value);

        return $value === '' ? null : $value;
    }
}
