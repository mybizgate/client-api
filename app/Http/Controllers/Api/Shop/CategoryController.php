<?php

namespace App\Http\Controllers\Api\Shop;

use App\Http\Resources\Shop\CategoryResource;
use App\Models\ShopCategory;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\AnonymousResourceCollection;

/** GET /categories (API_CONTRACT §3): active categories by sortOrder, name. */
class CategoryController extends ShopController
{
    public function index(Request $request): AnonymousResourceCollection
    {
        $categories = ShopCategory::query()
            ->forSite($this->site($request))
            ->active()
            ->orderBy('sort_order')
            ->orderBy('name')
            ->get();

        return CategoryResource::collection($categories);
    }
}
