<?php

namespace App\Services;

use App\Models\MediaAttachment;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Illuminate\Validation\ValidationException;
use Throwable;

/**
 * Attaches media-api items to business records (attachment_integration.md §4-§5).
 *
 * Two entry points: upload a new file through this API, or link an id the
 * browser already uploaded straight to media-api. Both end in one local row.
 */
class AttachmentService
{
    public function __construct(private readonly MediaApiClient $mediaApi) {}

    /**
     * Browser → this API → media-api: upload, then record the link.
     *
     * @return array{attachment: MediaAttachment, media: array<string, mixed>}
     */
    public function attachUpload(string $tenant, string $entityType, string $entityId, UploadedFile $file, string $role): array
    {
        $media = $this->mediaApi->upload($file, $tenant, $this->moduleFor($entityType), $entityId);

        $this->assertRoleAcceptsType($role, (string) ($media['type'] ?? ''));

        return [
            'attachment' => $this->persist($tenant, $entityType, $entityId, $media['id'], $role),
            'media' => $media,
        ];
    }

    /**
     * Browser → media-api → id → this API: verify the id belongs to the tenant,
     * point media-api's own entity_id at the record, then record the link.
     *
     * @return array{attachment: MediaAttachment, media: array<string, mixed>}
     */
    public function attachExisting(string $tenant, string $entityType, string $entityId, string $mediaId, string $role): array
    {
        $media = $this->mediaApi->metadata($mediaId, $tenant);

        $this->assertRoleAcceptsType($role, (string) ($media['type'] ?? ''));

        if (($media['entity_id'] ?? null) !== $entityId) {
            $media = $this->mediaApi->assign($mediaId, $tenant, $entityId);
        }

        return [
            'attachment' => $this->persist($tenant, $entityType, $entityId, $mediaId, $role),
            'media' => $media,
        ];
    }

    /**
     * Detach only: the media-api item is left untouched because other records
     * (or other consuming APIs) may still reference it.
     */
    public function detach(MediaAttachment $attachment): void
    {
        $attachment->delete();
    }

    public function moduleFor(string $entityType): string
    {
        return (string) config("attachments.entity_types.{$entityType}.module");
    }

    public function isSingleton(string $role): bool
    {
        return (bool) config("attachments.roles.{$role}.singleton", false);
    }

    private function assertRoleAcceptsType(string $role, string $mediaType): void
    {
        $accepted = (array) config("attachments.roles.{$role}.types", []);

        if (! in_array($mediaType, $accepted, true)) {
            throw ValidationException::withMessages([
                'media_id' => ["The {$role} role only accepts ".implode(' or ', $accepted).' media.'],
            ]);
        }
    }

    /**
     * One local transaction: a singleton role replaces the row in its slot,
     * a multi-file role appends after the current last item. Attaching the
     * same media twice in the same role is a no-op that returns the existing row.
     */
    private function persist(string $tenant, string $entityType, string $entityId, string $mediaId, string $role): MediaAttachment
    {
        try {
            return DB::transaction(function () use ($tenant, $entityType, $entityId, $mediaId, $role): MediaAttachment {
                $query = MediaAttachment::query()->forEntity($tenant, $entityType, $entityId);

                $existing = (clone $query)->where('media_id', $mediaId)->where('role', $role)->first();

                if ($existing !== null) {
                    return $existing;
                }

                if ($this->isSingleton($role)) {
                    (clone $query)->where('slot', $role)->delete();
                }

                $sortOrder = (int) (clone $query)->where('role', $role)->max('sort_order') + 1;

                return MediaAttachment::create([
                    'tenant_id' => $tenant,
                    'entity_type' => $entityType,
                    'entity_id' => $entityId,
                    'media_id' => $mediaId,
                    'role' => $role,
                    'slot' => $this->isSingleton($role) ? $role : null,
                    'sort_order' => $sortOrder,
                ]);
            });
        } catch (Throwable $e) {
            // The file already exists in media-api; keep the id so a cleanup job can find it.
            Log::warning('media_attachments row could not be written; media-api item is orphaned', [
                'tenant' => $tenant,
                'entity_type' => $entityType,
                'entity_id' => $entityId,
                'media_id' => $mediaId,
                'role' => $role,
                'error' => $e->getMessage(),
            ]);

            throw $e;
        }
    }
}
