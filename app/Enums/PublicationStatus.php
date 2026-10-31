<?php

namespace App\Enums;

/**
 * Publication state of catalogue rows (shop_categories.status,
 * shop_products.status). Mirrors the MariaDB CHECK constraints.
 */
enum PublicationStatus: string
{
    case Draft = 'draft';
    case Active = 'active';
    case Archived = 'archived';

    /**
     * @return list<string>
     */
    public static function values(): array
    {
        return array_map(fn (self $status) => $status->value, self::cases());
    }
}
