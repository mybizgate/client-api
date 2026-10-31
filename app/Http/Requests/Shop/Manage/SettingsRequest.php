<?php

namespace App\Http\Requests\Shop\Manage;

use Illuminate\Foundation\Http\FormRequest;

/** PUT /manage/shop/settings body = Settings (API_CONTRACT §5), owner only. */
class SettingsRequest extends FormRequest
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
            'currency' => ['required', 'string', 'size:3', 'alpha'],
            'minimumOrder' => ['required', 'integer', 'min:0'],
            'deliveryFee' => ['required', 'integer', 'min:0'],
            'freeDeliveryFrom' => ['nullable', 'integer', 'min:0'],
            'allowWhatsappOrder' => ['required', 'boolean'],
            'deductStockOnConfirm' => ['required', 'boolean'],
            'referencePrefix' => ['required', 'string', 'min:1', 'max:12', 'regex:/^[A-Z0-9]+$/'],
        ];
    }
}
