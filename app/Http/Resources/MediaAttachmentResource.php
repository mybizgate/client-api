<?php

namespace App\Http\Resources;

use App\Models\MediaAttachment;
use App\Services\MediaApiClient;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * @property-read MediaAttachment $resource
 */
class MediaAttachmentResource extends JsonResource
{
    public static $wrap = 'data';

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $attachment = $this->resource;

        // media-api URLs only; this API never knows or returns storage paths.
        // thumbnail_url answers 404 on media-api for documents (type "file").
        return [
            'id' => $attachment->id,
            'entity_type' => $attachment->entity_type,
            'entity_id' => $attachment->entity_id,
            'media_id' => $attachment->media_id,
            'role' => $attachment->role,
            'sort_order' => $attachment->sort_order,
            'created_at' => $attachment->created_at?->toIso8601String(),
            ...app(MediaApiClient::class)->urls($attachment->media_id),
            'media' => $this->when(isset($this->additional['media']), fn () => $this->additional['media']),
        ];
    }
}
