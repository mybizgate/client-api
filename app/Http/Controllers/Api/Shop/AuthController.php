<?php

namespace App\Http\Controllers\Api\Shop;

use App\Http\Requests\Shop\LoginRequest;
use App\Http\Resources\Shop\AuthUserResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Laravel\Sanctum\PersonalAccessToken;

/**
 * Owner/staff authentication (API_CONTRACT §2). The site comes from
 * X-Client-Code (an inactive site is already refused by the `site`
 * middleware with its status keys); the user is looked up per site.
 */
class AuthController extends ShopController
{
    public const string TOKEN_NAME = 'shop-manage';

    public function login(LoginRequest $request): JsonResponse
    {
        $site = $this->site($request);

        $user = User::query()
            ->where('site_id', $site->id)
            ->where('email', $request->validated('email'))
            ->first();

        if ($user === null || ! Hash::check($request->validated('password'), $user->password)) {
            return response()->json(['message' => 'E-mel atau kata laluan salah.'], 401);
        }

        abort_unless($user->isActive(), 403, 'Akaun ini telah dinyahaktifkan.');
        abort_unless($user->isStaff(), 403, 'Log masuk pengurusan memerlukan akaun pemilik atau staf.');

        $user->forceFill(['last_login_at' => now()])->save();

        return response()->json([
            'token_type' => 'Bearer',
            'access_token' => $user->createToken(self::TOKEN_NAME)->plainTextToken,
            'user' => (new AuthUserResource($user))->resolve($request),
        ]);
    }

    public function me(Request $request): AuthUserResource
    {
        return new AuthUserResource($this->staff($request));
    }

    public function logout(Request $request): JsonResponse
    {
        $token = $this->staff($request)->currentAccessToken();

        if ($token instanceof PersonalAccessToken) {
            $token->delete();
        }

        return response()->json(null, 204);
    }
}
