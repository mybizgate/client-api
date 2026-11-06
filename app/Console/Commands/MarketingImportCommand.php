<?php

namespace App\Console\Commands;

use App\Enums\ProspectPriority;
use App\Enums\ProspectStatus;
use App\Enums\ProspectWebsite;
use App\Models\Client;
use App\Models\MarketingProspect;
use App\Services\Marketing\ProspectService;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Validator;

/**
 * Imports a cat-hotel prospect research CSV (../marketing/cat-hotel-prospects.csv
 * shape: name,area,state,phone,channel,website,priority,note,contacted,reply,
 * demo_sent,result) into a client's marketing pipeline.
 *
 *   php artisan marketing:import marketing ../marketing/cat-hotel-prospects.csv
 *
 * Rows whose phone already exists are skipped, and so are phoneless rows
 * whose name already exists without a phone, so the command can be re-run.
 * Production has no SSH, so `--sql` prints idempotent INSERT statements for
 * phpMyAdmin instead of writing locally (the site is resolved by client code
 * inside each statement, like `shop:user --sql`). It never prompts, so its
 * output can be redirected to a file.
 *
 *   php artisan marketing:import marketing ../marketing/cat-hotel-prospects.csv --sql > prospects.sql
 */
class MarketingImportCommand extends Command
{
    protected $signature = 'marketing:import
        {client_code : The client code (X-Client-Code), e.g. marketing}
        {csv : Path to the prospects CSV}
        {--sql : Print idempotent INSERT statements for production instead of writing to the local database}';

    protected $description = 'Import cat-hotel prospects from a CSV into a client\'s marketing pipeline; --sql prints the statements for production';

    private const string CATEGORY = 'cat_hotel';

    private const string DEMO_SLUG = 'cathotel';

    public function handle(ProspectService $prospects): int
    {
        $code = (string) $this->argument('client_code');
        $path = (string) $this->argument('csv');
        $sqlOnly = (bool) $this->option('sql');

        $rows = $this->readCsv($path);

        if ($rows === null) {
            return self::FAILURE;
        }

        if ($sqlOnly) {
            return $this->printSql($prospects, $code, $path, $rows);
        }

        $client = Client::query()->where('client_code', $code)->with('site')->first();

        if ($client === null || $client->site === null) {
            $this->error("Client '{$code}' has no site. Create the client and site first.");

            return self::FAILURE;
        }

        $site = $client->site;
        $fresh = [];
        $skipped = [];

        foreach ($rows as $row) {
            $phone = MarketingProspect::normalisePhone($row['phone']);

            if ($phone === null && MarketingProspect::query()->forSite($site)->whereNull('phone')->where('name', $row['name'])->exists()) {
                $skipped[] = ['name' => $row['name'], 'reason' => 'A prospect with this name and no phone already exists.'];

                continue;
            }

            $fresh[] = $row;
        }

        $result = $prospects->import($site, $fresh);
        $skipped = [...$skipped, ...$result['skipped']];

        foreach ($skipped as $skip) {
            $this->line(sprintf('  skipped  %s: %s', $skip['name'] ?? '(no name)', $skip['reason']));
        }

        $this->info(sprintf('Created %d, skipped %d for site "%s".', $result['created'], count($skipped), $site->site_name));

        return self::SUCCESS;
    }

    /**
     * @param  list<array<string, string|null>>  $rows
     */
    private function printSql(ProspectService $prospects, string $code, string $path, array $rows): int
    {
        $q = fn (?string $value): string => $value === null ? 'NULL' : "'".str_replace(['\\', "'"], ['\\\\', "''"], $value)."'";
        $seen = [];
        $written = 0;

        $this->line("-- marketing:import {$code} ".basename($path).' (generated '.now()->toDateTimeString().' UTC)');
        $this->line('-- Idempotent: a row is inserted only when the site has no prospect with the same phone');
        $this->line('-- (or, for rows without a phone, no phoneless prospect with the same name).');
        $this->line('SET NAMES utf8mb4;');

        foreach ($rows as $row) {
            $row = $prospects->prepare($row);
            $validator = Validator::make($row, $prospects->rules(null), $prospects->messages());

            if ($validator->fails()) {
                $this->line('-- skipped '.str_replace(["\r", "\n"], ' ', (string) $row['name']).': '.$validator->errors()->first());

                continue;
            }

            $v = $validator->validated();
            $phone = $v['phone'] ?? null;

            if ($phone !== null && isset($seen[$phone])) {
                $this->line('-- skipped '.str_replace(["\r", "\n"], ' ', $v['name'])." : duplicate of {$seen[$phone]} earlier in this file");

                continue;
            }

            if ($phone !== null) {
                $seen[$phone] = $v['name'];
            }

            $guard = $phone !== null
                ? '`p`.`phone` = '.$q($phone)
                : '`p`.`phone` IS NULL AND `p`.`name` = '.$q($v['name']);

            $this->line('INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)');
            $this->line('SELECT `s`.`id`, '.implode(', ', [
                $q($v['name']), $q($phone), $q($v['category']), $q($v['area'] ?? null), $q($v['state'] ?? null), $q($v['channel'] ?? null),
                $q($v['website']), $q($v['priority']), $q($v['status']), $q($v['demo_slug'] ?? null), $q($v['notes'] ?? null),
            ]).', UTC_TIMESTAMP(), UTC_TIMESTAMP()');
            $this->line('FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`');
            $this->line('WHERE `c`.`client_code` = '.$q($code));
            $this->line("  AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND {$guard});");
            $written++;
        }

        $this->line("-- {$written} statement(s)");

        return self::SUCCESS;
    }

    /**
     * Reads the CSV and maps each line to prospect fields.
     *
     * @return list<array<string, string|null>>|null
     */
    private function readCsv(string $path): ?array
    {
        if (! is_file($path) || ! is_readable($path)) {
            $this->error("Cannot read {$path}.");

            return null;
        }

        $handle = fopen($path, 'r');
        $header = $handle === false ? false : fgetcsv($handle, escape: '');

        if ($header === false || $header === null) {
            $this->error("{$path} is empty.");

            return null;
        }

        $header = array_map(fn ($h) => strtolower(trim((string) $h, " \t\n\r\0\x0B\u{FEFF}")), $header);

        foreach (['name', 'phone'] as $required) {
            if (! in_array($required, $header, true)) {
                $this->error("{$path} has no '{$required}' column.");

                return null;
            }
        }

        $rows = [];

        while (($line = fgetcsv($handle, escape: '')) !== false) {
            if ($line === [null] || $line === []) {
                continue;
            }

            $cells = array_combine($header, array_pad(array_slice($line, 0, count($header)), count($header), ''));
            $rows[] = $this->mapRow(array_map(fn ($c) => trim((string) $c), $cells));
        }

        fclose($handle);

        return $rows;
    }

    /**
     * CSV columns → prospect fields: website "none found…" → none, "has…" or a
     * domain → has_site (the domain is kept in the notes), otherwise unknown;
     * a non-empty `contacted` → status contacted; priority as given (B when
     * not A–D); the outreach columns are appended to the notes.
     *
     * @param  array<string, string>  $cells
     * @return array<string, string|null>
     */
    private function mapRow(array $cells): array
    {
        $rawWebsite = $cells['website'] ?? '';
        $website = $this->mapWebsite($rawWebsite);
        $priority = strtoupper($cells['priority'] ?? '');

        $notes = array_filter([
            $cells['note'] ?? '',
            $website === ProspectWebsite::HasSite ? "Website: {$rawWebsite}" : '',
            ...array_map(
                fn (string $column) => ($cells[$column] ?? '') !== '' ? "{$column}: {$cells[$column]}" : '',
                ['contacted', 'reply', 'demo_sent', 'result'],
            ),
        ], fn (string $part) => $part !== '');

        return [
            'name' => $cells['name'] ?? '',
            'phone' => ($cells['phone'] ?? '') === '' ? null : $cells['phone'],
            'category' => self::CATEGORY,
            'area' => ($cells['area'] ?? '') === '' ? null : $cells['area'],
            'state' => ($cells['state'] ?? '') === '' ? null : $cells['state'],
            'channel' => ($cells['channel'] ?? '') === '' ? null : $cells['channel'],
            'website' => $website->value,
            'priority' => ProspectPriority::tryFrom($priority)?->value ?? ProspectPriority::B->value,
            'status' => (($cells['contacted'] ?? '') !== '' ? ProspectStatus::Contacted : ProspectStatus::New)->value,
            'demo_slug' => self::DEMO_SLUG,
            'notes' => $notes === [] ? null : implode("\n", $notes),
        ];
    }

    private function mapWebsite(string $raw): ProspectWebsite
    {
        $value = strtolower($raw);

        return match (true) {
            str_starts_with($value, 'none found') => ProspectWebsite::None,
            str_contains($value, 'has') => ProspectWebsite::HasSite,
            preg_match('/^[a-z0-9-]+(\.[a-z0-9-]+)*\.[a-z]{2,}\b/', $value) === 1 => ProspectWebsite::HasSite,
            default => ProspectWebsite::Unknown,
        };
    }
}
