<?php

namespace App\Http\Controllers\Api\Marketing;

use App\Enums\ProspectPriority;
use App\Enums\ProspectStatus;
use App\Http\Controllers\Api\Shop\ShopController;
use App\Models\MarketingProspect;
use App\Models\MarketingTouch;
use Carbon\CarbonInterface;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * GET /marketing/summary for the dashboard. "Today" and "this week"
 * (Monday start) are Malaysian calendar days, compared in UTC.
 */
class SummaryController extends ShopController
{
    public const string TIMEZONE = 'Asia/Kuala_Lumpur';

    public function __invoke(Request $request): JsonResponse
    {
        $site = $this->site($request);
        $now = now(self::TIMEZONE);

        $byStatus = array_fill_keys(ProspectStatus::values(), 0);
        $byPriority = array_fill_keys(ProspectPriority::values(), 0);

        $rows = MarketingProspect::query()->forSite($site)
            ->toBase()
            ->selectRaw('status, priority, COUNT(*) AS aggregate, COUNT(phone) AS with_phone')
            ->groupBy('status', 'priority')
            ->get();

        foreach ($rows as $row) {
            $byStatus[$row->status] = ($byStatus[$row->status] ?? 0) + (int) $row->aggregate;
            $byPriority[$row->priority] = ($byPriority[$row->priority] ?? 0) + (int) $row->aggregate;
        }

        $sentSince = fn (CarbonInterface $from): int => MarketingTouch::query()->forSite($site)->where('sent_at', '>=', $from->utc())->count();

        return response()->json(['data' => [
            'total' => (int) $rows->sum('aggregate'),
            'by_status' => $byStatus,
            'by_priority' => $byPriority,
            'with_phone' => (int) $rows->sum('with_phone'),
            'sent_today' => $sentSince($now->copy()->startOfDay()),
            'sent_this_week' => $sentSince($now->copy()->startOfWeek(CarbonInterface::MONDAY)),
        ]]);
    }
}
