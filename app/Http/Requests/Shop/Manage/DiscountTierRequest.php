<?php

namespace App\Http\Requests\Shop\Manage;

use Illuminate\Foundation\Http\FormRequest;

/** POST|PUT /manage/shop/discount-tiers (owner only). Rate given in basis points. */
class DiscountTierRequest extends FormRequest
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
            'minQty' => ['required', 'integer', 'min:2', 'max:1000000'],
            'basisPoints' => ['required', 'integer', 'min:1', 'max:10000'],
            'active' => ['nullable', 'boolean'],
        ];
    }
}
