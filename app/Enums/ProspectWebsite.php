<?php

namespace App\Enums;

/**
 * Website situation of a marketing prospect (marketing_prospects.website).
 * Mirrors the MariaDB CHECK constraint.
 */
enum ProspectWebsite: string
{
    case None = 'none';
    case Weak = 'weak';
    case HasSite = 'has_site';
    case Unknown = 'unknown';

    /**
     * @return list<string>
     */
    public static function values(): array
    {
        return array_map(fn (self $website) => $website->value, self::cases());
    }
}
