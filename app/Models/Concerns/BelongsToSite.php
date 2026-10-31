<?php

namespace App\Models\Concerns;

use App\Models\Site;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

/**
 * Every shop table carries `site_id`. All reads and writes in the shop domain
 * go through `forSite()` so a tenant can never see another tenant's rows.
 */
trait BelongsToSite
{
    /**
     * @return BelongsTo<Site, $this>
     */
    public function site(): BelongsTo
    {
        return $this->belongsTo(Site::class);
    }

    /**
     * @param  Builder<static>  $query
     * @return Builder<static>
     */
    public function scopeForSite(Builder $query, Site|int $site): Builder
    {
        return $query->where($this->qualifyColumn('site_id'), $site instanceof Site ? $site->id : $site);
    }
}
