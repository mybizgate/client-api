<?php

namespace App\Http\Controllers\Api\Shop\Manage;

use App\Http\Controllers\Api\Shop\ShopController;
use App\Http\Requests\Shop\Manage\PaymentMethodRequest;
use App\Http\Resources\Shop\PaymentMethodResource;
use App\Models\ShopPaymentMethod;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Validation\ValidationException;

/**
 * /manage/shop/payment-methods (owner only). Checkout matches the label
 * string (decision §13.4), so an active method's label is immutable:
 * deactivate it and create a new one instead.
 */
class PaymentMethodController extends ShopController
{
    public function index(Request $request): AnonymousResourceCollection
    {
        return PaymentMethodResource::collection(
            ShopPaymentMethod::query()->forSite($this->site($request))->orderBy('sort_order')->orderBy('id')->get()
        );
    }

    public function store(PaymentMethodRequest $request): JsonResponse
    {
        $site = $this->site($request);
        $input = $request->validated();

        $this->assertUnique($site->id, $input['code'], $input['label']);

        $method = ShopPaymentMethod::create([
            'site_id' => $site->id,
            'code' => $input['code'],
            'label' => trim($input['label']),
            'instructions' => isset($input['instructions']) && trim($input['instructions']) !== '' ? trim($input['instructions']) : null,
            'sort_order' => (int) ($input['sortOrder'] ?? 0),
            'is_active' => (bool) ($input['active'] ?? true),
        ]);

        return (new PaymentMethodResource($method))->response()->setStatusCode(201);
    }

    public function update(PaymentMethodRequest $request, int $id): PaymentMethodResource
    {
        $method = $this->find($request, $id);
        $input = $request->validated();
        $label = trim($input['label']);

        if ($method->is_active && $label !== $method->label) {
            throw ValidationException::withMessages(['label' => ['Label kaedah aktif tidak boleh ditukar; nyahaktifkan dan cipta kaedah baharu.']]);
        }

        $this->assertUnique($method->site_id, $input['code'], $label, $method->id);

        $method->fill([
            'code' => $input['code'],
            'label' => $label,
            'instructions' => isset($input['instructions']) && trim($input['instructions']) !== '' ? trim($input['instructions']) : null,
            'sort_order' => (int) ($input['sortOrder'] ?? $method->sort_order),
            'is_active' => (bool) ($input['active'] ?? $method->is_active),
        ])->save();

        return new PaymentMethodResource($method);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $method = $this->find($request, $id);
        $method->is_active = false;
        $method->save();

        return response()->json(null, 204);
    }

    private function find(Request $request, int $id): ShopPaymentMethod
    {
        $method = ShopPaymentMethod::query()->forSite($this->site($request))->find($id);

        abort_unless($method !== null, 404, 'Kaedah pembayaran tidak ditemui.');

        return $method;
    }

    private function assertUnique(int $siteId, string $code, string $label, ?int $ignoreId = null): void
    {
        $base = ShopPaymentMethod::query()->forSite($siteId)->when($ignoreId !== null, fn ($q) => $q->whereKeyNot($ignoreId));

        if ((clone $base)->where('code', $code)->exists()) {
            throw ValidationException::withMessages(['code' => ['Kod ini sudah digunakan.']]);
        }

        if ((clone $base)->where('label', $label)->exists()) {
            throw ValidationException::withMessages(['label' => ['Label ini sudah digunakan.']]);
        }
    }
}
