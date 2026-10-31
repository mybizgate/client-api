<?php

namespace App\Http\Controllers\Api\Shop;

use App\Http\Requests\Shop\UpdateCustomerProfileRequest;
use App\Http\Resources\Shop\CustomerProfileResource;
use App\Models\ShopCustomerProfile;
use App\Services\Shop\GuestTokenService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * GET|PUT /customer/profile (API_CONTRACT §4, SHOP_DESIGN §5.6). The first
 * PUT without a token creates a guest profile and returns `guestToken` once.
 */
class CustomerProfileController extends ShopController
{
    public function __construct(private readonly GuestTokenService $tokens) {}

    public function show(Request $request): CustomerProfileResource
    {
        return new CustomerProfileResource($this->customerOrFail($request));
    }

    public function update(UpdateCustomerProfileRequest $request): JsonResponse
    {
        $site = $this->site($request);
        $profile = $this->customer($request);
        $guestToken = null;

        $fields = [
            'store_name' => trim($request->validated('storeName')),
            'contact_name' => trim($request->validated('contactName')),
            'phone' => trim($request->validated('phone')),
            'address' => trim((string) $request->validated('address', '')) === '' ? null : trim((string) $request->validated('address')),
            'last_seen_at' => now(),
        ];

        if ($profile === null) {
            $guestToken = $this->tokens->generate();
            $profile = ShopCustomerProfile::create(['site_id' => $site->id, 'guest_token_hash' => $this->tokens->hash($guestToken)] + $fields);
        } else {
            $profile->fill($fields)->save();
        }

        $body = ['data' => (new CustomerProfileResource($profile))->resolve($request)];

        if ($guestToken !== null) {
            $body['guestToken'] = $guestToken;
        }

        return response()->json($body);
    }
}
