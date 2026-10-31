<?php

namespace Tests\Feature\Shop;

use App\Models\ShopPaymentMethod;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ManageSettingsTest extends TestCase
{
    use InteractsWithShop;
    use RefreshDatabase;

    private string $owner;

    protected function setUp(): void
    {
        parent::setUp();
        $this->setUpShop();
        [, $this->owner] = $this->staff('owner');
    }

    public function test_owner_reads_and_updates_settings_and_the_public_config_follows(): void
    {
        $this->getJson('/api/v1/manage/shop/settings', $this->headers($this->owner))
            ->assertOk()
            ->assertExactJson(['data' => [
                'currency' => 'MYR', 'minimumOrder' => 15000, 'deliveryFee' => 1500, 'freeDeliveryFrom' => 50000,
                'allowWhatsappOrder' => true, 'deductStockOnConfirm' => false, 'referencePrefix' => 'LZ',
            ]]);

        $this->putJson('/api/v1/manage/shop/settings', [
            'currency' => 'myr', 'minimumOrder' => 20000, 'deliveryFee' => 800, 'freeDeliveryFrom' => null,
            'allowWhatsappOrder' => true, 'deductStockOnConfirm' => true, 'referencePrefix' => 'LZS',
        ], $this->headers($this->owner))
            ->assertOk()
            ->assertJsonPath('data.currency', 'MYR')
            ->assertJsonPath('data.freeDeliveryFrom', null)
            ->assertJsonPath('data.deductStockOnConfirm', true);

        $config = $this->getJson('/api/v1/client/config', $this->headers())->assertOk()->json('data.ordering');
        $this->assertSame(20000, $config['minimumOrder']);
        $this->assertSame('LZS', $config['referencePrefix']);
        $this->assertArrayNotHasKey('freeDeliveryFrom', $config);

        $this->putJson('/api/v1/manage/shop/settings', ['currency' => 'MYR', 'referencePrefix' => 'lz'], $this->headers($this->owner))
            ->assertStatus(422)->assertJsonValidationErrors(['minimumOrder', 'deliveryFee', 'allowWhatsappOrder', 'deductStockOnConfirm', 'referencePrefix']);
    }

    public function test_discount_tiers_crud(): void
    {
        $this->getJson('/api/v1/manage/shop/discount-tiers', $this->headers($this->owner))->assertOk()->assertJsonCount(2, 'data')->assertJsonPath('data.0.rate', 0.02);

        $id = $this->postJson('/api/v1/manage/shop/discount-tiers', ['minQty' => 20, 'basisPoints' => 600], $this->headers($this->owner))
            ->assertCreated()->assertJsonPath('data.minQty', 20)->assertJsonPath('data.rate', 0.06)->json('data.id');
        $this->postJson('/api/v1/manage/shop/discount-tiers', ['minQty' => 20, 'basisPoints' => 100], $this->headers($this->owner))->assertStatus(422)->assertJsonValidationErrors(['minQty']);
        $this->postJson('/api/v1/manage/shop/discount-tiers', ['minQty' => 1, 'basisPoints' => 100], $this->headers($this->owner))->assertStatus(422);

        $this->putJson("/api/v1/manage/shop/discount-tiers/{$id}", ['minQty' => 25, 'basisPoints' => 700, 'active' => false], $this->headers($this->owner))->assertOk()->assertJsonPath('data.active', false);
        $this->assertCount(2, $this->getJson('/api/v1/client/config', $this->headers())->json('data.ordering.quantityDiscounts'));

        $this->deleteJson("/api/v1/manage/shop/discount-tiers/{$id}", [], $this->headers($this->owner))->assertNoContent();
        $this->assertDatabaseMissing('shop_discount_tiers', ['id' => $id]);
    }

    public function test_payment_methods_crud_and_active_labels_are_immutable(): void
    {
        $cod = ShopPaymentMethod::query()->where('code', 'cod')->firstOrFail();

        $this->getJson('/api/v1/manage/shop/payment-methods', $this->headers($this->owner))->assertOk()->assertJsonCount(2, 'data');

        $this->putJson("/api/v1/manage/shop/payment-methods/{$cod->id}", ['code' => 'cod', 'label' => 'Tunai'], $this->headers($this->owner))
            ->assertStatus(422)->assertJsonValidationErrors(['label']);
        $this->putJson("/api/v1/manage/shop/payment-methods/{$cod->id}", ['code' => 'cod', 'label' => $cod->label, 'instructions' => 'Sediakan wang tepat', 'sortOrder' => 5], $this->headers($this->owner))
            ->assertOk()->assertJsonPath('data.instructions', 'Sediakan wang tepat');

        $this->postJson('/api/v1/manage/shop/payment-methods', ['code' => 'cod', 'label' => 'Lain'], $this->headers($this->owner))->assertStatus(422)->assertJsonValidationErrors(['code']);
        $this->postJson('/api/v1/manage/shop/payment-methods', ['code' => 'ewallet', 'label' => $cod->label], $this->headers($this->owner))->assertStatus(422)->assertJsonValidationErrors(['label']);
        $id = $this->postJson('/api/v1/manage/shop/payment-methods', ['code' => 'ewallet', 'label' => 'E-dompet'], $this->headers($this->owner))->assertCreated()->json('data.id');

        // sort_order: ewallet 0 (default), bank transfer 2, cod moved to 5 above.
        $this->assertSame(['E-dompet', 'Pindahan bank selepas disahkan', 'Tunai semasa terima barang'], $this->getJson('/api/v1/client/config', $this->headers())->json('data.ordering.paymentOptions'));

        $this->deleteJson("/api/v1/manage/shop/payment-methods/{$id}", [], $this->headers($this->owner))->assertNoContent();
        $this->assertDatabaseHas('shop_payment_methods', ['id' => $id, 'is_active' => 0]);
        // Inactive methods may be renamed.
        $this->putJson("/api/v1/manage/shop/payment-methods/{$id}", ['code' => 'ewallet', 'label' => 'E-dompet lama'], $this->headers($this->owner))->assertOk();
    }
}
