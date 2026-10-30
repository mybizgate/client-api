<?php

namespace App\Services;

use Illuminate\Http\Client\PendingRequest;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Http;
use Illuminate\Validation\ValidationException;

/**
 * HTTP adapter for media-api (media-api/attachment_integration.md §5).
 *
 * media-api keeps the bytes and metadata; this API only ever stores the
 * 26-char media id it returns and exposes the URLs media-api builds.
 * The tenant is always sent as X-Client-Code and never comes from a request body.
 */
class MediaApiClient
{
    private function request(string $tenant): PendingRequest
    {
        return Http::acceptJson()
            ->withHeaders(['X-Client-Code' => $tenant])
            ->connectTimeout(10)
            ->timeout(60);
    }

    public function url(string $path): string
    {
        return rtrim((string) config('services.media_api.base_url'), '/').$path;
    }

    /**
     * Public URLs of a media item, derived from its id (media-api URLs are
     * stable, so no round trip is needed to list attachments).
     *
     * @return array{view_url: string, thumbnail_url: string, metadata_url: string, download_url: string}
     */
    public function urls(string $mediaId): array
    {
        return [
            'view_url' => $this->url("/media/{$mediaId}"),
            'thumbnail_url' => $this->url("/media/{$mediaId}/thumbnail"),
            'metadata_url' => $this->url("/media/{$mediaId}/metadata"),
            'download_url' => $this->url("/media/{$mediaId}/download"),
        ];
    }

    /**
     * POST /media. Returns the media-api `data` object of the new item.
     *
     * @return array<string, mixed>
     */
    public function upload(UploadedFile $file, string $tenant, string $module, ?string $entityId = null): array
    {
        $response = $this->request($tenant)
            ->attach('file', fopen($file->getRealPath(), 'rb'), $file->getClientOriginalName())
            ->post($this->url('/media'), array_filter([
                'module' => $module,
                'entity_id' => $entityId,
            ]));

        if ($response->status() === 422) {
            throw ValidationException::withMessages(
                $response->json('errors') ?: ['file' => [(string) $response->json('message')]]
            );
        }

        $response->throw();

        return $response->json('data');
    }

    /**
     * GET /media/{id}/metadata. Fails unless the id exists and belongs to
     * $tenant (media-api answers 404 for another tenant's id).
     *
     * @return array<string, mixed>
     */
    public function metadata(string $mediaId, string $tenant): array
    {
        $response = $this->request($tenant)->get($this->url("/media/{$mediaId}/metadata"));

        if ($response->status() === 404 || $response->json('data.tenant') !== $tenant) {
            throw ValidationException::withMessages(['media_id' => ['Media not found for this tenant.']]);
        }

        $response->throw();

        return $response->json('data');
    }

    /**
     * PATCH /media/{id}: link an already uploaded item to a record (null clears the link).
     *
     * @return array<string, mixed>
     */
    public function assign(string $mediaId, string $tenant, ?string $entityId): array
    {
        $response = $this->request($tenant)
            ->patch($this->url("/media/{$mediaId}"), ['entity_id' => $entityId ?? '']);

        if ($response->status() === 404) {
            throw ValidationException::withMessages(['media_id' => ['Media not found for this tenant.']]);
        }

        return $response->throw()->json('data');
    }

    /**
     * DELETE /media/{id}. Physical deletion: only call once no record in any
     * consuming API references the id (nothing in media-api tracks usage).
     */
    public function delete(string $mediaId, string $tenant): void
    {
        $this->request($tenant)->delete($this->url("/media/{$mediaId}"))->throw();
    }
}
