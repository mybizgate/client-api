<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DummyLoginController extends Controller
{
    private const string DEMO_EMAIL = 'demo@mybizgate.test';

    private const string DEMO_PASSWORD = 'password';

    public function __invoke(Request $request): JsonResponse
    {
        $credentials = $request->validate([
            'email' => ['required', 'string', 'email'],
            'password' => ['required', 'string'],
        ]);

        $hasValidCredentials = hash_equals(self::DEMO_EMAIL, $credentials['email'])
            && hash_equals(self::DEMO_PASSWORD, $credentials['password']);

        if (! $hasValidCredentials) {
            return response()->json([
                'message' => 'Invalid credentials.',
            ], 401);
        }

        return response()->json([
            'message' => 'Login successful.',
            'token_type' => 'Bearer',
            'access_token' => 'dummy-access-token',
            'is_dummy' => true,
            'user' => [
                'id' => 1,
                'name' => 'Demo User',
                'email' => self::DEMO_EMAIL,
            ],
        ]);
    }
}
