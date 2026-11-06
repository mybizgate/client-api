<?php

namespace App\Http\Requests\Marketing;

use App\Models\Site;
use App\Services\Marketing\ProspectService;
use Illuminate\Foundation\Http\FormRequest;

/**
 * POST /marketing/prospects (create) and PATCH /marketing/prospects/{id}
 * (partial update). The phone is normalised before validation, so the rules
 * and the duplicate check see digits only.
 */
class ProspectRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        if ($this->has('phone')) {
            $this->merge(['phone' => app(ProspectService::class)->prepare(['phone' => $this->input('phone')])['phone']]);
        }
    }

    /**
     * @return array<string, array<int, mixed>>
     */
    public function rules(): array
    {
        $partial = $this->isMethod('PATCH');
        $id = $this->route('id');

        return app(ProspectService::class)->rules($this->site(), $partial, $partial && $id !== null ? (int) $id : null);
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return app(ProspectService::class)->messages();
    }

    private function site(): Site
    {
        $site = $this->attributes->get('site');
        abort_unless($site instanceof Site, 500, 'Site not resolved.');

        return $site;
    }
}
