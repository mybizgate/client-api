<?php

namespace App\Models;

use App\Enums\ProspectPriority;
use App\Enums\ProspectStatus;
use App\Enums\ProspectWebsite;
use App\Models\Concerns\BelongsToSite;
use Database\Factories\MarketingProspectFactory;
use Illuminate\Database\Eloquent\Attributes\Fillable;
use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Support\Carbon;

/**
 * Outreach prospect of the marketing site (../marketing/app-spec/API_CONTRACT.md).
 * `phone` is stored normalised (digits only, E.164 without "+"); use
 * `normalisePhone()` before every write or lookup.
 *
 * @property int $id
 * @property int $site_id
 * @property string $name
 * @property string|null $phone
 * @property-read string|null $phone_display
 * @property string $category
 * @property string|null $area
 * @property string|null $state
 * @property string|null $channel
 * @property ProspectWebsite $website
 * @property ProspectPriority $priority
 * @property ProspectStatus $status
 * @property string|null $demo_slug
 * @property string|null $notes
 * @property Carbon|null $last_touch_at
 * @property Carbon|null $created_at
 * @property Carbon|null $updated_at
 */
#[Fillable(['site_id', 'name', 'phone', 'category', 'area', 'state', 'channel', 'website', 'priority', 'status', 'demo_slug', 'notes', 'last_touch_at'])]
class MarketingProspect extends Model
{
    use BelongsToSite;

    /** @use HasFactory<MarketingProspectFactory> */
    use HasFactory;

    /** E.164 country codes of one and two digits; every other code is read as three digits. */
    private const SHORT_COUNTRY_CODES = [
        '1', '7', '20', '27', '30', '31', '32', '33', '34', '36', '39', '40', '41', '43', '44', '45', '46', '47', '48', '49',
        '51', '52', '53', '54', '55', '56', '57', '58', '60', '61', '62', '63', '64', '65', '66', '81', '82', '84', '86',
        '90', '91', '92', '93', '94', '95', '98',
    ];

    protected $table = 'marketing_prospects';

    protected $attributes = [
        'website' => 'unknown',
        'priority' => 'B',
        'status' => 'new',
    ];

    protected function casts(): array
    {
        return [
            'site_id' => 'integer',
            'website' => ProspectWebsite::class,
            'priority' => ProspectPriority::class,
            'status' => ProspectStatus::class,
            'last_touch_at' => 'datetime',
        ];
    }

    /**
     * Touches sent to this prospect. Not named `touches()` because
     * Eloquent's Model::touches($relation) already owns that name; count it
     * as `withCount('touchHistory as touches_count')`.
     *
     * @return HasMany<MarketingTouch, $this>
     */
    public function touchHistory(): HasMany
    {
        return $this->hasMany(MarketingTouch::class, 'prospect_id');
    }

    /**
     * Contract rule: strip spaces, dashes and the leading "+" (in practice
     * every non-digit), then a leading trunk "0" becomes Malaysia's "60".
     * Empty input gives null.
     *
     *   0183122854 → 60183122854, "+60 18-312 2854" → 60183122854
     */
    public static function normalisePhone(?string $phone): ?string
    {
        $digits = preg_replace('/\D+/', '', (string) $phone) ?? '';

        if ($digits === '') {
            return null;
        }

        if (str_starts_with($digits, '0')) {
            $digits = '60'.substr($digits, 1);
        }

        return $digits;
    }

    /**
     * Human-readable number: "+60 18-312 2854" for Malaysian numbers,
     * "+<country code> <rest>" otherwise.
     */
    public static function formatPhone(?string $phone): ?string
    {
        if ($phone === null || $phone === '') {
            return null;
        }

        if (str_starts_with($phone, '60') && strlen($phone) >= 9) {
            $national = substr($phone, 2);
            // Mobile (1x) and East Malaysian (8x) prefixes have two digits, others one.
            $prefixLength = in_array($national[0], ['1', '8'], true) ? 2 : 1;
            $prefix = substr($national, 0, $prefixLength);
            $subscriber = substr($national, $prefixLength);
            $split = strlen($subscriber) >= 8 ? 4 : 3;

            return '+60 '.$prefix.'-'.substr($subscriber, 0, $split).' '.substr($subscriber, $split);
        }

        foreach ([1, 2] as $length) {
            if (in_array(substr($phone, 0, $length), self::SHORT_COUNTRY_CODES, true)) {
                return '+'.substr($phone, 0, $length).' '.substr($phone, $length);
            }
        }

        return '+'.substr($phone, 0, 3).' '.substr($phone, 3);
    }

    /**
     * @return Attribute<string|null, never>
     */
    protected function phoneDisplay(): Attribute
    {
        return Attribute::get(fn (): ?string => self::formatPhone($this->phone));
    }
}
