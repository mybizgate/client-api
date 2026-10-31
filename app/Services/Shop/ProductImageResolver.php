<?php

namespace App\Services\Shop;

use App\Models\MediaAttachment;
use App\Models\ShopProduct;
use App\Services\MediaApiClient;
use Illuminate\Support\Collection;

/**
 * Product.images[] (SHOP_DESIGN.md §5.2, §7): media-api view_url of the
 * `primary` attachment first, then `gallery` by sort_order. One query per
 * request for any number of products, never one per product.
 */
class ProductImageResolver
{
    public const string ENTITY_TYPE = 'product';

    public function __construct(private readonly MediaApiClient $mediaApi) {}

    /**
     * Loads the URLs onto each product as the `images` relation value
     * (a plain list of strings) so resources can read it without a query.
     *
     * @param  iterable<int, ShopProduct>  $products
     */
    public function attach(iterable $products, string $tenant): void
    {
        $products = Collection::make($products);

        if ($products->isEmpty()) {
            return;
        }

        $rows = MediaAttachment::query()
            ->forTenant($tenant)
            ->where('entity_type', self::ENTITY_TYPE)
            ->whereIn('entity_id', $products->pluck('id')->map(fn (int $id) => (string) $id)->all())
            ->whereIn('role', ['primary', 'gallery'])
            ->orderByRaw("case when role = 'primary' then 0 else 1 end")
            ->orderBy('sort_order')
            ->orderBy('created_at')
            ->get()
            ->groupBy('entity_id');

        foreach ($products as $product) {
            $urls = $rows->get((string) $product->id, collect())
                ->map(fn (MediaAttachment $a) => $this->mediaApi->urls($a->media_id)['view_url'])
                ->values()
                ->all();

            $product->setRelation('images', $urls);
        }
    }

    /**
     * @return list<string>
     */
    public static function imagesOf(ShopProduct $product): array
    {
        return $product->relationLoaded('images') ? (array) $product->getRelation('images') : [];
    }
}
