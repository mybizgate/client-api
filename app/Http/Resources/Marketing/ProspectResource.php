<?php

namespace App\Http\Resources\Marketing;

use App\Models\MarketingProspect;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * API_CONTRACT.md "Prospect record"; with `withTouches` also `touches[]`
 * (newest first) for GET /marketing/prospects/{id}. Load `touches_count`
 * with `withCount('touchHistory as touches_count')` to avoid one count query per record.
 *
 * @property-read MarketingProspect $resource
 */
class ProspectResource extends JsonResource
{
    public static $wrap = 'data';

    public function __construct(MarketingProspect $resource, private readonly bool $withTouches = false)
    {
        parent::__construct($resource);
    }

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $p = $this->resource;

        $data = [
            'id' => $p->id,
            'name' => $p->name,
            'phone' => $p->phone,
            'phone_display' => $p->phone_display,
            'category' => $p->category,
            'area' => $p->area,
            'state' => $p->state,
            'channel' => $p->channel,
            'website' => $p->website->value,
            'priority' => $p->priority->value,
            'status' => $p->status->value,
            'demo_slug' => $p->demo_slug,
            'notes' => $p->notes,
            'last_touch_at' => $p->last_touch_at?->toIso8601ZuluString(),
            'touches_count' => (int) ($p->touches_count ?? $p->touchHistory()->count()),
            'created_at' => $p->created_at?->toIso8601ZuluString(),
            'updated_at' => $p->updated_at?->toIso8601ZuluString(),
        ];

        if ($this->withTouches) {
            $data['touches'] = TouchResource::collection(
                $p->touchHistory()->orderByDesc('sent_at')->orderByDesc('id')->get()
            )->resolve($request);
        }

        return $data;
    }
}
