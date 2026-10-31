<?php

namespace App\Enums;

/** shop_orders.fulfilment_method (Order.fulfilment). */
enum FulfilmentMethod: string
{
    case Delivery = 'delivery';
    case Pickup = 'pickup';

    /**
     * @return list<string>
     */
    public static function values(): array
    {
        return array_map(fn (self $method) => $method->value, self::cases());
    }
}
