<?php

namespace App\Http\Resources\Shop;

use App\Models\ShopCustomerProfile;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

/**
 * API_CONTRACT §4 `Customer`. Never exposes the token hash.
 *
 * @property-read ShopCustomerProfile $resource
 */
class CustomerProfileResource extends JsonResource
{
    public static $wrap = 'data';

    /**
     * @return array<string, string>
     */
    public function toArray(Request $request): array
    {
        return [
            'storeName' => $this->resource->store_name,
            'contactName' => $this->resource->contact_name,
            'phone' => $this->resource->phone,
            'address' => $this->resource->address ?? '',
        ];
    }
}
