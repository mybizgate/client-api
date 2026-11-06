<?php

namespace App\Enums;

/**
 * Pipeline status of a marketing prospect (marketing_prospects.status).
 * Mirrors the MariaDB CHECK constraint. Any status may be set by hand; the
 * only automatic change is New → Contacted on the first touch.
 */
enum ProspectStatus: string
{
    case New = 'new';
    case Contacted = 'contacted';
    case Replied = 'replied';
    case DemoViewed = 'demo_viewed';
    case Won = 'won';
    case Lost = 'lost';
    case DoNotContact = 'do_not_contact';

    /**
     * @return list<string>
     */
    public static function values(): array
    {
        return array_map(fn (self $status) => $status->value, self::cases());
    }
}
