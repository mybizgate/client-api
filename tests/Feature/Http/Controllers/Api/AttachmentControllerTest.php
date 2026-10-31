<?php

namespace Tests\Feature\Http\Controllers\Api;

use App\Models\MediaAttachment;
use App\Models\ShopCategory;
use App\Models\ShopProduct;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\Client\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Http;
use Tests\Feature\Shop\InteractsWithShop;
use Tests\TestCase;

/**
 * End-to-end flow of media-api/attachment_integration.md with media-api faked.
 * Since the shop domain, the routes require an owner/staff token of the site
 * and the product/category must exist in that site.
 */
class AttachmentControllerTest extends TestCase
{
    use InteractsWithShop;
    use RefreshDatabase;

    private const BASE = 'https://media-api.test/api/v1';

    /** 1x1 PNG so tests do not need the GD extension. */
    private const PNG = 'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==';

    private const IMAGE_ID = '01m639sgg2275fr73b2gb9s91r';

    private const SECOND_IMAGE_ID = '01m639sgg2275fr73b2gb9s91s';

    private const FILE_ID = '01m639sgg2275fr73b2gb9s91t';

    private string $token;

    private ShopProduct $product;

    private string $pid;

    protected function setUp(): void
    {
        parent::setUp();

        config(['services.media_api.base_url' => self::BASE]);
        $this->setUpShop();
        [, $this->token] = $this->staff('staff');
        $this->product = $this->product();
        $this->pid = (string) $this->product->id;
    }

    /** Value of a plain field inside a multipart request (null when absent). */
    private static function field(Request $request, string $name): ?string
    {
        $part = collect($request->data())->firstWhere('name', $name);

        return $part === null ? null : (string) $part['contents'];
    }

    /** @return array<string, string> */
    private function tenantHeaders(?string $token = null, string $tenant = 'lzhub'): array
    {
        return $this->headers($token ?? $this->token, $tenant);
    }

    private function url(?string $entityId = null): string
    {
        return '/api/v1/attachments/product/'.($entityId ?? $this->pid);
    }

    /** @return array<string, mixed> */
    private function mediaItem(string $id, string $type = 'image', ?string $entityId = 'product', string $tenant = 'lzhub'): array
    {
        return [
            'id' => $id,
            'tenant' => $tenant,
            'module' => 'products',
            'entity_id' => $entityId === 'product' ? $this->pid : $entityId,
            'type' => $type,
            'visibility' => 'public',
            'view_url' => self::BASE."/media/{$id}",
            'thumbnail_url' => $type === 'image' ? self::BASE."/media/{$id}/thumbnail" : null,
        ];
    }

    /**
     * One fake that answers every media-api call the controller may make.
     *
     * @param  array<string, array<string, mixed>>  $items  media id → metadata object
     */
    private function fakeMediaApi(array $items, string $uploadedId = self::IMAGE_ID, string $uploadedType = 'image'): void
    {
        Http::fake(function (Request $request) use ($items, $uploadedId, $uploadedType) {
            $path = parse_url($request->url(), PHP_URL_PATH);

            if ($request->method() === 'POST' && $path === '/api/v1/media') {
                return Http::response(['success' => true, 'data' => $this->mediaItem($uploadedId, $uploadedType, self::field($request, 'entity_id'))], 201);
            }

            if (preg_match('#^/api/v1/media/([0-9a-z]{26})(/metadata)?$#', (string) $path, $m) === 1) {
                $item = $items[$m[1]] ?? null;

                if ($item === null || $item['tenant'] !== $request->header('X-Client-Code')[0]) {
                    return Http::response(['success' => false, 'message' => 'Media not found.'], 404);
                }

                if ($request->method() === 'PATCH') {
                    $item['entity_id'] = $request['entity_id'] === '' ? null : $request['entity_id'];
                }

                return Http::response(['success' => true, 'data' => $item]);
            }

            return Http::response(['success' => false, 'message' => 'Unexpected call: '.$request->method().' '.$request->url()], 500);
        });
    }

    public function test_attachment_routes_require_a_valid_tenant_header_and_a_staff_token(): void
    {
        $this->getJson($this->url())->assertStatus(400);
        $this->getJson($this->url(), ['X-Client-Code' => 'Bad Code'])->assertStatus(400);
        $this->getJson($this->url(), $this->headers())->assertStatus(401);

        [, $foreign] = $this->staff('owner', $this->otherSite());
        $this->getJson($this->url(), $this->tenantHeaders($foreign))->assertStatus(403);
    }

    public function test_unknown_entity_types_and_missing_records_are_not_found(): void
    {
        $this->getJson('/api/v1/attachments/invoice/101', $this->tenantHeaders())->assertStatus(404);
        $this->getJson($this->url('999999'), $this->tenantHeaders())->assertStatus(404);
        $this->getJson($this->url('abc'), $this->tenantHeaders())->assertStatus(404);

        // A product of another site is "not found" here even with a valid local token.
        $foreignProduct = ShopProduct::factory()->forCategory(ShopCategory::factory()->create(['site_id' => $this->otherSite()->id]))->create();
        $this->getJson($this->url((string) $foreignProduct->id), $this->tenantHeaders())->assertStatus(404);

        // Categories are an entity type too.
        $this->getJson('/api/v1/attachments/category/'.$this->category->id, $this->tenantHeaders())->assertOk()->assertExactJson(['data' => []]);
    }

    public function test_uploading_a_file_sends_it_to_media_api_and_stores_only_the_media_id(): void
    {
        $this->fakeMediaApi([]);

        $response = $this->post($this->url(), [
            'file' => UploadedFile::fake()->createWithContent('product.png', base64_decode(self::PNG)),
            'role' => 'gallery',
        ], $this->tenantHeaders());

        $response->assertCreated()
            ->assertJsonPath('data.media_id', self::IMAGE_ID)
            ->assertJsonPath('data.entity_type', 'product')
            ->assertJsonPath('data.entity_id', $this->pid)
            ->assertJsonPath('data.role', 'gallery')
            ->assertJsonPath('data.sort_order', 1)
            ->assertJsonPath('data.view_url', self::BASE.'/media/'.self::IMAGE_ID)
            ->assertJsonPath('data.thumbnail_url', self::BASE.'/media/'.self::IMAGE_ID.'/thumbnail')
            ->assertJsonPath('data.media.id', self::IMAGE_ID);

        $this->assertStringNotContainsString('tenants/', $response->getContent());

        Http::assertSent(function (Request $request): bool {
            return $request->method() === 'POST'
                && $request->url() === self::BASE.'/media'
                && $request->hasHeader('X-Client-Code', 'lzhub')
                && $request->hasFile('file', null, 'product.png')
                && self::field($request, 'module') === 'products'
                && self::field($request, 'entity_id') === $this->pid;
        });

        $this->assertDatabaseHas('media_attachments', [
            'tenant_id' => 'lzhub',
            'entity_type' => 'product',
            'entity_id' => $this->pid,
            'media_id' => self::IMAGE_ID,
            'role' => 'gallery',
            'slot' => null,
            'sort_order' => 1,
        ]);
    }

    public function test_media_api_validation_errors_are_passed_through_as_422(): void
    {
        Http::fake([self::BASE.'/media' => Http::response([
            'success' => false,
            'message' => 'Validation failed.',
            'errors' => ['file' => ['The file type is not allowed.']],
        ], 422)]);

        $this->post($this->url(), [
            'file' => UploadedFile::fake()->create('notes.txt', 5, 'text/plain'),
        ], $this->tenantHeaders())
            ->assertStatus(422)
            ->assertJsonPath('errors.file.0', 'The file type is not allowed.');

        $this->assertDatabaseCount('media_attachments', 0);
    }

    public function test_image_only_roles_reject_documents_before_uploading(): void
    {
        Http::fake();

        $this->post($this->url(), [
            'file' => UploadedFile::fake()->create('manual.pdf', 5, 'application/pdf'),
            'role' => 'primary',
        ], $this->tenantHeaders())
            ->assertStatus(422)
            ->assertJsonValidationErrors(['file']);

        Http::assertNothingSent();
    }

    public function test_linking_an_existing_id_verifies_it_and_assigns_the_entity_in_media_api(): void
    {
        $this->fakeMediaApi([self::IMAGE_ID => $this->mediaItem(self::IMAGE_ID, 'image', null)]);

        $this->postJson($this->url(), [
            'media_id' => self::IMAGE_ID,
            'role' => 'primary',
        ], $this->tenantHeaders())
            ->assertCreated()
            ->assertJsonPath('data.role', 'primary')
            ->assertJsonPath('data.media.entity_id', $this->pid);

        Http::assertSent(fn (Request $r): bool => $r->method() === 'GET' && str_ends_with($r->url(), '/media/'.self::IMAGE_ID.'/metadata'));
        Http::assertSent(fn (Request $r): bool => $r->method() === 'PATCH' && str_ends_with($r->url(), '/media/'.self::IMAGE_ID) && $r['entity_id'] === $this->pid);

        $this->assertDatabaseHas('media_attachments', ['media_id' => self::IMAGE_ID, 'role' => 'primary', 'slot' => 'primary']);

        // The public catalogue now serves the image first.
        $this->getJson('/api/v1/products/'.$this->product->slug, $this->headers())
            ->assertOk()
            ->assertJsonPath('data.images.0', self::BASE.'/media/'.self::IMAGE_ID);
    }

    public function test_linking_does_not_reassign_when_media_api_already_points_at_the_record(): void
    {
        $this->fakeMediaApi([self::IMAGE_ID => $this->mediaItem(self::IMAGE_ID, 'image', 'product')]);

        $this->postJson($this->url(), ['media_id' => self::IMAGE_ID], $this->tenantHeaders())
            ->assertCreated();

        Http::assertNotSent(fn (Request $r): bool => $r->method() === 'PATCH');
    }

    public function test_linking_another_tenants_media_fails_validation(): void
    {
        $this->fakeMediaApi([self::IMAGE_ID => $this->mediaItem(self::IMAGE_ID, 'image', null, 'other-tenant')]);

        $this->postJson($this->url(), ['media_id' => self::IMAGE_ID], $this->tenantHeaders())
            ->assertStatus(422)
            ->assertJsonValidationErrors(['media_id']);

        $this->assertDatabaseCount('media_attachments', 0);
    }

    public function test_linking_a_document_to_an_image_role_fails_validation(): void
    {
        $this->fakeMediaApi([self::FILE_ID => $this->mediaItem(self::FILE_ID, 'file')]);

        $this->postJson($this->url(), ['media_id' => self::FILE_ID, 'role' => 'primary'], $this->tenantHeaders())
            ->assertStatus(422)
            ->assertJsonValidationErrors(['media_id']);

        $this->postJson($this->url(), ['media_id' => self::FILE_ID, 'role' => 'attachment'], $this->tenantHeaders())
            ->assertCreated();
    }

    public function test_store_requires_exactly_one_of_file_or_media_id(): void
    {
        Http::fake();

        $this->postJson($this->url(), [], $this->tenantHeaders())
            ->assertStatus(422)
            ->assertJsonValidationErrors(['file', 'media_id']);

        $this->postJson($this->url(), ['media_id' => 'not-a-ulid'], $this->tenantHeaders())
            ->assertStatus(422)
            ->assertJsonValidationErrors(['media_id']);

        $this->postJson($this->url(), ['media_id' => self::IMAGE_ID, 'role' => 'hero'], $this->tenantHeaders())
            ->assertStatus(422)
            ->assertJsonValidationErrors(['role']);

        Http::assertNothingSent();
    }

    public function test_a_singleton_role_replaces_the_previous_row_in_its_slot(): void
    {
        $this->fakeMediaApi([
            self::IMAGE_ID => $this->mediaItem(self::IMAGE_ID),
            self::SECOND_IMAGE_ID => $this->mediaItem(self::SECOND_IMAGE_ID),
        ]);

        $this->postJson($this->url(), ['media_id' => self::IMAGE_ID, 'role' => 'primary'], $this->tenantHeaders())->assertCreated();
        $this->postJson($this->url(), ['media_id' => self::SECOND_IMAGE_ID, 'role' => 'primary'], $this->tenantHeaders())->assertCreated();

        $primary = MediaAttachment::query()->forEntity('lzhub', 'product', $this->pid)->where('role', 'primary')->get();

        $this->assertCount(1, $primary);
        $this->assertSame(self::SECOND_IMAGE_ID, $primary->first()->media_id);

        // Replacing a primary never deletes the old file in media-api.
        Http::assertNotSent(fn (Request $r): bool => $r->method() === 'DELETE');
    }

    public function test_attaching_the_same_media_twice_in_one_role_is_idempotent(): void
    {
        $this->fakeMediaApi([self::IMAGE_ID => $this->mediaItem(self::IMAGE_ID)]);

        $first = $this->postJson($this->url(), ['media_id' => self::IMAGE_ID, 'role' => 'gallery'], $this->tenantHeaders())->assertCreated();
        $second = $this->postJson($this->url(), ['media_id' => self::IMAGE_ID, 'role' => 'gallery'], $this->tenantHeaders())->assertOk();

        $this->assertSame($first->json('data.id'), $second->json('data.id'));
        $this->assertDatabaseCount('media_attachments', 1);
    }

    public function test_index_lists_the_records_attachments_in_role_and_sort_order_scoped_to_the_tenant(): void
    {
        $this->fakeMediaApi([
            self::IMAGE_ID => $this->mediaItem(self::IMAGE_ID),
            self::SECOND_IMAGE_ID => $this->mediaItem(self::SECOND_IMAGE_ID),
            self::FILE_ID => $this->mediaItem(self::FILE_ID, 'file'),
        ]);

        $this->postJson($this->url(), ['media_id' => self::SECOND_IMAGE_ID, 'role' => 'gallery'], $this->tenantHeaders())->assertCreated();
        $this->postJson($this->url(), ['media_id' => self::IMAGE_ID, 'role' => 'primary'], $this->tenantHeaders())->assertCreated();
        $this->postJson($this->url(), ['media_id' => self::FILE_ID, 'role' => 'attachment'], $this->tenantHeaders())->assertCreated();

        MediaAttachment::create([
            'tenant_id' => 'other-tenant', 'entity_type' => 'product', 'entity_id' => $this->pid,
            'media_id' => self::FILE_ID, 'role' => 'gallery', 'sort_order' => 1,
        ]);

        $response = $this->getJson($this->url(), $this->tenantHeaders())->assertOk();

        $this->assertSame(['attachment', 'gallery', 'primary'], array_column($response->json('data'), 'role'));
        $this->assertSame(self::BASE.'/media/'.self::IMAGE_ID.'/thumbnail', $response->json('data.2.thumbnail_url'));
        $this->assertArrayNotHasKey('media', $response->json('data.0'));

        $this->getJson($this->url().'?role=primary', $this->tenantHeaders())
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.media_id', self::IMAGE_ID);
    }

    public function test_destroy_detaches_without_deleting_the_media_api_item(): void
    {
        $this->fakeMediaApi([self::IMAGE_ID => $this->mediaItem(self::IMAGE_ID)]);

        $id = $this->postJson($this->url(), ['media_id' => self::IMAGE_ID], $this->tenantHeaders())
            ->assertCreated()
            ->json('data.id');

        [, $foreign] = $this->staff('owner', $this->otherSite('other-tenant'));
        $this->deleteJson("/api/v1/attachments/{$id}", [], $this->tenantHeaders($foreign, 'other-tenant'))->assertStatus(404);

        $this->deleteJson("/api/v1/attachments/{$id}", [], $this->tenantHeaders())
            ->assertOk()
            ->assertJsonPath('data.detached', true)
            ->assertJsonPath('data.media_id', self::IMAGE_ID);

        $this->assertDatabaseCount('media_attachments', 0);
        Http::assertNotSent(fn (Request $r): bool => $r->method() === 'DELETE');

        $this->deleteJson("/api/v1/attachments/{$id}", [], $this->tenantHeaders())->assertStatus(404);
    }

    public function test_health_reports_the_database_connection(): void
    {
        $this->getJson('/api/v1/health')->assertOk()->assertJsonPath('database', true)->assertJsonPath('database_error', null);
    }
}
