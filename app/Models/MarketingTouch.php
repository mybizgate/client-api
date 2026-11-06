<?php

namespace App\Models;

use App\Enums\TouchTemplate;
use App\Models\Concerns\BelongsToSite;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Support\Carbon;

/**
 * One outreach message sent to a marketing prospect; append-only.
 *
 * @property int $id
 * @property int $site_id
 * @property int $prospect_id
 * @property string $channel
 * @property TouchTemplate $template
 * @property string|null $note
 * @property Carbon $sent_at
 * @property Carbon|null $created_at
 */
#[Fillable(['site_id', 'prospect_id', 'channel', 'template', 'note', 'sent_at'])]
class MarketingTouch extends Model
{
    use BelongsToSite;

    public const null UPDATED_AT = null;

    protected $table = 'marketing_touches';

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'prospect_id' => 'integer',
            'template' => TouchTemplate::class,
            'sent_at' => 'datetime',
        ];
    }

    /**
     * @return BelongsTo<MarketingProspect, $this>
     */
    public function prospect(): BelongsTo
    {
        return $this->belongsTo(MarketingProspect::class, 'prospect_id');
    }
}
