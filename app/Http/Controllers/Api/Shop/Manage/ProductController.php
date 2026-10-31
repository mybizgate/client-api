<?php

namespace App\Http\Controllers\Api\Shop\Manage;

use App\Http\Controllers\Api\Shop\ShopController;
use App\Http\Requests\Shop\Manage\InventoryRequest;
use App\Http\Requests\Shop\Manage\ProductRequest;
use App\Http\Resources\Shop\ProductResource;
use App\Models\ShopProduct;
use App\Services\Shop\ProductImageResolver;
use App\Services\Shop\ShopProductService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Validation\Rule;

/** /manage/products (API_CONTRACT §5): owner/staff of the resolved site. */
class ProductController extends ShopController
{
    public function __construct(
        private readonly ShopProductService $products,
        private readonly ProductImageResolver $images,
    ) {}

    public function index(Request $request): AnonymousResourceCollection
    {
        $filters = $request->validate([
            'status' => ['nullable', Rule::in(['draft', 'active', 'archived'])],
            'category' => ['nullable', 'integer', 'min:1'],
            'search' => ['nullable', 'string', 'max:150'],
        ]);

        $query = ShopProduct::query()->forSite($this->site($request))->with('category');

        if (! empty($filters['status'])) {
            $query->where('status', $filters['status']);
        }
        if (! empty($filters['category'])) {
            $query->where('category_id', (int) $filters['category']);
        }
        $term = trim((string) ($filters['search'] ?? ''));
        if ($term !== '') {
            $like = '%'.str_replace(['%', '_'], ['\\%', '\\_'], mb_strtolower($term)).'%';
            $query->where(function (Builder $q) use ($like): void {
                foreach (['name', 'sku', 'brand', 'pack_size'] as $column) {
                    $q->orWhereRaw("lower({$column}) like ?", [$like]);
                }
            });
        }

        $products = $query->orderBy('sort_order')->orderBy('name')->get();
        $this->images->attach($products, $this->tenant($request));

        return ProductResource::collection($products->map(fn (ShopProduct $p) => new ProductResource($p, true)));
    }

    public function store(ProductRequest $request): JsonResponse
    {
        $product = $this->products->create($this->site($request), $this->staff($request), $request->validated());

        return $this->respond($request, $product, 201);
    }

    public function show(Request $request, int $id): JsonResponse
    {
        return $this->respond($request, $this->find($request, $id));
    }

    public function update(ProductRequest $request, int $id): JsonResponse
    {
        $product = $this->products->update($this->find($request, $id), $this->staff($request), $request->validated());

        return $this->respond($request, $product);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $this->products->archive($this->find($request, $id), $this->staff($request));

        return response()->json(null, 204);
    }

    public function inventory(InventoryRequest $request, int $id): JsonResponse
    {
        $product = $this->products->recordMovement(
            $this->find($request, $id),
            $this->staff($request),
            $request->movementType(),
            (int) $request->validated('quantityDelta'),
            $request->validated('note'),
        );

        return $this->respond($request, $product);
    }

    private function find(Request $request, int $id): ShopProduct
    {
        $product = ShopProduct::query()->forSite($this->site($request))->with('category')->find($id);

        abort_unless($product !== null, 404, 'Produk tidak ditemui.');

        return $product;
    }

    private function respond(Request $request, ShopProduct $product, int $status = 200): JsonResponse
    {
        $product->loadMissing('category');
        $this->images->attach([$product], $this->tenant($request));

        return (new ProductResource($product, true))->response()->setStatusCode($status);
    }
}
