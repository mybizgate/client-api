<?php

namespace App\Enums;

/** Who caused an order status change (shop_order_status_history.actor_type). */
enum ActorType: string
{
    case Customer = 'customer';
    case Staff = 'staff';
    case System = 'system';
}
