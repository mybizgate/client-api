<?php

namespace App\Http\Controllers\Api\Shop;

use App\Http\Requests\Shop\CustomerOrderStatusRequest;
use App\Http\Requests\Shop\StoreOrderRequest;
use App\Http\Resources\Shop\OrderResource;
use App\Models\ShopCustomerProfile;
use App\Models\ShopOrder;
use App\Models\Site;
use App\Services\Shop\GuestTokenService;
use App\Services\Shop\OrderService;
use App\Services\Shop\OrderWorkflow;
use App\Services\Shop\ProductImageResolver;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Collection;

/**
 * Customer order endpoints (API_CONTRACT §4). Scoped to the guest profile of
 * the bearer token; an order of another profile answers 404.
 */
class OrderController extends ShopController
{
    public function __construct(
        private readonly OrderService $orders,
        private readonly OrderWorkflow $workflow,
        private readonly GuestTokenService $tokens,
        private readonly ProductImageResolver $images,
    ) {}

    public function index(Request $request): AnonymousResourceCollection
    {
        $profile = $this->customerOrFail($request);

        $orders = ShopOrder::query()
            ->forSite($this->site($request))
            ->where('customer_profile_id', $profile->id)
            ->with(['items.product', 'history'])
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->get();

        $this->attachImages($orders, $request);

        return OrderResource::collection($orders);
    }

    public function show(Request $request, string $reference): OrderResource
    {
        $order = $this->find($request, $reference);

        $this->attachImages(collect([$order]), $request);

        return new OrderResource($order);
    }

    public function store(StoreOrderRequest $request): JsonResponse
    {
        $site = $this->site($request);
        $profile = $this->customer($request);
        $guestToken = null;
        $input = $request->validated();

        if ($profile === null) {
            $guestToken = $this->tokens->generate();
            $profile = ShopCustomerProfile::create([
                'site_id' => $site->id,
                'guest_token_hash' => $this->tokens->hash($guestToken),
                'store_name' => trim($input['customer']['storeName']),
                'contact_name' => trim($input['customer']['contactName']),
                'phone' => trim($input['customer']['phone']),
                'address' => trim((string) ($input['customer']['address'] ?? '')) === '' ? null : trim((string) $input['customer']['address']),
                'last_seen_at' => now(),
            ]);
        }

        $order = $this->orders->create($site, $profile, $input);
        $order->load(['items.product', 'history']);
        $this->attachImages(collect([$order]), $request);

        $body = ['data' => (new OrderResource($order))->resolve($request)];

        if ($guestToken !== null) {
            $body['guestToken'] = $guestToken;
        }

        return response()->json($body, 201);
    }

    public function updateStatus(CustomerOrderStatusRequest $request, string $reference): OrderResource
    {
        $order = $this->find($request, $reference);

        $order = $this->workflow->customerTransition($order, $request->status());
        $order->load(['items.product', 'history']);
        $this->attachImages(collect([$order]), $request);

        return new OrderResource($order);
    }

    private function find(Request $request, string $reference): ShopOrder
    {
        $profile = $this->customerOrFail($request);
        $site = $this->site($request);

        $order = ShopOrder::query()
            ->forSite($site)
            ->where('customer_profile_id', $profile->id)
            ->where('reference_no', $reference)
            ->with(['items.product', 'history'])
            ->first();

        abort_unless($order !== null, 404, 'Pesanan tidak ditemui.');

        return $order;
    }

    /**
     * @param  Collection<int, ShopOrder>  $orders
     */
    private function attachImages(Collection $orders, Request $request): void
    {
        $products = $orders->flatMap(fn (ShopOrder $o) => $o->items->map->product)->filter()->unique('id');

        $this->images->attach($products, $this->tenant($request));
    }

    protected function site(Request $request): Site
    {
        return parent::site($request);
    }
}
