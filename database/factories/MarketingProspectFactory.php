<?php

namespace Database\Factories;

use App\Enums\ProspectPriority;
use App\Enums\ProspectStatus;
use App\Enums\ProspectWebsite;
use App\Models\MarketingProspect;
use App\Models\Site;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<MarketingProspect>
 */
class MarketingProspectFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'site_id' => Site::factory(),
            'name' => fake()->unique()->company(),
            'phone' => '601'.fake()->unique()->numerify('########'),
            'category' => 'cat_hotel',
            'area' => fake()->city(),
            'state' => 'Selangor',
            'channel' => null,
            'website' => ProspectWebsite::Unknown,
            'priority' => ProspectPriority::B,
            'status' => ProspectStatus::New,
            'demo_slug' => 'cathotel',
            'notes' => null,
            'last_touch_at' => null,
        ];
    }

    public function withoutPhone(): static
    {
        return $this->state(fn () => ['phone' => null]);
    }
}
