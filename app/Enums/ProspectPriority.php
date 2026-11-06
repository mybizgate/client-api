<?php

namespace App\Enums;

/**
 * Outreach priority of a marketing prospect (marketing_prospects.priority),
 * A highest. Mirrors the MariaDB CHECK constraint.
 */
enum ProspectPriority: string
{
    case A = 'A';
    case B = 'B';
    case C = 'C';
    case D = 'D';

    /**
     * @return list<string>
     */
    public static function values(): array
    {
        return array_map(fn (self $priority) => $priority->value, self::cases());
    }
}
