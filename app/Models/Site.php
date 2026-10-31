<?php

namespace App\Models;

use Database\Factories\SiteFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\HasOne;

/**
 * One website / web application per client. A site that is not `active`
 * refuses logins and public shop reads (403 with status, status_reason, remarks).
 *
 * @property int $id
 * @property int $client_id
 * @property string $site_name
 * @property string $status
 * @property string|null $status_reason
 * @property string|null $remarks
 */
#[Fillable([
    'client_id', 'site_name', 'domain', 'domain_type', 'site_type', 'package_name', 'first_year_price',
    'renewal_price', 'billing_months', 'start_date', 'expiry_date', 'status', 'status_reason', 'remarks',
])]
class Site extends Model
{
    /** @use HasFactory<SiteFactory> */
    use HasFactory;

    public const string STATUS_ACTIVE = 'active';

    protected function casts(): array
    {
        return [
            'start_date' => 'date',
            'expiry_date' => 'date',
            'first_year_price' => 'decimal:2',
            'renewal_price' => 'decimal:2',
            'billing_months' => 'integer',
        ];
    }

    public function isActive(): bool
    {
        return $this->status === self::STATUS_ACTIVE;
    }

    /**
     * @return BelongsTo<Client, $this>
     */
    public function client(): BelongsTo
    {
        return $this->belongsTo(Client::class);
    }

    /**
     * @return HasMany<User, $this>
     */
    public function users(): HasMany
    {
        return $this->hasMany(User::class);
    }

    /**
     * @return HasOne<ShopSetting, $this>
     */
    public function shopSettings(): HasOne
    {
        return $this->hasOne(ShopSetting::class);
    }
}
