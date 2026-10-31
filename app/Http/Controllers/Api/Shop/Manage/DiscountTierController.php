<?php

namespace App\Http\Controllers\Api\Shop\Manage;

use App\Http\Controllers\Api\Shop\ShopController;
use App\Http\Requests\Shop\Manage\DiscountTierRequest;
use App\Http\Resources\Shop\DiscountTierResource;
use App\Models\ShopDiscountTier;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Validation\ValidationException;

/** /manage/shop/discount-tiers (owner only). Site-wide tiers, decision §13.7. */
class DiscountTierController extends ShopController
{
    public function index(Request $request): AnonymousResourceCollection
    {
        return DiscountTierResource::collection(
            ShopDiscountTier::query()->forSite($this->site($request))->orderBy('minimum_quantity')->get()
        );
    }

    public function store(DiscountTierRequest $request): JsonResponse
    {
        $site = $this->site($request);
        $input = $request->validated();

        $this->assertUniqueQuantity($site->id, (int) $input['minQty']);

        $tier = ShopDiscountTier::create([
            'site_id' => $site->id,
            'minimum_quantity' => (int) $input['minQty'],
            'discount_basis_points' => (int) $input['basisPoints'],
            'is_active' => (bool) ($input['active'] ?? true),
        ]);

        return (new DiscountTierResource($tier))->response()->setStatusCode(201);
    }

    public function update(DiscountTierRequest $request, int $id): DiscountTierResource
    {
        $tier = $this->find($request, $id);
        $input = $request->validated();

        $this->assertUniqueQuantity($tier->site_id, (int) $input['minQty'], $tier->id);

        $tier->fill([
            'minimum_quantity' => (int) $input['minQty'],
            'discount_basis_points' => (int) $input['basisPoints'],
            'is_active' => (bool) ($input['active'] ?? $tier->is_active),
        ])->save();

        return new DiscountTierResource($tier);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $this->find($request, $id)->delete();

        return response()->json(null, 204);
    }

    private function find(Request $request, int $id): ShopDiscountTier
    {
        $tier = ShopDiscountTier::query()->forSite($this->site($request))->find($id);

        abort_unless($tier !== null, 404, 'Tahap diskaun tidak ditemui.');

        return $tier;
    }

    private function assertUniqueQuantity(int $siteId, int $minQty, ?int $ignoreId = null): void
    {
        $exists = ShopDiscountTier::query()->forSite($siteId)->where('minimum_quantity', $minQty)
            ->when($ignoreId !== null, fn ($q) => $q->whereKeyNot($ignoreId))
            ->exists();

        if ($exists) {
            throw ValidationException::withMessages(['minQty' => ['Tahap kuantiti ini sudah wujud.']]);
        }
    }
}
