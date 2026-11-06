<?php

namespace App\Enums;

/**
 * Message template recorded on a marketing touch (marketing_touches.template).
 * Mirrors the MariaDB CHECK constraint.
 */
enum TouchTemplate: string
{
    case FirstMs = 'first_ms';
    case FirstEn = 'first_en';
    case Followup = 'followup';
    case Price = 'price';
    case Other = 'other';

    /**
     * @return list<string>
     */
    public static function values(): array
    {
        return array_map(fn (self $template) => $template->value, self::cases());
    }
}
