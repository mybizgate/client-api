<?php

namespace Tests\Feature\Marketing;

use App\Models\Client;
use App\Models\Site;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

/**
 * An API request without a valid token must get a JSON 401 even when the
 * client sends no Accept header; it must never try to redirect to a login page.
 */
class UnauthenticatedJsonTest extends TestCase
{
    use RefreshDatabase;

    public function test_missing_token_without_accept_header_is_a_json_401(): void
    {
        $client = Client::factory()->create(['client_code' => 'marketing']);
        Site::factory()->for($client)->create(['status' => 'active']);

        $response = $this->withHeaders(['X-Client-Code' => 'marketing', 'Accept' => ''])
            ->get('/api/v1/marketing/summary');

        $response->assertStatus(401)->assertJson(['message' => 'Unauthenticated.']);
    }

    public function test_invalid_token_without_accept_header_is_a_json_401(): void
    {
        $client = Client::factory()->create(['client_code' => 'marketing']);
        Site::factory()->for($client)->create(['status' => 'active']);

        $response = $this->withHeaders(['X-Client-Code' => 'marketing', 'Accept' => '', 'Authorization' => 'Bearer 1|not-a-real-token'])
            ->get('/api/v1/marketing/prospects');

        $response->assertStatus(401)->assertJson(['message' => 'Unauthenticated.']);
    }
}
