<?php

namespace Tests\Feature\Shop;

use App\Models\ShopCategory;
use App\Models\ShopProduct;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ManageProductTest extends TestCase
{
    use InteractsWithShop;
    use RefreshDatabase;

    private string $token;

    private int $userId;

    protected function setUp(): void
    {
        parent::setUp();
        $this->setUpShop();
        [$user, $this->token] = $this->staff('staff');
        $this->userId = $user->id;
    }

    /**
     * @return array<string, mixed>
     */
    private function input(array $overrides = []): array
    {
        return array_replace([
            'categoryId' => (string) $this->category->id,
            'name' => 'Serbuk Kari Daging',
            'unit' => 'karton',
            'packQty' => 12,
            'size' => '1kg',
            'price' => 14520,
            'oldPrice' => 15900,
            'minimumQuantity' => 1,
            'stockQuantity' => 32,
            'unlimitedStock' => false,
            'status' => 'active',
        ], $overrides);
    }

    public function test_create_product_from_the_edit_card(): void
    {
        $response = $this->postJson('/api/v1/manage/products', $this->input(), $this->headers($this->token))->assertCreated();

        $data = $response->json('data');
        $this->assertSame('serbuk-kari-daging-1kg', $data['slug']);
        $this->assertSame(15900, $data['oldPrice']);
        $this->assertTrue($data['promo']);
        $this->assertSame(32, $data['stock']);
        $this->assertSame(32, $data['stockQuantity']);
        $this->assertSame('active', $data['status']);
        $this->assertFalse($data['unlimitedStock']);
        $this->assertSame([], $data['images']);

        $this->assertDatabaseHas('shop_products', ['slug' => 'serbuk-kari-daging-1kg', 'site_id' => $this->site->id, 'created_by_user_id' => $this->userId, 'stock_quantity' => 32]);
        $this->assertDatabaseHas('shop_inventory_movements', ['movement_type' => 'opening', 'quantity_delta' => 32, 'balance_after' => 32, 'created_by_user_id' => $this->userId]);
        $this->assertNotNull(ShopProduct::query()->first()->published_at);

        // Same name + size → suffixed slug; the public catalogue sees both.
        $this->postJson('/api/v1/manage/products', $this->input(), $this->headers($this->token))->assertCreated()->assertJsonPath('data.slug', 'serbuk-kari-daging-1kg-2');
        $this->getJson('/api/v1/products', $this->headers())->assertOk()->assertJsonCount(2, 'data');
    }

    public function test_create_validates_input_and_the_category_must_belong_to_the_site(): void
    {
        $this->postJson('/api/v1/manage/products', [], $this->headers($this->token))
            ->assertStatus(422)
            ->assertJsonValidationErrors(['categoryId', 'name', 'unit', 'packQty', 'size', 'price', 'minimumQuantity', 'stockQuantity', 'unlimitedStock', 'status']);

        $foreignCategory = ShopCategory::factory()->create(['site_id' => $this->otherSite()->id]);
        $this->postJson('/api/v1/manage/products', $this->input(['categoryId' => (string) $foreignCategory->id]), $this->headers($this->token))
            ->assertStatus(422)
            ->assertJsonValidationErrors(['categoryId']);

        $this->assertDatabaseCount('shop_products', 0);
    }

    public function test_update_clears_a_promotion_price_that_is_not_above_the_price_and_records_stock_edits(): void
    {
        $id = $this->postJson('/api/v1/manage/products', $this->input(), $this->headers($this->token))->json('data.id');

        $this->putJson("/api/v1/manage/products/{$id}", $this->input(['oldPrice' => 14000, 'stockQuantity' => 20, 'name' => 'Serbuk Kari Daging Premium']), $this->headers($this->token))
            ->assertOk()
            ->assertJsonPath('data.promo', false)
            ->assertJsonPath('data.stock', 20)
            ->assertJsonPath('data.name', 'Serbuk Kari Daging Premium')
            ->assertJsonPath('data.slug', 'serbuk-kari-daging-1kg')
            ->assertJsonMissingPath('data.oldPrice');

        $this->assertDatabaseHas('shop_products', ['id' => $id, 'compare_at_price_minor' => null, 'stock_quantity' => 20, 'updated_by_user_id' => $this->userId]);
        $this->assertDatabaseHas('shop_inventory_movements', ['product_id' => $id, 'movement_type' => 'adjustment', 'quantity_delta' => -12, 'balance_after' => 20]);

        // Unchanged stock writes no movement; unlimited products never do.
        $this->putJson("/api/v1/manage/products/{$id}", $this->input(['stockQuantity' => 20]), $this->headers($this->token))->assertOk();
        $this->putJson("/api/v1/manage/products/{$id}", $this->input(['stockQuantity' => 999, 'unlimitedStock' => true]), $this->headers($this->token))
            ->assertOk()->assertJsonPath('data.stock', null)->assertJsonPath('data.stockStatus', 'in_stock');
        $this->assertDatabaseCount('shop_inventory_movements', 2);
    }

    public function test_inventory_endpoint_records_manual_movements(): void
    {
        $product = $this->product(['stock_quantity' => 5]);
        $url = "/api/v1/manage/products/{$product->id}/inventory";

        $this->postJson($url, ['movementType' => 'restock', 'quantityDelta' => 10, 'note' => 'Lori masuk'], $this->headers($this->token))
            ->assertOk()->assertJsonPath('data.stockQuantity', 15);
        $this->postJson($url, ['movementType' => 'adjustment', 'quantityDelta' => -20], $this->headers($this->token))
            ->assertStatus(422)->assertJsonValidationErrors(['quantityDelta']);
        $this->postJson($url, ['movementType' => 'sale', 'quantityDelta' => -1], $this->headers($this->token))
            ->assertStatus(422)->assertJsonValidationErrors(['movementType']);
        $this->postJson($url, ['movementType' => 'restock', 'quantityDelta' => 0], $this->headers($this->token))
            ->assertStatus(422);

        $this->assertDatabaseHas('shop_inventory_movements', ['product_id' => $product->id, 'movement_type' => 'restock', 'quantity_delta' => 10, 'balance_after' => 15, 'note' => 'Lori masuk']);

        $unlimited = $this->product(['unlimited_stock' => true]);
        $this->postJson("/api/v1/manage/products/{$unlimited->id}/inventory", ['movementType' => 'restock', 'quantityDelta' => 1], $this->headers($this->token))->assertStatus(422);
    }

    public function test_listing_shows_every_status_and_delete_archives(): void
    {
        $active = $this->product(['slug' => 'active', 'sort_order' => 1]);
        $draft = $this->product(['slug' => 'draft', 'status' => 'draft', 'sort_order' => 2]);
        ShopProduct::factory()->forCategory(ShopCategory::factory()->create(['site_id' => $this->otherSite()->id]))->create(['slug' => 'foreign']);

        $this->getJson('/api/v1/manage/products', $this->headers($this->token))
            ->assertOk()->assertJsonCount(2, 'data')->assertJsonPath('data.0.slug', 'active')->assertJsonPath('data.1.status', 'draft');
        $this->getJson('/api/v1/manage/products?status=draft', $this->headers($this->token))->assertOk()->assertJsonCount(1, 'data');
        $this->getJson("/api/v1/manage/products/{$draft->id}", $this->headers($this->token))->assertOk()->assertJsonPath('data.active', false);

        $this->deleteJson("/api/v1/manage/products/{$active->id}", [], $this->headers($this->token))->assertNoContent();
        $this->assertSoftDeleted('shop_products', ['id' => $active->id]);
        $this->assertDatabaseHas('shop_products', ['id' => $active->id, 'status' => 'archived']);
        $this->getJson("/api/v1/manage/products/{$active->id}", $this->headers($this->token))->assertStatus(404);
        $this->getJson('/api/v1/products', $this->headers())->assertOk()->assertJsonCount(0, 'data');
    }
}
