<?php

namespace App\Http\Requests\Shop\Manage;

use App\Enums\PublicationStatus;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/** POST|PUT /manage/categories body = CategoryInput (API_CONTRACT §5). */
class CategoryRequest extends FormRequest
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
            'name' => ['required', 'string', 'min:2', 'max:150'],
            'slug' => ['nullable', 'string', 'max:180'],
            'description' => ['nullable', 'string', 'max:5000'],
            'sortOrder' => ['nullable', 'integer', 'min:0'],
            'status' => ['nullable', Rule::in(PublicationStatus::values())],
            'parentId' => ['nullable', 'integer', 'min:1'],
        ];
    }
}
