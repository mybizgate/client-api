<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Concerns\HasUlids;
use Illuminate\Database\Eloquent\Model;

/**
 * A link between a business record and a media-api item. Deleting a row only
 * detaches the file; it never deletes anything in media-api.
 *
 * @property string $id
 * @property string $tenant_id
 * @property string $entity_type
 * @property string $entity_id
 * @property string $media_id
 * @property string $role
 * @property string|null $slot
 * @property int $sort_order
 */
class MediaAttachment extends Model
{
    use HasUlids;

    protected $fillable = [
        'tenant_id',
        'entity_type',
        'entity_id',
        'media_id',
        'role',
        'slot',
        'sort_order',
    ];

    protected function casts(): array
    {
        return [
            'sort_order' => 'integer',
        ];
    }

    /**
     * @param  Builder<MediaAttachment>  $query
     * @return Builder<MediaAttachment>
     */
    public function scopeForTenant(Builder $query, string $tenant): Builder
    {
        return $query->where('tenant_id', $tenant);
    }

    /**
     * @param  Builder<MediaAttachment>  $query
     * @return Builder<MediaAttachment>
     */
    public function scopeForEntity(Builder $query, string $tenant, string $entityType, string $entityId): Builder
    {
        return $query->forTenant($tenant)
            ->where('entity_type', $entityType)
            ->where('entity_id', $entityId);
    }
}
