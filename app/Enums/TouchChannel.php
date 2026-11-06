<?php

namespace App\Enums;

/**
 * Channel of a marketing touch (marketing_touches.channel). The contract
 * only uses whatsapp today; validated by the application only (no CHECK).
 */
enum TouchChannel: string
{
    case Whatsapp = 'whatsapp';
    case Call = 'call';
    case Email = 'email';
    case Instagram = 'instagram';
    case Facebook = 'facebook';
    case Other = 'other';

    /**
     * @return list<string>
     */
    public static function values(): array
    {
        return array_map(fn (self $channel) => $channel->value, self::cases());
    }
}
