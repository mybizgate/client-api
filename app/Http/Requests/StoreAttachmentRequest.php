<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/**
 * POST /attachments/{entityType}/{entityId}: either a `file` to upload
 * through media-api, or the `media_id` of an item the browser already
 * uploaded there. Exactly one of the two.
 */
class StoreAttachmentRequest extends FormRequest
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
        $role = $this->role();
        $imageOnly = (array) config("attachments.roles.{$role}.types", []) === ['image'];

        return [
            'role' => ['sometimes', 'string', Rule::in(array_keys((array) config('attachments.roles')))],
            'file' => array_filter([
                'required_without:media_id',
                'prohibits:media_id',
                'file',
                $imageOnly ? 'image' : null,
                'max:25600',
            ]),
            'media_id' => [
                'required_without:file',
                'prohibits:file',
                'string',
                'regex:'.config('attachments.patterns.media_id'),
            ],
        ];
    }

    public function role(): string
    {
        $role = $this->input('role');

        return is_string($role) && $role !== '' ? $role : (string) config('attachments.default_role');
    }
}
