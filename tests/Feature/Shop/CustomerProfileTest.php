<?php

namespace Tests\Feature\Shop;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class CustomerProfileTest extends TestCase
{
    use InteractsWithShop;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->setUpShop();
    }

    public function test_profile_read_requires_a_known_guest_token(): void
    {
        $this->getJson('/api/v1/customer/profile', $this->headers())->assertStatus(401);
        $this->getJson('/api/v1/customer/profile', $this->headers(str_repeat('f', 64)))->assertStatus(401);

        [, $token] = $this->guest();
        $this->getJson('/api/v1/customer/profile', $this->headers($token))->assertOk()->assertJsonPath('data.phone', '0191234567');

        // A guest token of another site is unknown here.
        [, $foreign] = $this->guest($this->otherSite());
        $this->getJson('/api/v1/customer/profile', $this->headers($foreign))->assertStatus(401);
    }

    public function test_first_profile_save_creates_a_guest_and_returns_the_token_once(): void
    {
        $response = $this->putJson('/api/v1/customer/profile', [
            'storeName' => 'Kedai Maju', 'contactName' => 'Ali', 'phone' => '019-123 4567', 'address' => '',
        ], $this->headers())->assertOk();

        $token = $response->json('guestToken');
        $this->assertMatchesRegularExpression('/^[0-9a-f]{64}$/', $token);
        $response->assertExactJson(['data' => ['storeName' => 'Kedai Maju', 'contactName' => 'Ali', 'phone' => '019-123 4567', 'address' => ''], 'guestToken' => $token]);

        $this->assertDatabaseHas('shop_customer_profiles', ['site_id' => $this->site->id, 'guest_token_hash' => hash('sha256', $token), 'address' => null]);
        $this->assertStringNotContainsString($token, json_encode($this->getJson('/api/v1/customer/profile', $this->headers($token))->json()));

        $update = $this->putJson('/api/v1/customer/profile', [
            'storeName' => 'Kedai Maju Jaya', 'contactName' => 'Ali', 'phone' => '0191234567', 'address' => 'Jalan 1',
        ], $this->headers($token))->assertOk()->assertJsonPath('data.storeName', 'Kedai Maju Jaya')->assertJsonPath('data.address', 'Jalan 1');

        $this->assertArrayNotHasKey('guestToken', $update->json());
        $this->assertDatabaseCount('shop_customer_profiles', 1);
    }

    public function test_profile_validation_mirrors_the_screen(): void
    {
        $this->putJson('/api/v1/customer/profile', ['storeName' => 'K', 'contactName' => 'A', 'phone' => '123', 'address' => ''], $this->headers())
            ->assertStatus(422)
            ->assertJsonValidationErrors(['storeName', 'contactName', 'phone'])
            ->assertJsonPath('errors.phone.0', 'Sila masukkan nombor telefon yang sah.');

        $this->assertDatabaseCount('shop_customer_profiles', 0);
    }
}
