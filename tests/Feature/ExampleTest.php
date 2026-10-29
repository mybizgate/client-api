<?php

namespace Tests\Feature;

// use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ExampleTest extends TestCase
{
    /**
     * A basic test example.
     */
    public function test_the_application_returns_a_successful_response(): void
    {
        $response = $this->get('/');

        $response->assertStatus(200);
    }

    public function test_health_endpoint_returns_safe_deployment_status(): void
    {
        $response = $this->getJson('/api/v1/health');

        $response
            ->assertOk()
            ->assertJsonPath('status', 'ok')
            ->assertJsonPath('service', 'MyBizGate Client API')
            ->assertJsonPath('environment', 'testing')
            ->assertJsonPath('deployment', null);
    }

    public function test_info_endpoint_returns_service_information(): void
    {
        $response = $this->getJson('/api/v1/info');

        $response
            ->assertOk()
            ->assertJsonPath('name', 'MyBizGate Client API')
            ->assertJsonPath('api_version', 'v1')
            ->assertJsonPath('framework', 'Laravel');
    }

    public function test_health_endpoint_reads_generated_deployment_identity(): void
    {
        $deploymentFile = base_path('bootstrap/deployment.json');
        $previousContents = is_file($deploymentFile)
            ? file_get_contents($deploymentFile)
            : null;

        file_put_contents($deploymentFile, json_encode([
            'commit' => 'abc12345',
            'deployed_at' => '2026-10-29T08:00:00Z',
        ], JSON_THROW_ON_ERROR));

        try {
            $response = $this->getJson('/api/v1/health');

            $response
                ->assertOk()
                ->assertJsonPath('deployment.commit', 'abc12345')
                ->assertJsonPath('deployment.deployed_at', '2026-10-29T08:00:00Z');
        } finally {
            if (is_string($previousContents)) {
                file_put_contents($deploymentFile, $previousContents);
            } else {
                @unlink($deploymentFile);
            }
        }
    }
}
