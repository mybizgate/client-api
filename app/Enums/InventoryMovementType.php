<?php

namespace App\Enums;

/** Reason of a stock ledger row (shop_inventory_movements.movement_type). */
enum InventoryMovementType: string
{
    case Opening = 'opening';
    case Restock = 'restock';
    case Sale = 'sale';
    case Adjustment = 'adjustment';
    case Return = 'return';
    case Cancellation = 'cancellation';

    /**
     * Types staff may record by hand through the inventory endpoint.
     *
     * @return list<string>
     */
    public static function manualValues(): array
    {
        return [self::Restock->value, self::Adjustment->value, self::Return->value];
    }
}
