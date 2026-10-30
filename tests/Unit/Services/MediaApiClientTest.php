<?php

namespace Tests\Unit\Services;

use App\Services\MediaApiClient;
use Illuminate\Http\Client\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Http;
use Illuminate\Validation\ValidationException;
use Tests\TestCase;

class MediaApiClientTest extends TestCase
{
    private const BASE = 'https://media-api.test/api/v1';

    /** 1x1 PNG so tests do not need the GD extension. */
    private const PNG = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';

    private const MEDIA_ID = '01m639sgg2275fr73b2gb9s91r';

    protected function setUp(): void
    {
        parent::setUp();

        config(['services.media_api.base_url' => self::BASE.'/']);
    }

    private function client(): MediaApiClient
    {
        return app(MediaApiClient::class);
    }

    /** Value of a plain field inside a multipart request (null when absent). */
    private static function field(Request $request, string $name): ?string
    {
        $part = collect($request->data())->firstWhere('name', $name);

        return $part === null ? null : (string) $part['contents'];
    }

    public function test_urls_are_built_from_the_media_id_and_base_url(): void
    {
        $urls = $this->client()->urls(self::MEDIA_ID);

        $this->assertSame(self::BASE.'/media/'.self::MEDIA_ID, $urls['view_url']);
        $this->assertSame(self::BASE.'/media/'.self::MEDIA_ID.'/thumbnail', $urls['thumbnail_url']);
        $this->assertSame(self::BASE.'/media/'.self::MEDIA_ID.'/metadata', $urls['metadata_url']);
        $this->assertSame(self::BASE.'/media/'.self::MEDIA_ID.'/download', $urls['download_url']);
    }

    public function test_upload_posts_multipart_with_tenant_header_and_returns_data(): void
    {
        Http::fake([self::BASE.'/media' => Http::response([
            'success' => true,
            'data' => ['id' => self::MEDIA_ID, 'tenant' => 'lzhub', 'type' => 'image'],
        ], 201)]);

        $data = $this->client()->upload(UploadedFile::fake()->createWithContent('photo.png', base64_decode(self::PNG)), 'lzhub', 'products', '101');

        $this->assertSame(self::MEDIA_ID, $data['id']);

        Http::assertSent(function (Request $request): bool {
            return $request->method() === 'POST'
                && $request->url() === self::BASE.'/media'
                && $request->hasHeader('X-Client-Code', 'lzhub')
                && $request->hasHeader('Accept', 'application/json')
                && $request->isMultipart()
                && $request->hasFile('file', null, 'photo.png')
                && self::field($request, 'module') === 'products'
                && self::field($request, 'entity_id') === '101';
        });
    }

    public function test_upload_omits_entity_id_when_null(): void
    {
        Http::fake([self::BASE.'/media' => Http::response(['success' => true, 'data' => ['id' => self::MEDIA_ID]], 201)]);

        $this->client()->upload(UploadedFile::fake()->createWithContent('photo.png', base64_decode(self::PNG)), 'lzhub', 'products');

        Http::assertSent(fn (Request $request): bool => self::field($request, 'module') === 'products' && self::field($request, 'entity_id') === null);
    }

    public function test_upload_turns_media_api_422_into_a_validation_exception(): void
    {
        Http::fake([self::BASE.'/media' => Http::response([
            'success' => false,
            'message' => 'Validation failed.',
            'errors' => ['file' => ['The file type is not allowed.']],
        ], 422)]);

        try {
            $this->client()->upload(UploadedFile::fake()->create('x.exe', 10), 'lzhub', 'products');
            $this->fail('Expected a ValidationException.');
        } catch (ValidationException $e) {
            $this->assertSame(['file' => ['The file type is not allowed.']], $e->errors());
        }
    }

    public function test_metadata_rejects_unknown_ids_and_other_tenants(): void
    {
        Http::fake([
            self::BASE.'/media/'.self::MEDIA_ID.'/metadata' => Http::response(['success' => false, 'message' => 'Not found.'], 404),
            self::BASE.'/media/01m639sgg2275fr73b2gb9s91s/metadata' => Http::response(['success' => true, 'data' => ['tenant' => 'other']]),
        ]);

        $this->expectException(ValidationException::class);
        $this->client()->metadata(self::MEDIA_ID, 'lzhub');
    }

    public function test_metadata_rejects_when_tenant_does_not_match(): void
    {
        Http::fake([self::BASE.'/media/'.self::MEDIA_ID.'/metadata' => Http::response(['success' => true, 'data' => ['tenant' => 'other']])]);

        $this->expectException(ValidationException::class);
        $this->client()->metadata(self::MEDIA_ID, 'lzhub');
    }

    public function test_metadata_returns_data_for_the_owning_tenant(): void
    {
        Http::fake([self::BASE.'/media/'.self::MEDIA_ID.'/metadata' => Http::response(['success' => true, 'data' => ['id' => self::MEDIA_ID, 'tenant' => 'lzhub', 'type' => 'image']])]);

        $data = $this->client()->metadata(self::MEDIA_ID, 'lzhub');

        $this->assertSame('image', $data['type']);
        Http::assertSent(fn (Request $request): bool => $request->method() === 'GET' && $request->hasHeader('X-Client-Code', 'lzhub'));
    }

    public function test_assign_patches_entity_id_and_clears_with_empty_string(): void
    {
        Http::fake([self::BASE.'/media/'.self::MEDIA_ID => Http::response(['success' => true, 'data' => ['id' => self::MEDIA_ID, 'entity_id' => null]])]);

        $this->client()->assign(self::MEDIA_ID, 'lzhub', '101');
        $this->client()->assign(self::MEDIA_ID, 'lzhub', null);

        Http::assertSent(fn (Request $request): bool => $request->method() === 'PATCH' && $request['entity_id'] === '101');
        Http::assertSent(fn (Request $request): bool => $request->method() === 'PATCH' && $request['entity_id'] === '');
    }

    public function test_assign_rejects_unknown_ids(): void
    {
        Http::fake([self::BASE.'/media/'.self::MEDIA_ID => Http::response(['success' => false, 'message' => 'Not found.'], 404)]);

        $this->expectException(ValidationException::class);
        $this->client()->assign(self::MEDIA_ID, 'lzhub', '101');
    }

    public function test_delete_sends_delete_with_tenant_header(): void
    {
        Http::fake([self::BASE.'/media/'.self::MEDIA_ID => Http::response(['success' => true, 'data' => ['id' => self::MEDIA_ID, 'deleted' => true]])]);

        $this->client()->delete(self::MEDIA_ID, 'lzhub');

        Http::assertSent(fn (Request $request): bool => $request->method() === 'DELETE' && $request->hasHeader('X-Client-Code', 'lzhub'));
    }
}
