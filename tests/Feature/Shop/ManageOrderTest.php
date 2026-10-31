<?php

namespace Tests\Feature\Shop;

use App\Models\ShopProduct;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ManageOrderTest extends TestCase
{
    use InteractsWithShop;
    use RefreshDatabase;

    private string $token;

    private int $userId;

    private ShopProduct $product;

    private string $guestToken;

    protected function setUp(): void
    {
        parent::setUp();
        $this->setUpShop();
        [$user, $this->token] = $this->staff('staff');
        $this->userId = $user->id;
        $this->product = $this->product(['selling_price_minor' => 10000, 'stock_quantity' => 10]);
        [, $this->guestToken] = $this->guest();
    }

    private function placeOrder(int $qty = 2): string
    {
        $ref = $this->postJson('/api/v1/orders', $this->draft([['productId' => $this->product->id, 'qty' => $qty]]), $this->headers($this->guestToken))->assertCreated()->json('data.id');
        $this->patchJson("/api/v1/orders/{$ref}/status", ['status' => 'pending_review'], $this->headers($this->guestToken))->assertOk();

        return $ref;
    }

    private function transition(string $ref, string $status, ?string $note = null)
    {
        return $this->patchJson("/api/v1/manage/orders/{$ref}/status", array_filter(['status' => $status, 'note' => $note]), $this->headers($this->token));
    }

    public function test_staff_drive_the_fulfilment_chain_and_stock_is_untouched_while_the_switch_is_off(): void
    {
        $ref = $this->placeOrder();

        $this->getJson('/api/v1/manage/orders', $this->headers($this->token))->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('data.0.id', $ref)->assertJsonPath('data.0.customerProfileId', fn ($v) => is_string($v));
        $this->getJson('/api/v1/manage/orders?status=pending_review', $this->headers($this->token))->assertOk()->assertJsonCount(1, 'data');
        $this->getJson('/api/v1/manage/orders?status=confirmed', $this->headers($this->token))->assertOk()->assertJsonCount(0, 'data');

        $this->transition($ref, 'processing')->assertStatus(422);
        $this->transition($ref, 'confirmed', 'Disahkan melalui WhatsApp')->assertOk()->assertJsonPath('data.status', 'confirmed');
        $this->transition($ref, 'delivered')->assertStatus(422);
        $this->transition($ref, 'processing')->assertOk();
        $this->transition($ref, 'delivered')->assertOk();
        $this->transition($ref, 'completed')->assertOk()->assertJsonPath('data.status', 'completed')->assertJsonCount(6, 'data.history');
        $this->transition($ref, 'cancelled')->assertStatus(422);

        $this->assertDatabaseHas('shop_order_status_history', ['status' => 'confirmed', 'actor_type' => 'staff', 'changed_by_user_id' => $this->userId, 'note' => 'Disahkan melalui WhatsApp']);
        $this->assertSame(10, $this->product->refresh()->stock_quantity);
        $this->assertDatabaseCount('shop_inventory_movements', 0);
    }

    public function test_stock_is_deducted_on_confirm_and_restored_on_cancel_when_the_owner_switch_is_on(): void
    {
        $this->settings->update(['deduct_stock_on_confirm' => true]);
        $ref = $this->placeOrder(4);

        $this->transition($ref, 'confirmed')->assertOk();
        $this->assertSame(6, $this->product->refresh()->stock_quantity);
        $this->assertDatabaseHas('shop_inventory_movements', ['product_id' => $this->product->id, 'movement_type' => 'sale', 'quantity_delta' => -4, 'balance_after' => 6]);

        $this->transition($ref, 'cancelled')->assertOk()->assertJsonPath('data.status', 'cancelled');
        $this->assertSame(10, $this->product->refresh()->stock_quantity);
        $this->assertDatabaseHas('shop_inventory_movements', ['product_id' => $this->product->id, 'movement_type' => 'cancellation', 'quantity_delta' => 4, 'balance_after' => 10]);

        // Cancelling an order that never deducted stock restores nothing.
        $ref2 = $this->placeOrder(2);
        $this->transition($ref2, 'cancelled')->assertOk();
        $this->assertSame(10, $this->product->refresh()->stock_quantity);
        $this->assertDatabaseCount('shop_inventory_movements', 2);
    }

    public function test_confirmation_is_refused_when_stock_no_longer_covers_the_order(): void
    {
        $this->settings->update(['deduct_stock_on_confirm' => true]);
        $ref = $this->placeOrder(8);
        $this->product->update(['stock_quantity' => 3]);

        $this->transition($ref, 'confirmed')->assertStatus(422)->assertJsonValidationErrors(['status']);
        $this->assertDatabaseHas('shop_orders', ['reference_no' => $ref, 'status' => 'pending_review', 'confirmed_at' => null]);
        $this->assertSame(3, $this->product->refresh()->stock_quantity);
    }

    public function test_unlimited_products_never_move_stock(): void
    {
        $this->settings->update(['deduct_stock_on_confirm' => true]);
        $this->product->update(['unlimited_stock' => true, 'stock_quantity' => 0]);
        $ref = $this->placeOrder(50);

        $this->transition($ref, 'confirmed')->assertOk();
        $this->assertDatabaseCount('shop_inventory_movements', 0);
    }

    public function test_orders_of_other_sites_are_not_visible(): void
    {
        $ref = $this->placeOrder();
        [, $foreign] = $this->staff('owner', $this->otherSite());

        $this->getJson("/api/v1/manage/orders/{$ref}", $this->headers($this->token))->assertOk();
        $this->getJson("/api/v1/manage/orders/{$ref}", $this->headers($foreign, 'other'))->assertStatus(404);
        $this->getJson('/api/v1/manage/orders', $this->headers($foreign, 'other'))->assertOk()->assertJsonCount(0, 'data');
    }
}
