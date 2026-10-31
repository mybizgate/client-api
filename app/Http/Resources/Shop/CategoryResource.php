<?php

namespace App\Http\Resources\Shop;

use App\Models\ShopCategory;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * API_CONTRACT §3 `Category`; with `managed` also §5 `ManagedCategory`.
 *
 * @property-read ShopCategory $resource
 */
class CategoryResource extends JsonResource
{
    public static $wrap = 'data';

    public function __construct(ShopCategory $resource, private readonly bool $managed = false)
    {
        parent::__construct($resource);
    }

    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        $c = $this->resource;

        $data = [
            'id' => (string) $c->id,
            'name' => $c->name,
            'slug' => $c->slug,
            'description' => $this->when($c->description !== null, $c->description),
            'active' => $c->isActive(),
            'sortOrder' => $c->sort_order,
        ];

        if ($this->managed) {
            $data['status'] = $c->status->value;
            $data['parentId'] = $c->parent_id === null ? null : (string) $c->parent_id;
        }

        return $data;
    }
}
