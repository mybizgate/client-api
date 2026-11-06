<?php

namespace App\Http\Requests\Marketing;

use App\Enums\ProspectCategory;
use App\Enums\ProspectPriority;
use App\Enums\ProspectStatus;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/** GET /marketing/prospects query string. */
class ProspectIndexRequest extends FormRequest
{
    public const array SORTS = ['priority', 'updated', 'name'];

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
            'q' => ['nullable', 'string', 'max:120'],
            'status' => ['nullable', Rule::in(ProspectStatus::values())],
            'priority' => ['nullable', Rule::in(ProspectPriority::values())],
            'category' => ['nullable', Rule::in(ProspectCategory::values())],
            'state' => ['nullable', 'string', 'max:60'],
            'has_phone' => ['nullable', Rule::in(['0', '1'])],
            'sort' => ['nullable', Rule::in(self::SORTS)],
            'page' => ['nullable', 'integer', 'min:1'],
        ];
    }
}
