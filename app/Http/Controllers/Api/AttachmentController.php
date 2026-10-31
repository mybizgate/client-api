<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreAttachmentRequest;
use App\Http\Resources\MediaAttachmentResource;
use App\Models\MediaAttachment;
use App\Models\Site;
use App\Services\AttachmentService;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

/**
 * Attachments of a business record (media-api/attachment_integration.md).
 * Tenant comes from the `site` middleware (X-Client-Code), never from the
 * body; the caller must be owner/staff of that site (`site.staff`). Entity
 * types with a `model` in config/attachments.php must exist in the site.
 */
class AttachmentController extends Controller
{
    public function __construct(private readonly AttachmentService $attachments) {}

    public function index(Request $request, string $entityType, string $entityId): AnonymousResourceCollection
    {
        $this->assertEntity($request, $entityType, $entityId);

        $rows = MediaAttachment::query()
            ->forEntity($this->tenant($request), $entityType, $entityId)
            ->when($request->filled('role'), fn ($q) => $q->where('role', $request->string('role')))
            ->orderBy('role')
            ->orderBy('sort_order')
            ->orderBy('created_at')
            ->get();

        return MediaAttachmentResource::collection($rows);
    }

    public function store(StoreAttachmentRequest $request, string $entityType, string $entityId): JsonResponse
    {
        $this->assertEntity($request, $entityType, $entityId);

        $tenant = $this->tenant($request);
        $role = $request->role();

        $result = $request->hasFile('file')
            ? $this->attachments->attachUpload($tenant, $entityType, $entityId, $request->file('file'), $role)
            : $this->attachments->attachExisting($tenant, $entityType, $entityId, $request->string('media_id')->toString(), $role);

        $created = $result['attachment']->wasRecentlyCreated;

        return (new MediaAttachmentResource($result['attachment']))
            ->additional(['media' => $result['media']])
            ->response()
            ->setStatusCode($created ? 201 : 200);
    }

    public function destroy(Request $request, string $attachmentId): JsonResponse
    {
        $attachment = MediaAttachment::query()
            ->forTenant($this->tenant($request))
            ->find($attachmentId);

        abort_unless($attachment !== null, 404, 'Attachment not found.');

        $this->attachments->detach($attachment);

        return response()->json([
            'data' => ['id' => $attachment->id, 'media_id' => $attachment->media_id, 'detached' => true],
        ]);
    }

    private function tenant(Request $request): string
    {
        return (string) $request->attributes->get('tenant');
    }

    private function assertEntity(Request $request, string $entityType, string $entityId): void
    {
        abort_unless(
            array_key_exists($entityType, (array) config('attachments.entity_types')),
            404,
            'Unknown entity type.'
        );

        abort_unless(
            preg_match(config('attachments.patterns.entity_id'), $entityId) === 1,
            422,
            'The entity id may only contain letters, digits, ".", "-" and "_" (max 64).'
        );

        $model = config("attachments.entity_types.{$entityType}.model");
        $site = $request->attributes->get('site');

        if (is_string($model) && $site instanceof Site) {
            abort_unless(ctype_digit($entityId), 404, 'Record not found.');

            /** @var class-string<Model> $model */
            $exists = $model::query()->where('site_id', $site->id)->whereKey((int) $entityId)->exists();

            abort_unless($exists, 404, 'Record not found.');
        }
    }
}
