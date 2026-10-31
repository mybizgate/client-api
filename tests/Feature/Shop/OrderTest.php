<?php

namespace Tests\Feature\Shop;

use App\Models\ShopOrder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Carbon;
use Tests\TestCase;

class OrderTest extends TestCase
{
    use InteractsWithShop;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->setUpShop();
        Carbon::setTestNow('2026-10-31 10:00:00');
    }

    public function test_creating_an_order_prices_it_like_the_prototype_and_issues_a_guest_token(): void
    {
        $kari = $this->product(['name' => 'Serbuk Kari Daging', 'slug' => 'kari', 'selling_price_minor' => 14520, 'stock_quantity' => 32]);
        $beras = $this->product(['name' => 'Beras Wangi', 'slug' => 'beras', 'selling_price_minor' => 5590, 'selling_unit' => 'guni', 'pack_quantity' => 1, 'pack_size' => '10kg', 'minimum_order_quantity' => 2, 'stock_quantity' => 60]);

        $response = $this->postJson('/api/v1/orders', $this->draft([
            ['productId' => (string) $kari->id, 'qty' => 5],
            ['productId' => (string) $beras->id, 'qty' => 2],
        ], ['notes' => 'Hantar pagi']), $this->headers())->assertCreated();

        $token = $response->json('guestToken');
        $this->assertMatchesRegularExpression('/^[0-9a-f]{64}$/', $token);

        $order = $response->json('data');
        $this->assertSame('LZ-20261031-0001', $order['id']);
        $this->assertSame('draft_whatsapp', $order['status']);
        $this->assertSame(['storeName' => 'Kedai Maju Jaya', 'contactName' => 'Ali', 'phone' => '019 123 4567', 'address' => 'No 1, Jalan Melati 13, 53100 Kuala Lumpur'], $order['customer']);
        $this->assertSame('delivery', $order['fulfilment']);
        $this->assertSame('2026-11-02', $order['requestedDate']);
        $this->assertSame('Tunai semasa terima barang', $order['paymentMethod']);
        $this->assertSame('Hantar pagi', $order['notes']);
        // 5 x 14520 at 2 % = 5 x 14230; 2 x 5590 (below tier) = 11180
        $this->assertSame(14230, $order['items'][0]['unitPrice']);
        $this->assertSame(14520, $order['items'][0]['basePrice']);
        $this->assertSame(5590, $order['items'][1]['unitPrice']);
        $this->assertSame(71150 + 11180, $order['subtotal']);
        $this->assertSame(0, $order['deliveryFee']); // >= 50000 free delivery
        $this->assertSame(82330, $order['total']);
        $this->assertSame([['status' => 'draft_whatsapp', 'at' => '2026-10-31T10:00:00+00:00']], $order['history']);
        $this->assertSame(['shape' => 'pouch', 'color' => '#de9731', 'motif' => 'spice', 'label' => 'PRODUK'], $order['items'][0]['art']);
        $this->assertArrayNotHasKey('image', $order['items'][0]);

        $this->assertDatabaseHas('shop_orders', ['reference_no' => 'LZ-20261031-0001', 'subtotal_minor' => 82330, 'discount_minor' => 1450, 'total_minor' => 82330, 'payment_method_code' => 'cod']);
        $this->assertDatabaseHas('shop_order_items', ['line_number' => 1, 'product_id' => $kari->id, 'quantity' => 5, 'unit_price_minor' => 14230, 'line_total_minor' => 71150]);
        $this->assertDatabaseHas('shop_order_status_history', ['status' => 'draft_whatsapp', 'actor_type' => 'customer']);
        $this->assertSame(2, $this->settings->refresh()->next_order_number);
        // Stock is untouched at draft time (and the owner switch is off anyway).
        $this->assertSame(32, $kari->refresh()->stock_quantity);

        // The token now scopes the order history.
        $this->getJson('/api/v1/orders', $this->headers($token))->assertOk()->assertJsonCount(1, 'data')->assertJsonPath('data.0.id', 'LZ-20261031-0001');
        $this->getJson('/api/v1/orders/LZ-20261031-0001', $this->headers($token))->assertOk();
        $this->getJson('/api/v1/orders', $this->headers())->assertStatus(401);
        [, $stranger] = $this->guest();
        $this->getJson('/api/v1/orders/LZ-20261031-0001', $this->headers($stranger))->assertStatus(404);
        $this->getJson('/api/v1/orders', $this->headers($stranger))->assertOk()->assertJsonCount(0, 'data');
    }

    public function test_delivery_fee_minimum_order_and_pickup_rules(): void
    {
        $p = $this->product(['selling_price_minor' => 10000, 'stock_quantity' => 100]);
        [, $token] = $this->guest();

        $this->postJson('/api/v1/orders', $this->draft([['productId' => $p->id, 'qty' => 1]]), $this->headers($token))
            ->assertStatus(422)->assertJsonPath('message', 'Jumlah pesanan belum mencapai minimum.');

        $this->postJson('/api/v1/orders', $this->draft([['productId' => $p->id, 'qty' => 2]]), $this->headers($token))
            ->assertCreated()->assertJsonPath('data.subtotal', 20000)->assertJsonPath('data.deliveryFee', 1500)->assertJsonPath('data.total', 21500);

        $this->postJson('/api/v1/orders', $this->draft([['productId' => $p->id, 'qty' => 2]], ['fulfilment' => 'pickup', 'customer' => ['address' => '']]), $this->headers($token))
            ->assertCreated()->assertJsonPath('data.deliveryFee', 0)->assertJsonPath('data.customer.address', '');

        $this->postJson('/api/v1/orders', $this->draft([['productId' => $p->id, 'qty' => 5]]), $this->headers($token))
            ->assertCreated()->assertJsonPath('data.items.0.unitPrice', 9800)->assertJsonPath('data.deliveryFee', 1500);

        $this->postJson('/api/v1/orders', $this->draft([['productId' => $p->id, 'qty' => 10]]), $this->headers($token))
            ->assertCreated()->assertJsonPath('data.items.0.unitPrice', 9600)->assertJsonPath('data.subtotal', 96000)->assertJsonPath('data.deliveryFee', 0);

        $this->assertSame(['LZ-20261031-0004', 'LZ-20261031-0003', 'LZ-20261031-0002', 'LZ-20261031-0001'], array_column($this->getJson('/api/v1/orders', $this->headers($token))->json('data'), 'id'));
    }

    public function test_order_validation_mirrors_the_frontend(): void
    {
        $p = $this->product(['name' => 'Kari', 'selling_price_minor' => 10000, 'stock_quantity' => 3, 'minimum_order_quantity' => 2]);
        $draftProduct = $this->product(['slug' => 'draft', 'status' => 'draft']);
        [, $token] = $this->guest();
        $post = fn (array $body) => $this->postJson('/api/v1/orders', $body, $this->headers($token));

        $post($this->draft([['productId' => $p->id, 'qty' => 2]], ['customer' => ['storeName' => 'K']]))->assertStatus(422)->assertJsonPath('message', 'Sila isi nama kedai dan penerima yang sah.');
        $post($this->draft([['productId' => $p->id, 'qty' => 2]], ['customer' => ['phone' => '12345678']]))->assertStatus(422)->assertJsonPath('message', 'Sila masukkan nombor telefon yang sah.');
        $post($this->draft([['productId' => $p->id, 'qty' => 2]], ['customer' => ['address' => 'Jalan 1']]))->assertStatus(422)->assertJsonPath('message', 'Sila isi alamat lengkap untuk penghantaran.');
        $post($this->draft([['productId' => $p->id, 'qty' => 2]], ['requestedDate' => '2026-10-31']))->assertStatus(422)->assertJsonPath('message', 'Pilih tarikh esok atau selepasnya.');
        $post($this->draft([['productId' => $p->id, 'qty' => 2]], ['requestedDate' => '2026-11-01']))->assertCreated();
        $post($this->draft([]))->assertStatus(422)->assertJsonPath('message', 'Troli kosong.');
        $post($this->draft([['productId' => $p->id, 'qty' => 2]], ['paymentMethod' => 'Kad kredit']))->assertStatus(422)->assertJsonPath('message', 'Kaedah pembayaran tidak sah.');
        $post($this->draft([['productId' => $p->id, 'qty' => 2]], ['notes' => str_repeat('x', 501)]))->assertStatus(422)->assertJsonValidationErrors(['notes']);
        $post($this->draft([['productId' => $p->id, 'qty' => 1]]))->assertStatus(422)->assertJsonPath('message', 'Kari: minimum 2 karton.');
        $post($this->draft([['productId' => $p->id, 'qty' => 4]]))->assertStatus(422)->assertJsonPath('message', 'Kari: stok tersedia 3 karton.');
        $post($this->draft([['productId' => $draftProduct->id, 'qty' => 2]]))->assertStatus(422)->assertJsonPath('message', "Produk {$draftProduct->id} tidak tersedia.");
        $post($this->draft([['productId' => 999999, 'qty' => 2]]))->assertStatus(422);

        $this->assertDatabaseCount('shop_orders', 1);
    }

    public function test_unlimited_products_accept_any_quantity(): void
    {
        $p = $this->product(['selling_price_minor' => 10000, 'stock_quantity' => 0, 'unlimited_stock' => true]);
        [, $token] = $this->guest();

        $this->postJson('/api/v1/orders', $this->draft([['productId' => $p->id, 'qty' => 500]]), $this->headers($token))
            ->assertCreated()->assertJsonPath('data.items.0.qty', 500);
    }

    public function test_customer_status_transitions(): void
    {
        $p = $this->product(['selling_price_minor' => 10000, 'stock_quantity' => 50]);
        [, $token] = $this->guest();
        $ref = $this->postJson('/api/v1/orders', $this->draft([['productId' => $p->id, 'qty' => 2]]), $this->headers($token))->json('data.id');
        $patch = fn (string $status) => $this->patchJson("/api/v1/orders/{$ref}/status", ['status' => $status], $this->headers($token));

        $patch('confirmed')->assertStatus(422);
        $patch('cancelled')->assertOk()->assertJsonPath('data.status', 'cancelled');
        $patch('pending_review')->assertStatus(422);

        $ref2 = $this->postJson('/api/v1/orders', $this->draft([['productId' => $p->id, 'qty' => 2]]), $this->headers($token))->json('data.id');
        $this->patchJson("/api/v1/orders/{$ref2}/status", ['status' => 'pending_review'], $this->headers($token))
            ->assertOk()->assertJsonPath('data.status', 'pending_review')->assertJsonCount(2, 'data.history');

        $this->assertNotNull(ShopOrder::query()->where('reference_no', $ref2)->first()->whatsapp_sent_at);
        $this->assertDatabaseHas('shop_order_status_history', ['status' => 'cancelled', 'actor_type' => 'customer', 'changed_by_user_id' => null]);

        [, $stranger] = $this->guest();
        $this->patchJson("/api/v1/orders/{$ref2}/status", ['status' => 'cancelled'], $this->headers($stranger))->assertStatus(404);
    }

    public function test_a_staff_token_is_not_a_customer_token(): void
    {
        [, $staffToken] = $this->staff();

        $this->getJson('/api/v1/orders', $this->headers($staffToken))->assertStatus(401);
        $this->getJson('/api/v1/customer/profile', $this->headers($staffToken))->assertStatus(401);
    }
}
