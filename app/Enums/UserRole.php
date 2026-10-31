<?php

namespace App\Enums;

/** users.role; `owner` and `staff` may use the management API. */
enum UserRole: string
{
    case Owner = 'owner';
    case Staff = 'staff';
    case Customer = 'customer';

    public function isStaff(): bool
    {
        return $this === self::Owner || $this === self::Staff;
    }
}
