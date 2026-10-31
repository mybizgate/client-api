<?php

namespace App\Http\Controllers\Api\Shop;

use App\Http\Resources\Shop\ProductResource;
use App\Models\ShopProduct;
use App\Services\Shop\ProductImageResolver;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Validation\Rule;

/**
 * GET /products and GET /products/{slug} (API_CONTRACT §3, SHOP_DESIGN §5.8):
 * every active product of the site in one array; filtering and sorting are
 * optional because the frontend also filters client-side.
 */
class ProductController extends ShopController
{
    public function __construct(private readonly ProductImageResolver $images) {}

    public function index(Request $request): AnonymousResourceCollection
    {
        $filters = $request->validate([
            'category' => ['nullable', 'integer', 'min:1'],
            'search' => ['nullable', 'string', 'max:150'],
            'in_stock' => ['nullable', 'boolean'],
            'promo' => ['nullable', 'boolean'],
            'ids' => ['nullable', 'string', 'max:2000'],
            'sort' => ['nullable', Rule::in(['popular', 'price_asc', 'price_desc', 'name'])],
        ]);

        $query = ShopProduct::query()
            ->forSite($this->site($request))
            ->publiclyVisible()
            ->with('category');

        if (! empty($filters['category'])) {
            $query->where('category_id', (int) $filters['category']);
        }

        if (! empty($filters['ids'])) {
            $ids = array_values(array_filter(array_map('intval', explode(',', $filters['ids']))));
            $query->whereIn('id', $ids === [] ? [0] : $ids);
        }

        if ($request->boolean('in_stock')) {
            $query->where(fn (Builder $q) => $q->where('unlimited_stock', true)->orWhereColumn('stock_quantity', '>=', 'minimum_order_quantity'));
        }

        if ($request->boolean('promo')) {
            $query->whereNotNull('compare_at_price_minor')->whereColumn('compare_at_price_minor', '>', 'selling_price_minor');
        }

        $term = trim((string) ($filters['search'] ?? ''));
        if ($term !== '') {
            $like = '%'.str_replace(['%', '_'], ['\\%', '\\_'], mb_strtolower($term)).'%';
            $query->where(function (Builder $q) use ($like): void {
                foreach (['name', 'sku', 'brand', 'pack_size'] as $column) {
                    $q->orWhereRaw("lower({$column}) like ?", [$like]);
                }
            });
        }

        match ($filters['sort'] ?? 'popular') {
            'price_asc' => $query->orderBy('selling_price_minor')->orderBy('sort_order'),
            'price_desc' => $query->orderByDesc('selling_price_minor')->orderBy('sort_order'),
            'name' => $query->orderBy('name'),
            default => $query->orderBy('sort_order')->orderBy('name'),
        };

        $products = $query->get();
        $this->images->attach($products, $this->tenant($request));

        return ProductResource::collection($products);
    }

    public function show(Request $request, string $slug): ProductResource
    {
        $product = ShopProduct::query()
            ->forSite($this->site($request))
            ->publiclyVisible()
            ->with('category')
            ->where('slug', $slug)
            ->first();

        abort_unless($product !== null, 404, 'Produk tidak ditemui.');

        $this->images->attach([$product], $this->tenant($request));

        return new ProductResource($product);
    }
}
