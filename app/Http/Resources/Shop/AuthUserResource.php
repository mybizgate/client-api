<?php

namespace App\Http\Resources\Shop;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * API_CONTRACT §2 `user` object of /auth/login and /auth/me.
 *
 * @property-read User $resource
 */
class AuthUserResource extends JsonResource
{
    public static $wrap = 'data';

    /**
     * @return array<string, string>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => (string) $this->resource->id,
            'name' => $this->resource->name,
            'email' => $this->resource->email,
            'role' => $this->resource->role->value,
        ];
    }
}
