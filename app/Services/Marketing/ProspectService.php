<?php

namespace App\Services\Marketing;

use App\Enums\ProspectCategory;
use App\Enums\ProspectPriority;
use App\Enums\ProspectStatus;
use App\Enums\ProspectWebsite;
use App\Enums\TouchChannel;
use App\Models\MarketingProspect;
use App\Models\MarketingTouch;
use App\Models\Site;
use Closure;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

/**
 * Rules and writes of the marketing prospects API
 * (../marketing/app-spec/API_CONTRACT.md). Shared by the Form Requests, the
 * bulk import endpoint and `php artisan marketing:import`, so every path
 * normalises phones and rejects duplicates the same way.
 */
class ProspectService
{
    public const int IMPORT_MAX_ROWS = 500;

    /**
     * Input with `phone` normalised. A phone containing anything other than
     * digits, spaces, dashes, dots, brackets or "+" is left as typed so the
     * format rule rejects it instead of silently dropping it.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function prepare(array $input): array
    {
        if (array_key_exists('phone', $input) && (is_string($input['phone']) || is_int($input['phone']))) {
            $raw = trim((string) $input['phone']);
            $input['phone'] = preg_match('/^[\d\s\-+().]*$/', $raw) === 1 ? MarketingProspect::normalisePhone($raw) : $raw;
        }

        return $input;
    }

    /**
     * Validation rules for one prospect. `partial` (PATCH) makes every field
     * optional; `ignoreId` excludes the record itself from the duplicate check.
     * Without a site (SQL generation) the duplicate check is left out.
     *
     * @return array<string, array<int, mixed>>
     */
    public function rules(?Site $site, bool $partial = false, ?int $ignoreId = null): array
    {
        // POST: enum fields may be omitted or null (column default). PATCH: present means non-null.
        $enum = fn (array $values): array => $partial ? ['sometimes', 'required', Rule::in($values)] : ['nullable', Rule::in($values)];

        return [
            'name' => [$partial ? 'sometimes' : 'bail', 'required', 'string', 'min:2', 'max:120'],
            'phone' => ['nullable', 'string', 'regex:/^\d{8,15}$/', ...($site === null ? [] : [$this->uniquePhoneRule($site, $ignoreId)])],
            'category' => $enum(ProspectCategory::values()),
            'area' => ['nullable', 'string', 'max:120'],
            'state' => ['nullable', 'string', 'max:60'],
            'channel' => ['nullable', 'string', 'max:200'],
            'website' => $enum(ProspectWebsite::values()),
            'priority' => $enum(ProspectPriority::values()),
            'status' => $enum(ProspectStatus::values()),
            'demo_slug' => ['nullable', Rule::in(ProspectCategory::DEMO_SLUGS)],
            'notes' => ['nullable', 'string', 'max:5000'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return ['phone.regex' => 'The phone number must have 8 to 15 digits.'];
    }

    public function duplicateOf(Site|int $site, ?string $phone, ?int $ignoreId = null): ?MarketingProspect
    {
        if ($phone === null || $phone === '') {
            return null;
        }

        return MarketingProspect::query()
            ->forSite($site)
            ->where('phone', $phone)
            ->when($ignoreId !== null, fn ($q) => $q->whereKeyNot($ignoreId))
            ->first();
    }

    public function duplicateMessage(MarketingProspect $existing): string
    {
        return "This number already belongs to {$existing->name} (status {$existing->status->value}).";
    }

    /**
     * @param  array<string, mixed>  $validated
     */
    public function create(Site $site, array $validated): MarketingProspect
    {
        $prospect = new MarketingProspect(['site_id' => $site->id]);
        $this->fill($prospect, $validated);

        return $this->save($prospect);
    }

    /**
     * @param  array<string, mixed>  $validated
     */
    public function update(MarketingProspect $prospect, array $validated): MarketingProspect
    {
        $this->fill($prospect, $validated);

        return $this->save($prospect);
    }

    /**
     * Records a send: one touch row, `last_touch_at`, and new → contacted.
     * Later statuses are never moved backwards.
     *
     * @param  array{channel?: string|null, template: string, note?: string|null}  $validated
     */
    public function recordTouch(MarketingProspect $prospect, array $validated): MarketingProspect
    {
        return DB::transaction(function () use ($prospect, $validated): MarketingProspect {
            $locked = MarketingProspect::query()->forSite($prospect->site_id)->lockForUpdate()->findOrFail($prospect->id);
            $sentAt = now();

            MarketingTouch::create([
                'site_id' => $locked->site_id,
                'prospect_id' => $locked->id,
                'channel' => $validated['channel'] ?? TouchChannel::Whatsapp->value,
                'template' => $validated['template'],
                'note' => $validated['note'] ?? null,
                'sent_at' => $sentAt,
            ]);

            $locked->last_touch_at = $sentAt;

            if ($locked->status === ProspectStatus::New) {
                $locked->status = ProspectStatus::Contacted;
            }

            $locked->save();

            return $locked;
        });
    }

    /**
     * Bulk create. Each row is validated on its own; invalid rows and rows
     * whose phone already exists (in the site or earlier in the batch) are
     * skipped with a reason instead of failing the whole import.
     *
     * @param  list<array<string, mixed>>  $rows
     * @return array{created: int, skipped: list<array{name: string|null, reason: string}>}
     */
    public function import(Site $site, array $rows): array
    {
        $created = 0;
        $skipped = [];
        $seenPhones = [];

        foreach ($rows as $row) {
            $row = $this->prepare(is_array($row) ? $row : []);
            $name = isset($row['name']) && is_scalar($row['name']) ? (string) $row['name'] : null;
            $phone = is_string($row['phone'] ?? null) ? $row['phone'] : null;

            if ($phone !== null && isset($seenPhones[$phone])) {
                $skipped[] = ['name' => $name, 'reason' => "Duplicate of {$seenPhones[$phone]} earlier in this import."];

                continue;
            }

            $validator = Validator::make($row, $this->rules($site), $this->messages());

            if ($validator->fails()) {
                $skipped[] = ['name' => $name, 'reason' => $validator->errors()->first()];

                continue;
            }

            try {
                $this->create($site, $validator->validated());
            } catch (ValidationException $e) {
                $skipped[] = ['name' => $name, 'reason' => collect($e->errors())->flatten()->first()];

                continue;
            }

            if ($phone !== null) {
                $seenPhones[$phone] = $name;
            }

            $created++;
        }

        return ['created' => $created, 'skipped' => $skipped];
    }

    /**
     * @param  array<string, mixed>  $input
     */
    private function fill(MarketingProspect $prospect, array $input): void
    {
        foreach (['name', 'phone', 'category', 'area', 'state', 'channel', 'website', 'priority', 'status', 'demo_slug', 'notes'] as $field) {
            if (! array_key_exists($field, $input)) {
                continue;
            }

            // A null enum field on create keeps the column default (website unknown, priority B, status new).
            if ($input[$field] === null && in_array($field, ['category', 'website', 'priority', 'status'], true)) {
                continue;
            }

            $prospect->{$field} = is_string($input[$field]) ? trim($input[$field]) : $input[$field];
        }

        if (! $prospect->exists) {
            $prospect->category ??= ProspectCategory::Other->value;

            if (! array_key_exists('demo_slug', $input)) {
                $prospect->demo_slug = ProspectCategory::tryFrom($prospect->category)?->demoSlug();
            }
        }
    }

    /**
     * Saves, turning a unique-key race on (site_id, phone) into the same 422
     * the validator gives.
     */
    private function save(MarketingProspect $prospect): MarketingProspect
    {
        try {
            $prospect->save();
        } catch (UniqueConstraintViolationException $e) {
            $existing = $this->duplicateOf($prospect->site_id, $prospect->phone, $prospect->exists ? $prospect->id : null);

            if ($existing === null) {
                throw $e;
            }

            throw ValidationException::withMessages(['phone' => [$this->duplicateMessage($existing)]]);
        }

        return $prospect;
    }

    private function uniquePhoneRule(Site $site, ?int $ignoreId): Closure
    {
        return function (string $attribute, mixed $value, Closure $fail) use ($site, $ignoreId): void {
            $existing = is_string($value) ? $this->duplicateOf($site, $value, $ignoreId) : null;

            if ($existing !== null) {
                $fail($this->duplicateMessage($existing));
            }
        };
    }
}
