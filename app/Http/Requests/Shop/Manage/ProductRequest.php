<?php

namespace App\Http\Requests\Shop\Manage;

use App\Enums\PublicationStatus;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/** POST|PUT /manage/products body = ProductInput (API_CONTRACT §5). */
class ProductRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, array<int, mixed>>
     */
    public function rules(): array
    {
        return [
            'categoryId' => ['required', 'integer', 'min:1'],
            'name' => ['required', 'string', 'min:2', 'max:200'],
            'slug' => ['nullable', 'string', 'max:220'],
            'sku' => ['nullable', 'string', 'max:80'],
            'description' => ['nullable', 'string', 'max:20000'],
            'shortDescription' => ['nullable', 'string', 'max:500'],
            'brand' => ['nullable', 'string', 'max:150'],
            'unit' => ['required', 'string', 'max:50'],
            'packQty' => ['required', 'integer', 'min:1', 'max:1000000'],
            'size' => ['required', 'string', 'max:50'],
            'price' => ['required', 'integer', 'min:0'],
            'oldPrice' => ['nullable', 'integer', 'min:0'],
            'minimumQuantity' => ['required', 'integer', 'min:1', 'max:1000000'],
            'stockQuantity' => ['required', 'integer', 'min:0', 'max:1000000000'],
            'unlimitedStock' => ['required', 'boolean'],
            'status' => ['required', Rule::in(PublicationStatus::values())],
            'sortOrder' => ['nullable', 'integer', 'min:0'],
            'featured' => ['nullable', 'boolean'],
            'lowStockThreshold' => ['nullable', 'integer', 'min:0'],
            'art' => ['nullable', 'array'],
            'art.shape' => ['required_with:art', 'string', 'max:20'],
            'art.color' => ['required_with:art', 'string', 'max:20'],
            'art.motif' => ['required_with:art', 'string', 'max:30'],
            'art.label' => ['required_with:art', 'string', 'max:60'],
        ];
    }
}
