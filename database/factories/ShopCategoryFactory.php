<?php

namespace Database\Factories;

use App\Enums\PublicationStatus;
use App\Models\ShopCategory;
use App\Models\Site;
use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends Factory<ShopCategory>
 */
class ShopCategoryFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $name = ucfirst(fake()->unique()->words(2, true));

        return [
            'site_id' => Site::factory(),
            'parent_id' => null,
            'name' => $name,
            'slug' => Str::slug($name),
            'description' => null,
            'sort_order' => 0,
            'status' => PublicationStatus::Active,
        ];
    }

    public function draft(): static
    {
        return $this->state(fn () => ['status' => PublicationStatus::Draft]);
    }
}
