<?php

namespace App\Http\Resources\Marketing;

use App\Models\MarketingTouch;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * Prospect `touches[]` item: {id, channel, template, sent_at, note}.
 *
 * @property-read MarketingTouch $resource
 */
class TouchResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $t = $this->resource;

        return [
            'id' => $t->id,
            'channel' => $t->channel,
            'template' => $t->template->value,
            'sent_at' => $t->sent_at->toIso8601ZuluString(),
            'note' => $t->note,
        ];
    }
}
