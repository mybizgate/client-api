<?php

namespace App\Enums;

/**
 * Business category of a marketing prospect (marketing_prospects.category).
 * Validated by the application only (no CHECK), so a new category needs no
 * schema change. `demoSlug()` is the contract's default demo per category.
 */
enum ProspectCategory: string
{
    case CatHotel = 'cat_hotel';
    case Dental = 'dental';
    case Salon = 'salon';
    case Auto = 'auto';
    case HomeService = 'home_service';
    case Solar = 'solar';
    case Contractor = 'contractor';
    case Retail = 'retail';
    case Fnb = 'fnb';
    case Homestay = 'homestay';
    case Other = 'other';

    /** Demo slugs a prospect may be personalised with. */
    public const DEMO_SLUGS = ['cathotel', 'dental', 'beausalon', 'autocare', 'service', 'supplier'];

    public function demoSlug(): ?string
    {
        return match ($this) {
            self::CatHotel => 'cathotel',
            self::Dental => 'dental',
            self::Salon => 'beausalon',
            self::Auto => 'autocare',
            self::HomeService, self::Solar, self::Contractor => 'service',
            self::Retail, self::Fnb => 'supplier',
            default => null,
        };
    }

    /**
     * @return list<string>
     */
    public static function values(): array
    {
        return array_map(fn (self $category) => $category->value, self::cases());
    }
}
