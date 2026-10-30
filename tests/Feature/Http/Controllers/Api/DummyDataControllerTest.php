<?php

namespace Tests\Feature\Http\Controllers\Api;

use PHPUnit\Framework\Attributes\DataProvider;
use Tests\TestCase;

class DummyDataControllerTest extends TestCase
{
    /**
     * @return array<string, array{string}>
     */
    public static function collectionEndpointProvider(): array
    {
        return [
            'products' => ['/api/v1/products'],
            'categories' => ['/api/v1/categories'],
            'orders' => ['/api/v1/orders'],
        ];
    }

    #[DataProvider('collectionEndpointProvider')]
    public function test_collection_endpoints_return_empty_data(string $endpoint): void
    {
        $response = $this->getJson($endpoint);

        $response
            ->assertOk()
            ->assertExactJson([
                'data' => [],
            ]);
    }

    public function test_client_config_endpoint_returns_empty_object_data(): void
    {
        $response = $this->getJson('/api/v1/client/config');

        $response
            ->assertOk()
            ->assertHeader('Content-Type', 'application/json')
            ->assertContent('{"data":{}}');
    }
}
