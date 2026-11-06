<?php

namespace App\Http\Requests\Marketing;

use App\Enums\TouchChannel;
use App\Enums\TouchTemplate;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/** POST /marketing/prospects/{id}/touches body `{channel, template, note?}`. */
class TouchRequest extends FormRequest
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
            'channel' => ['nullable', Rule::in(TouchChannel::values())],
            'template' => ['required', Rule::in(TouchTemplate::values())],
            'note' => ['nullable', 'string', 'max:2000'],
        ];
    }
}
