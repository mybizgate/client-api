<?php

namespace Tests\Feature\Shop;

use App\Models\MediaAttachment;
use App\Models\ShopCategory;
use App\Models\ShopProduct;
use App\Models\Site;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CatalogueTest extends TestCase
{
    use InteractsWithShop;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->setUpShop();
        config(['services.media_api.base_url' => 'https://media-api.test/api/v1']);
    }

    public function test_site_resolution_requires_a_known_active_client(): void
    {
        $this->getJson('/api/v1/products')->assertStatus(400);
        $this->getJson('/api/v1/products', $this->headers(code: 'nobody'))->assertStatus(404);

        $expired = Site::factory()->expired()->create();
        $this->getJson('/api/v1/products', $this->headers(code: $expired->client->client_code))
            ->assertStatus(403)
            ->assertJsonPath('status', 'expired')
            ->assertJsonPath('status_reason', 'Langganan tamat.')
            ->assertJsonPath('remarks', 'Hubungi MyBizGate untuk pembaharuan.');
    }

    public function test_client_config_returns_the_ordering_block(): void
    {
        $this->getJson('/api/v1/client/config', $this->headers())
            ->assertOk()
            ->assertExactJson(['data' => ['ordering' => [
                'currency' => 'MYR',
                'minimumOrder' => 15000,
                'deliveryFee' => 1500,
                'allowWhatsappOrder' => true,
                'referencePrefix' => 'LZ',
                'quantityDiscounts' => [['minQty' => 5, 'rate' => 0.02], ['minQty' => 10, 'rate' => 0.04]],
                'paymentOptions' => ['Tunai semasa terima barang', 'Pindahan bank selepas disahkan'],
                'freeDeliveryFrom' => 50000,
            ]]]);
    }

    public function test_categories_lists_active_ones_of_the_site_only(): void
    {
        ShopCategory::factory()->create(['site_id' => $this->site->id, 'name' => 'Sos', 'slug' => 'sos', 'sort_order' => 2]);
        ShopCategory::factory()->draft()->create(['site_id' => $this->site->id, 'slug' => 'draft']);
        ShopCategory::factory()->create(['site_id' => $this->otherSite()->id, 'slug' => 'elsewhere']);

        $this->getJson('/api/v1/categories', $this->headers())
            ->assertOk()
            ->assertJsonCount(2, 'data')
            ->assertJsonPath('data.0.id', (string) $this->category->id)
            ->assertJsonPath('data.0.slug', 'rempah-perencah')
            ->assertJsonPath('data.0.active', true)
            ->assertJsonPath('data.0.sortOrder', 1)
            ->assertJsonPath('data.1.slug', 'sos');
    }

    public function test_products_returns_the_frontend_shape_with_derived_fields(): void
    {
        $product = $this->product(['name' => 'Serbuk Kari Daging', 'slug' => 'serbuk-kari-daging-1kg', 'sku' => 'LZ-0001', 'compare_at_price_minor' => 15900, 'stock_quantity' => 32, 'is_featured' => true, 'brand' => 'Lz']);
        MediaAttachment::create(['tenant_id' => 'lzhub', 'entity_type' => 'product', 'entity_id' => (string) $product->id, 'media_id' => '01m639sgg2275fr73b2gb9s91r', 'role' => 'gallery', 'sort_order' => 1]);
        MediaAttachment::create(['tenant_id' => 'lzhub', 'entity_type' => 'product', 'entity_id' => (string) $product->id, 'media_id' => '01m639sgg2275fr73b2gb9s91s', 'role' => 'primary', 'slot' => 'primary', 'sort_order' => 1]);

        $response = $this->getJson('/api/v1/products', $this->headers())->assertOk()->assertJsonCount(1, 'data');

        $this->assertSame([
            'id' => (string) $product->id,
            'sku' => 'LZ-0001',
            'name' => 'Serbuk Kari Daging',
            'slug' => 'serbuk-kari-daging-1kg',
            'categoryId' => (string) $this->category->id,
            'images' => ['https://media-api.test/api/v1/media/01m639sgg2275fr73b2gb9s91s', 'https://media-api.test/api/v1/media/01m639sgg2275fr73b2gb9s91r'],
            'unit' => 'karton',
            'packQty' => 12,
            'size' => '1kg',
            'price' => 14520,
            'oldPrice' => 15900,
            'minimumQuantity' => 1,
            'stock' => 32,
            'stockStatus' => 'in_stock',
            'featured' => true,
            'promo' => true,
            'brand' => 'Lz',
            'active' => true,
            'art' => ['shape' => 'pouch', 'color' => '#de9731', 'motif' => 'spice', 'label' => 'PRODUK'],
            'updatedAt' => $product->updated_at->toIso8601String(),
        ], $response->json('data.0'));
    }

    public function test_stock_status_and_unlimited_stock_follow_the_design_rules(): void
    {
        $this->product(['slug' => 'low', 'stock_quantity' => 9, 'minimum_order_quantity' => 2, 'sort_order' => 1]);
        $this->product(['slug' => 'out', 'stock_quantity' => 1, 'minimum_order_quantity' => 2, 'sort_order' => 2]);
        $this->product(['slug' => 'free', 'stock_quantity' => 0, 'unlimited_stock' => true, 'sort_order' => 3]);

        $data = collect($this->getJson('/api/v1/products', $this->headers())->assertOk()->json('data'))->keyBy('slug');

        $this->assertSame('low', $data['low']['stockStatus']);
        $this->assertSame('out', $data['out']['stockStatus']);
        $this->assertSame('in_stock', $data['free']['stockStatus']);
        $this->assertNull($data['free']['stock']);
        $this->assertSame(9, $data['low']['stock']);
        $this->assertArrayNotHasKey('oldPrice', $data['low']);
        $this->assertFalse($data['low']['promo']);

        $this->getJson('/api/v1/products?in_stock=1', $this->headers())->assertOk()->assertJsonCount(2, 'data');
    }

    public function test_products_hides_drafts_deleted_rows_inactive_categories_and_other_sites(): void
    {
        $this->product(['slug' => 'visible']);
        $this->product(['slug' => 'draft', 'status' => 'draft']);
        $this->product(['slug' => 'gone'])->delete();
        $hidden = ShopCategory::factory()->draft()->create(['site_id' => $this->site->id, 'slug' => 'hidden']);
        ShopProduct::factory()->forCategory($hidden)->create(['slug' => 'in-hidden-category']);
        $other = ShopCategory::factory()->create(['site_id' => $this->otherSite()->id]);
        ShopProduct::factory()->forCategory($other)->create(['slug' => 'visible']);

        $this->getJson('/api/v1/products', $this->headers())
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.slug', 'visible');

        $this->getJson('/api/v1/products/draft', $this->headers())->assertStatus(404);
        $this->getJson('/api/v1/products/visible', $this->headers())->assertOk()->assertJsonPath('data.slug', 'visible');
    }

    public function test_products_filters_and_sorts(): void
    {
        $sos = ShopCategory::factory()->create(['site_id' => $this->site->id, 'slug' => 'sos']);
        $a = $this->product(['name' => 'Serbuk Kari', 'slug' => 'a', 'selling_price_minor' => 300, 'sort_order' => 2, 'sku' => 'LZ-0001']);
        $b = $this->product(['name' => 'Serbuk Cili', 'slug' => 'b', 'selling_price_minor' => 100, 'sort_order' => 1, 'compare_at_price_minor' => 200]);
        $c = ShopProduct::factory()->forCategory($sos)->create(['name' => 'Kicap', 'slug' => 'c', 'selling_price_minor' => 200, 'sort_order' => 3, 'pack_size' => '650ml']);

        $slugs = fn (string $query) => array_column($this->getJson("/api/v1/products{$query}", $this->headers())->assertOk()->json('data'), 'slug');

        $this->assertSame(['b', 'a', 'c'], $slugs(''));
        $this->assertSame(['b', 'c', 'a'], $slugs('?sort=price_asc'));
        $this->assertSame(['a', 'c', 'b'], $slugs('?sort=price_desc'));
        $this->assertSame(['c', 'b', 'a'], $slugs('?sort=name'));
        $this->assertSame(['c'], $slugs("?category={$sos->id}"));
        $this->assertSame(['b', 'a'], $slugs('?search=serbuk'));
        $this->assertSame(['a'], $slugs('?search=lz-0001'));
        $this->assertSame(['c'], $slugs('?search=650ML'));
        $this->assertSame(['b'], $slugs('?promo=1'));
        $this->assertSame(['a', 'c'], $slugs("?ids={$a->id},{$c->id}"));
        $this->assertSame([], $slugs('?ids=abc'));
    }
}
