<?php

namespace App\Http\Controllers\Api\Shop\Manage;

use App\Enums\PublicationStatus;
use App\Http\Controllers\Api\Shop\ShopController;
use App\Http\Requests\Shop\Manage\CategoryRequest;
use App\Http\Resources\Shop\CategoryResource;
use App\Models\ShopCategory;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;
use Illuminate\Support\Str;
use Illuminate\Validation\ValidationException;

/** /manage/categories (API_CONTRACT §5). */
class CategoryController extends ShopController
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $categories = ShopCategory::query()
            ->forSite($this->site($request))
            ->orderBy('sort_order')
            ->orderBy('name')
            ->get()
            ->map(fn (ShopCategory $c) => new CategoryResource($c, true));

        return CategoryResource::collection($categories);
    }

    public function store(CategoryRequest $request): JsonResponse
    {
        $site = $this->site($request);
        $user = $this->staff($request);
        $input = $request->validated();

        $category = new ShopCategory(['site_id' => $site->id]);
        $this->fill($category, $input);
        $category->slug = $this->uniqueSlug($site->id, $input['slug'] ?? null, $category->name);
        $category->created_by_user_id = $user->id;
        $category->updated_by_user_id = $user->id;
        $category->save();

        return (new CategoryResource($category, true))->response()->setStatusCode(201);
    }

    public function update(CategoryRequest $request, int $id): CategoryResource
    {
        $category = $this->find($request, $id);
        $input = $request->validated();

        $this->fill($category, $input);

        if (! empty($input['slug']) && $input['slug'] !== $category->slug) {
            $category->slug = $this->uniqueSlug($category->site_id, $input['slug'], $category->name, $category->id);
        }

        $category->updated_by_user_id = $this->staff($request)->id;
        $category->save();

        return new CategoryResource($category, true);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $category = $this->find($request, $id);

        if ($category->products()->exists()) {
            throw ValidationException::withMessages(['id' => ['Kategori masih mempunyai produk.']]);
        }

        if ($category->children()->exists()) {
            throw ValidationException::withMessages(['id' => ['Kategori masih mempunyai sub-kategori.']]);
        }

        $category->status = PublicationStatus::Archived;
        $category->updated_by_user_id = $this->staff($request)->id;
        $category->save();
        $category->delete();

        return response()->json(null, 204);
    }

    private function find(Request $request, int $id): ShopCategory
    {
        $category = ShopCategory::query()->forSite($this->site($request))->find($id);

        abort_unless($category !== null, 404, 'Kategori tidak ditemui.');

        return $category;
    }

    /**
     * @param  array<string, mixed>  $input
     */
    private function fill(ShopCategory $category, array $input): void
    {
        $parentId = isset($input['parentId']) ? (int) $input['parentId'] : null;

        if ($parentId !== null) {
            $this->assertParent($category, $parentId);
        }

        $category->fill([
            'name' => trim($input['name']),
            'description' => isset($input['description']) && trim($input['description']) !== '' ? trim($input['description']) : null,
            'sort_order' => (int) ($input['sortOrder'] ?? $category->sort_order ?? 0),
            'status' => PublicationStatus::from($input['status'] ?? ($category->status?->value ?? PublicationStatus::Active->value)),
            'parent_id' => $parentId,
        ]);
    }

    /** SHOP_DESIGN §6.3: no self-parenting and no cycles (A → B → A). */
    private function assertParent(ShopCategory $category, int $parentId): void
    {
        $siteId = $category->site_id;

        if ($category->exists && $parentId === $category->id) {
            throw ValidationException::withMessages(['parentId' => ['Kategori tidak boleh menjadi induk dirinya sendiri.']]);
        }

        $cursor = ShopCategory::query()->forSite($siteId)->find($parentId);

        if ($cursor === null) {
            throw ValidationException::withMessages(['parentId' => ['Kategori induk tidak ditemui.']]);
        }

        for ($depth = 0; $cursor !== null && $depth < 50; $depth++) {
            if ($category->exists && $cursor->id === $category->id) {
                throw ValidationException::withMessages(['parentId' => ['Kategori induk ini akan membentuk kitaran.']]);
            }
            $cursor = $cursor->parent_id === null ? null : ShopCategory::query()->forSite($siteId)->find($cursor->parent_id);
        }
    }

    private function uniqueSlug(int $siteId, ?string $wanted, string $name, ?int $ignoreId = null): string
    {
        $base = Str::slug(trim((string) $wanted) !== '' ? (string) $wanted : $name);
        $base = $base === '' ? 'kategori' : Str::limit($base, 160, '');
        $slug = $base;

        for ($n = 2; ShopCategory::query()->withTrashed()->forSite($siteId)->where('slug', $slug)->when($ignoreId !== null, fn ($q) => $q->whereKeyNot($ignoreId))->exists(); $n++) {
            $slug = "{$base}-{$n}";
        }

        return $slug;
    }
}
