<?php

namespace App\Services\Shop;

use App\Models\ShopSetting;
use Illuminate\Support\Carbon;

/**
 * `{prefix}-{YYYYMMDD}-{NNNN}` references (SHOP_DESIGN.md §5.5, decision
 * §13.2), e.g. LZ-20261031-0017. The caller must pass the settings row
 * locked with `lockForUpdate()` inside the order transaction.
 */
class OrderReferenceService
{
    public const string TIMEZONE = 'Asia/Kuala_Lumpur';

    public function next(ShopSetting $lockedSettings): string
    {
        $number = $lockedSettings->next_order_number;
        $lockedSettings->next_order_number = $number + 1;
        $lockedSettings->save();

        return sprintf(
            '%s-%s-%s',
            $lockedSettings->reference_prefix,
            Carbon::now(self::TIMEZONE)->format('Ymd'),
            str_pad((string) $number, 4, '0', STR_PAD_LEFT)
        );
    }
}
