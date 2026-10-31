<?php

namespace App\Http\Requests\Shop\Manage;

use App\Enums\InventoryMovementType;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/** POST /manage/products/{id}/inventory (API_CONTRACT §5). */
class InventoryRequest extends FormRequest
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
            'movementType' => ['required', Rule::in(InventoryMovementType::manualValues())],
            'quantityDelta' => ['required', 'integer', 'not_in:0', 'min:-1000000000', 'max:1000000000'],
            'note' => ['nullable', 'string', 'max:500'],
        ];
    }

    public function movementType(): InventoryMovementType
    {
        return InventoryMovementType::from($this->validated('movementType'));
    }
}
