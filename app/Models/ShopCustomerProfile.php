<?php

namespace App\Models;

use App\Models\Concerns\BelongsToSite;
use Database\Factories\ShopCustomerProfileFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Attributes\Hidden;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

/**
 * Shop customer identity (SHOP_DESIGN.md §5.6): a guest browser (SHA-256 of
 * its bearer token) or, later, a site user. Holds the account-screen fields.
 *
 * @property int $id
 * @property int $site_id
 * @property int|null $user_id
 * @property string|null $guest_token_hash
 * @property string $store_name
 * @property string $contact_name
 * @property string $phone
 * @property string|null $address
 */
#[Fillable(['site_id', 'user_id', 'guest_token_hash', 'store_name', 'contact_name', 'phone', 'address', 'last_seen_at'])]
#[Hidden(['guest_token_hash'])]
class ShopCustomerProfile extends Model
{
    use BelongsToSite;

    /** @use HasFactory<ShopCustomerProfileFactory> */
    use HasFactory;

    protected $table = 'shop_customer_profiles';

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'user_id' => 'integer',
            'last_seen_at' => 'datetime',
        ];
    }

    /**
     * @return BelongsTo<User, $this>
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * @return HasMany<ShopOrder, $this>
     */
    public function orders(): HasMany
    {
        return $this->hasMany(ShopOrder::class, 'customer_profile_id');
    }
}
