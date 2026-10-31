<?php

namespace App\Http\Controllers\Api\Shop\Manage;

use App\Enums\OrderStatus;
use App\Http\Controllers\Api\Shop\ShopController;
use App\Http\Requests\Shop\Manage\OrderStatusRequest;
use App\Http\Resources\Shop\OrderResource;
use App\Models\ShopOrder;
use App\Services\Shop\OrderWorkflow;
use App\Services\Shop\ProductImageResolver;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Collection;
use Illuminate\Validation\Rule;

/** /manage/orders (API_CONTRACT §5): all customers of the site, staff transitions. */
class OrderController extends ShopController
{
    public function __construct(
        private readonly OrderWorkflow $workflow,
        private readonly ProductImageResolver $images,
    ) {}

    public function index(Request $request): AnonymousResourceCollection
    {
        $filters = $request->validate(['status' => ['nullable', Rule::in(OrderStatus::values())]]);

        $orders = ShopOrder::query()
            ->forSite($this->site($request))
            ->when(! empty($filters['status']), fn ($q) => $q->where('status', $filters['status']))
            ->with(['items.product', 'history'])
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->get();

        $this->attachImages($orders, $request);

        return OrderResource::collection($orders->map(fn (ShopOrder $o) => new OrderResource($o, true)));
    }

    public function show(Request $request, string $reference): OrderResource
    {
        $order = $this->find($request, $reference);
        $this->attachImages(collect([$order]), $request);

        return new OrderResource($order, true);
    }

    public function updateStatus(OrderStatusRequest $request, string $reference): OrderResource
    {
        $order = $this->workflow->staffTransition($this->find($request, $reference), $request->status(), $this->staff($request), $request->validated('note'));
        $order->load(['items.product', 'history']);
        $this->attachImages(collect([$order]), $request);

        return new OrderResource($order, true);
    }

    private function find(Request $request, string $reference): ShopOrder
    {
        $order = ShopOrder::query()
            ->forSite($this->site($request))
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
}
