<?php

namespace App\Http\Requests\Marketing;

use App\Services\Marketing\ProspectService;
use Illuminate\Foundation\Http\FormRequest;

/**
 * POST /marketing/prospects/import body `{rows: [record fields...]}`. Only
 * the envelope is validated here; each row is validated by ProspectService
 * and skipped with a reason when invalid or duplicate.
 */
class ImportProspectsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, array<int, string>>
     */
    public function rules(): array
    {
        return [
            'rows' => ['required', 'array', 'list', 'min:1', 'max:'.ProspectService::IMPORT_MAX_ROWS],
            'rows.*' => ['array'],
        ];
    }

    /**
     * @return list<array<string, mixed>>
     */
    public function rows(): array
    {
        return array_values($this->input('rows', []));
    }
}
