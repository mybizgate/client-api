<?php

namespace App\Console\Commands;

use App\Enums\UserRole;
use App\Models\Client;
use App\Models\User;
use Illuminate\Console\Command;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\Rule;
use Illuminate\Validation\ValidationException;

/**
 * Creates or updates an owner/staff login for a client's site. Passwords are
 * typed at a hidden prompt (never in SQL, seeds, docs or arguments).
 *
 *   php artisan shop:user lzhub --role=owner --email=owner@example.com --name="Pemilik"
 *
 * Production has no SSH, so `--sql` prints an idempotent INSERT (with the
 * bcrypt hash, never the password) to paste into phpMyAdmin instead of
 * writing to the local database. The site is resolved by client code inside
 * the statement, so local and production ids need not match.
 *
 *   php artisan shop:user lzhub --role=owner --email=owner@example.com --name="Pemilik" --sql
 */
class ShopUserCommand extends Command
{
    protected $signature = 'shop:user
        {client_code : The client code (X-Client-Code), e.g. lzhub}
        {--role=owner : owner or staff}
        {--email= : Login e-mail (asked when omitted)}
        {--name= : Display name (asked when omitted)}
        {--sql : Print the production INSERT statement instead of writing to the local database}';

    protected $description = 'Create or update an owner/staff login for a client site (password asked at a hidden prompt); --sql prints the statement for production';

    public function handle(): int
    {
        $code = (string) $this->argument('client_code');
        $sqlOnly = (bool) $this->option('sql');

        $client = Client::query()->where('client_code', $code)->with('site')->first();

        if (! $sqlOnly && ($client === null || $client->site === null)) {
            $this->error("Client '{$code}' has no site. Create the client and site first.");

            return self::FAILURE;
        }

        $role = UserRole::tryFrom((string) $this->option('role'));

        if ($role === null || ! $role->isStaff()) {
            $this->error('--role must be owner or staff.');

            return self::FAILURE;
        }

        $email = (string) ($this->option('email') ?: $this->ask('E-mail'));
        $name = (string) ($this->option('name') ?: $this->ask('Name'));
        $password = (string) $this->secret('Password (min 8 characters)');
        $confirm = (string) $this->secret('Confirm password');

        try {
            Validator::make(
                ['code' => $code, 'email' => $email, 'name' => $name, 'password' => $password, 'confirm' => $confirm],
                [
                    'code' => ['required', 'string', 'max:50', 'regex:/^[a-z0-9][a-z0-9-]*$/'],
                    'email' => ['required', 'email', 'max:255'],
                    'name' => ['required', 'string', 'min:2', 'max:255'],
                    'password' => ['required', 'string', 'min:8', 'max:255'],
                    'confirm' => ['required', Rule::in([$password])],
                ],
                ['confirm.in' => 'The passwords do not match.', 'code.regex' => 'The client code may only contain lowercase letters, digits and dashes.'],
            )->validate();
        } catch (ValidationException $e) {
            foreach ($e->errors() as $messages) {
                foreach ($messages as $message) {
                    $this->error($message);
                }
            }

            return self::FAILURE;
        }

        $hash = Hash::make($password);

        if ($sqlOnly) {
            if ($client === null || $client->site === null) {
                $this->warn("Client '{$code}' is not in the local database; the statement still resolves the site by client code on the target database.");
            }

            foreach ($this->statement($code, $name, $email, $hash, $role) as $line) {
                $this->line($line);
            }

            return self::SUCCESS;
        }

        $site = $client->site;
        $user = User::query()->where('site_id', $site->id)->where('email', $email)->first() ?? new User;

        $user->forceFill([
            'site_id' => $site->id,
            'name' => $name,
            'email' => $email,
            'password' => $hash,
            'role' => $role,
            'status' => User::STATUS_ACTIVE,
            'email_verified_at' => $user->email_verified_at ?? now(),
        ])->save();

        $this->info(sprintf('%s %s user #%d (%s) for site "%s".', $user->wasRecentlyCreated ? 'Created' : 'Updated', $role->value, $user->id, $email, $site->site_name));

        return self::SUCCESS;
    }

    /**
     * Idempotent MySQL/MariaDB statement for phpMyAdmin: inserts the login or,
     * when (site_id, email) already exists, resets its password, name, role and
     * status. Fails loudly (NULL site_id) when the client has no site there.
     *
     * @return list<string>
     */
    private function statement(string $code, string $name, string $email, string $hash, UserRole $role): array
    {
        $q = fn (string $value): string => "'".str_replace(['\\', "'"], ['\\\\', "''"], $value)."'";

        return [
            "-- shop:user {$code} --role={$role->value} (generated ".now()->toDateTimeString().', bcrypt hash only)',
            'INSERT INTO `users` (`site_id`, `name`, `email`, `password`, `role`, `status`, `email_verified_at`, `created_at`, `updated_at`)',
            'SELECT `s`.`id`, '.$q($name).', '.$q($email).', '.$q($hash).', '.$q($role->value).', '.$q(User::STATUS_ACTIVE).', NOW(), NOW(), NOW()',
            'FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`',
            'WHERE `c`.`client_code` = '.$q($code),
            'ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `password` = VALUES(`password`), `role` = VALUES(`role`), `status` = VALUES(`status`), `updated_at` = NOW();',
        ];
    }
}
