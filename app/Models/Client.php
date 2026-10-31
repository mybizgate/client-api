<?php

namespace App\Models;

use Database\Factories\ClientFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasOne;

/**
 * A MyBizGate business customer. `client_code` is the platform slug and the
 * exact `X-Client-Code` value (also media_attachments.tenant_id).
 *
 * @property int $id
 * @property string $client_code
 * @property string $business_name
 */
#[Fillable([
    'client_code', 'business_name', 'registration_no', 'business_nature', 'contact_person', 'email',
    'phone_primary', 'phone_secondary', 'address_line1', 'address_line2', 'city', 'state', 'postcode',
    'country', 'remarks',
])]
class Client extends Model
{
    /** @use HasFactory<ClientFactory> */
    use HasFactory;

    /**
     * @return HasOne<Site, $this>
     */
    public function site(): HasOne
    {
        return $this->hasOne(Site::class);
    }
}
