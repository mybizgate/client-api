<?php

namespace Tests\Feature\Shop;

use App\Models\Site;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class AuthTest extends TestCase
{
    use InteractsWithShop;
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->setUpShop();
    }

    public function test_owner_can_log_in_read_me_and_log_out(): void
    {
        $owner = User::factory()->for($this->site)->owner()->create(['email' => 'owner@lzhub.test', 'password' => 'secret-pass', 'name' => 'Pemilik']);

        $response = $this->postJson('/api/v1/auth/login', ['email' => 'owner@lzhub.test', 'password' => 'secret-pass'], $this->headers())
            ->assertOk()
            ->assertJsonPath('token_type', 'Bearer')
            ->assertJsonPath('user', ['id' => (string) $owner->id, 'name' => 'Pemilik', 'email' => 'owner@lzhub.test', 'role' => 'owner']);

        $this->assertArrayNotHasKey('is_dummy', $response->json());
        $token = $response->json('access_token');
        $this->assertNotNull($owner->refresh()->last_login_at);

        $this->getJson('/api/v1/auth/me', $this->headers($token))->assertOk()->assertJsonPath('data.role', 'owner');
        $this->postJson('/api/v1/auth/logout', [], $this->headers($token))->assertNoContent();
        $this->getJson('/api/v1/auth/me', $this->headers($token))->assertStatus(401);
        $this->getJson('/api/v1/auth/me', $this->headers())->assertStatus(401);
    }

    public function test_login_refuses_bad_credentials_customers_disabled_users_and_other_sites(): void
    {
        User::factory()->for($this->site)->owner()->create(['email' => 'owner@lzhub.test', 'password' => 'secret-pass']);
        User::factory()->for($this->site)->create(['email' => 'customer@lzhub.test', 'password' => 'secret-pass']);
        User::factory()->for($this->site)->staff()->disabled()->create(['email' => 'gone@lzhub.test', 'password' => 'secret-pass']);
        $other = $this->otherSite();
        User::factory()->for($other)->owner()->create(['email' => 'owner@other.test', 'password' => 'secret-pass']);

        $login = fn (string $email, string $code = 'lzhub') => $this->postJson('/api/v1/auth/login', ['email' => $email, 'password' => 'secret-pass'], $this->headers(code: $code));

        // Five attempts: the throttle (5 per minute) allows exactly these.
        $this->postJson('/api/v1/auth/login', ['email' => 'owner@lzhub.test', 'password' => 'wrong'], $this->headers())->assertStatus(401)->assertJsonPath('message', 'E-mel atau kata laluan salah.');
        $this->postJson('/api/v1/auth/login', [], $this->headers())->assertStatus(422)->assertJsonValidationErrors(['email', 'password']);
        $login('customer@lzhub.test')->assertStatus(403);
        $login('gone@lzhub.test')->assertStatus(403);
        $login('owner@other.test')->assertStatus(401);
    }

    public function test_users_log_in_under_their_own_client_code_only(): void
    {
        $other = $this->otherSite();
        User::factory()->for($other)->owner()->create(['email' => 'owner@other.test', 'password' => 'secret-pass']);

        $this->postJson('/api/v1/auth/login', ['email' => 'owner@other.test', 'password' => 'secret-pass'], $this->headers(code: 'other'))->assertOk();
        $this->postJson('/api/v1/auth/login', ['email' => 'owner@other.test', 'password' => 'secret-pass'], $this->headers())->assertStatus(401);
    }

    public function test_login_is_refused_with_status_keys_when_the_site_is_not_active(): void
    {
        $expired = Site::factory()->expired()->create();
        User::factory()->for($expired)->owner()->create(['email' => 'owner@expired.test', 'password' => 'secret-pass']);

        $this->postJson('/api/v1/auth/login', ['email' => 'owner@expired.test', 'password' => 'secret-pass'], $this->headers(code: $expired->client->client_code))
            ->assertStatus(403)
            ->assertJsonPath('status', 'expired')
            ->assertJsonPath('status_reason', 'Langganan tamat.')
            ->assertJsonPath('remarks', 'Hubungi MyBizGate untuk pembaharuan.');
    }

    public function test_login_is_throttled_after_five_attempts(): void
    {
        for ($i = 0; $i < 5; $i++) {
            $this->postJson('/api/v1/auth/login', ['email' => 'nobody@lzhub.test', 'password' => 'x'], $this->headers())->assertStatus(401);
        }

        $this->postJson('/api/v1/auth/login', ['email' => 'nobody@lzhub.test', 'password' => 'x'], $this->headers())->assertStatus(429);
    }

    public function test_management_routes_reject_tokens_from_other_sites_customers_and_disabled_users(): void
    {
        [, $foreign] = $this->staff('owner', $this->otherSite());
        $customer = User::factory()->for($this->site)->create();
        $disabled = User::factory()->for($this->site)->staff()->disabled()->create();

        $this->getJson('/api/v1/manage/products', $this->headers())->assertStatus(401);
        $this->getJson('/api/v1/manage/products', $this->headers($foreign))->assertStatus(403);
        $this->getJson('/api/v1/manage/products', $this->headers($customer->createToken('t')->plainTextToken))->assertStatus(403);
        $this->getJson('/api/v1/manage/products', $this->headers($disabled->createToken('t')->plainTextToken))->assertStatus(403);

        [, $staffToken] = $this->staff('staff');
        $this->getJson('/api/v1/manage/products', $this->headers($staffToken))->assertOk();
        $this->getJson('/api/v1/manage/shop/settings', $this->headers($staffToken))->assertStatus(403);

        [, $ownerToken] = $this->staff('owner');
        $this->getJson('/api/v1/manage/shop/settings', $this->headers($ownerToken))->assertOk();
    }
}
