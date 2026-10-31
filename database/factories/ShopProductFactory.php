<?php

namespace Database\Factories;

use App\Enums\PublicationStatus;
use App\Models\ShopCategory;
use App\Models\ShopProduct;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends Factory<ShopProduct>
 */
class ShopProductFactory extends Factory
{
    /**
     * The category decides the site; pass `category_id` (or a category via
     * `forCategory()`) so product and category share one site.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $name = ucfirst(fake()->unique()->words(3, true));

        return [
            'category_id' => ShopCategory::factory(),
            'site_id' => fn (array $attributes) => ShopCategory::query()->findOrFail($attributes['category_id'])->site_id,
            'sku' => null,
            'name' => $name,
            'slug' => Str::slug($name.' 1kg'),
            'short_description' => null,
            'description' => null,
            'brand' => null,
            'selling_unit' => 'karton',
            'pack_quantity' => 12,
            'pack_size' => '1kg',
            'selling_price_minor' => 14520,
            'compare_at_price_minor' => null,
            'minimum_order_quantity' => 1,
            'stock_quantity' => 32,
            'unlimited_stock' => false,
            'low_stock_threshold' => 10,
            'sort_order' => 0,
            'is_featured' => false,
            'status' => PublicationStatus::Active,
            'placeholder_art_json' => ['shape' => 'pouch', 'color' => '#de9731', 'motif' => 'spice', 'label' => 'PRODUK'],
            'published_at' => now(),
        ];
    }

    public function forCategory(ShopCategory $category): static
    {
        return $this->state(fn () => ['category_id' => $category->id, 'site_id' => $category->site_id]);
    }

    public function promo(int $compareAt = 15900): static
    {
        return $this->state(fn () => ['compare_at_price_minor' => $compareAt]);
    }

    public function unlimited(): static
    {
        return $this->state(fn () => ['unlimited_stock' => true]);
    }

    public function draft(): static
    {
        return $this->state(fn () => ['status' => PublicationStatus::Draft, 'published_at' => null]);
    }
}
