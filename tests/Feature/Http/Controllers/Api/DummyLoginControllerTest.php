<?php

namespace Tests\Feature\Http\Controllers\Api;

use Tests\TestCase;

class DummyLoginControllerTest extends TestCase
{
    public function test_valid_dummy_credentials_return_access_token_and_user(): void
    {
        $response = $this->postJson('/api/v1/auth/login', [
            'email' => 'demo@mybizgate.test',
            'password' => 'password',
        ]);

        $response
            ->assertOk()
            ->assertExactJson([
                'message' => 'Login successful.',
                'token_type' => 'Bearer',
                'access_token' => 'dummy-access-token',
                'is_dummy' => true,
                'user' => [
                    'id' => 1,
                    'name' => 'Demo User',
                    'email' => 'demo@mybizgate.test',
                ],
            ]);
    }

    public function test_invalid_dummy_credentials_return_401(): void
    {
        $response = $this->postJson('/api/v1/auth/login', [
            'email' => 'demo@mybizgate.test',
            'password' => 'incorrect-password',
        ]);

        $response
            ->assertUnauthorized()
            ->assertExactJson([
                'message' => 'Invalid credentials.',
            ]);
    }

    public function test_missing_credentials_return_422_with_required_messages(): void
    {
        $response = $this->postJson('/api/v1/auth/login');

        $response
            ->assertUnprocessable()
            ->assertJsonValidationErrors(['email', 'password'])
            ->assertJsonPath('errors.email.0', 'The email field is required.')
            ->assertJsonPath('errors.password.0', 'The password field is required.');
    }

    public function test_malformed_credentials_return_422_with_validation_messages(): void
    {
        $response = $this->postJson('/api/v1/auth/login', [
            'email' => 'not-an-email',
            'password' => ['not-a-string'],
        ]);

        $response
            ->assertUnprocessable()
            ->assertJsonValidationErrors(['email', 'password'])
            ->assertJsonPath('errors.email.0', 'The email field must be a valid email address.')
            ->assertJsonPath('errors.password.0', 'The password field must be a string.');
    }

    public function test_sixth_login_attempt_within_one_minute_returns_429(): void
    {
        $credentials = [
            'email' => 'attacker@example.test',
            'password' => 'incorrect-password',
        ];

        for ($attempt = 1; $attempt <= 5; $attempt++) {
            $this->postJson('/api/v1/auth/login', $credentials)
                ->assertUnauthorized();
        }

        $this->postJson('/api/v1/auth/login', $credentials)
            ->assertTooManyRequests();
    }
}
