<?php

namespace App\Enums;

/**
 * Order workflow states, exactly the frontend `OrderStatus` union
 * (SHOP_DESIGN.md §5.5). Transitions live in App\Services\Shop\OrderWorkflow.
 */
enum OrderStatus: string
{
    case DraftWhatsapp = 'draft_whatsapp';
    case PendingReview = 'pending_review';
    case Confirmed = 'confirmed';
    case Processing = 'processing';
    case Delivered = 'delivered';
    case Completed = 'completed';
    case Cancelled = 'cancelled';

    /**
     * @return list<string>
     */
    public static function values(): array
    {
        return array_map(fn (self $status) => $status->value, self::cases());
    }

    public function isTerminal(): bool
    {
        return $this === self::Completed || $this === self::Cancelled;
    }

    /** Statuses a customer may still cancel from (frontend OPEN_STATUSES). */
    public function isOpen(): bool
    {
        return in_array($this, [self::DraftWhatsapp, self::PendingReview, self::Confirmed, self::Processing], true);
    }
}
