# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`client-api` is the **MyBizGate Client API**: a Laravel 13 (PHP ^8.3) JSON backend for the MyBizGate multi-tenant SME website platform. It is the business/domain API; the sibling `../media-api` (`media-api.mybizgate.com`) is the files/media API and must not be touched from here. The workspace `~/Workspace/mybizgate/` also holds `platform/` (deploy tooling), `clients/`, `templates/` and `uploads/`; the workspace root must never become a Git repository.

**Before writing or changing anything that involves files, images, uploads or attachments, read
`../media-api/attachment_integration.md`.** It is the contract between this API and media-api (endpoints, upload rules,
error codes, the `media_attachments` table, the adapter, performance characteristics) and names `client-api` as the
reference implementation. media-api keeps the bytes and `metadata.json`; this API stores only 26-char media ids and
returns media-api URLs, never paths. `../media-api/README.md` is the full media-api reference and
`../media-api/create_media_attachments.sql` is the MySQL copy of the attachments schema used on production.

The canonical repo is `https://github.com/mybizgate/client-api` (branches `main` for development, `deploy` for production). This local directory is a clone of it (remote `origin` over SSH).

`AGENTS.md` is a copy of the Laravel Boost bootstrap block (also reproduced at the bottom of this file). Keep the two in sync if you edit one. `README.md` is the stock Laravel README plus a short "Production Deployment" section; `CLIENT_API_DEPLOY.md` is the full deployment spec the workflow was built from.

## Commands

Dev dependencies (PHPUnit, Pint, Pail) are installed in `vendor/`; if `php artisan test` ever reports "Command test is not defined", `vendor/` was rebuilt with `--no-dev` and `composer install` fixes it. `node_modules/` is absent and only matters for the welcome page.

```sh
composer install                 # installs dev deps (phpunit, pint, pail, pao)
composer setup                   # install + .env + key:generate + migrate + npm build (fresh checkout)
composer dev                     # php artisan dev: server + queue + logs + vite together
php artisan serve                # API only, http://localhost:8000

composer test                    # config:clear + php artisan test
php artisan test --filter=test_info_endpoint_returns_service_information   # single test
php artisan test --filter=AttachmentControllerTest                        # one class
php artisan test tests/Feature/ExampleTest.php                            # single file
php artisan route:list --path=attachments

vendor/bin/pint                  # format (Laravel Pint, PSR-12 based)
vendor/bin/pint --dirty          # only changed files

php artisan db:seed              # lzhub shop catalogue (ShopLzhubSeeder, idempotent); no users
php artisan shop:user lzhub --role=owner --email=owner@example.com --name="Pemilik"   # management login, hidden password prompt
php artisan shop:user lzhub --role=owner --email=owner@example.com --name="Pemilik" --sql   # same prompts, but prints the phpMyAdmin INSERT (bcrypt hash) for production instead of writing locally; copy it from the terminal (prompts share stdout, so do not redirect)
podman run --rm -v "$PWD":/app -w /app docker.io/library/php:8.3-cli php artisan test --compact   # when local PHP lacks pdo_sqlite
php artisan migrate              # local MariaDB (see Database); tests use sqlite :memory: and need pdo_sqlite
php artisan migrate --pretend    # raw SQL of pending migrations, the starting point of a database/schema/00_<task>_<date>.sql
DB_DATABASE=mybizgat_clientapi php artisan schema:dump --path=database/schema/00_main_structure.sql   # refresh the full structure (see Database change procedure)
npm run build                    # vite, only needed for the welcome page
```

Tests run against sqlite `:memory:`, array cache/session and the sync queue (see `phpunit.xml`), so they need no services, but the local PHP must have `pdo_sqlite` (`sudo apt install php8.3-sqlite3`). Without it, run the suite in a container: `podman run --rm -v "$PWD":/app -w /app docker.io/library/php:8.3-cli php artisan test` (the image has sqlite but no GD, which is why tests embed a 1x1 PNG instead of `UploadedFile::fake()->image()`). Tests: `tests/Feature/ExampleTest.php` (welcome page, `/health`, `/info`, deployment identity), the dummy controller tests, `tests/Unit/Services/MediaApiClientTest.php` and `tests/Feature/Http/Controllers/Api/AttachmentControllerTest.php` (media-api is always faked with `Http::fake()`; never call the real service from tests).

Manual smoke test (media-api must be running on `:8001`, see `MEDIA_API_URL` in `.env`):

```sh
curl -s http://localhost:8000/api/v1/health            # "database": true when MariaDB is reachable
curl -s http://localhost:8000/api/v1/info
curl -s -H 'X-Client-Code: lzhub' -F file=@photo.jpg -F role=primary \
  http://localhost:8000/api/v1/attachments/product/101  # uploads to media-api, stores the media_id
curl -s -H 'X-Client-Code: lzhub' http://localhost:8000/api/v1/attachments/product/101
curl -s -H 'X-Client-Code: lzhub' -F file=@photo.jpg http://localhost:8000/api/v1/test/upload   # legacy prototype
```

## Architecture

**Routing.** Everything public lives in `routes/api.php` under `Route::prefix('v1')`; Laravel adds the `/api` prefix, so paths are `/api/v1/...`. `routes/web.php` only serves the stock welcome page (a test asserts `GET /` is 200, so keep it). The framework health endpoint is `/up`; the app's own is `/api/v1/health`. `bootstrap/app.php` forces JSON rendering for exceptions on `api/*`, so `abort()` calls in controllers become JSON errors automatically.

**Health / info contract.** `/api/v1/health` returns `status`, `service`, `version`, `environment`, `deployment`, `database` (`true` only when a PDO connection opens; never an exception) and `timestamp`; `/api/v1/info` returns `name`, `api_version`, `framework`, `laravel_version`. The deploy workflow asserts on `status`, `service`, `environment == production`, `deployment.commit` and the three `/info` fields after every release, so changing those keys or values breaks deployment verification. `deployment` is read from `bootstrap/deployment.json` (`{commit, deployed_at}`), which CI generates from `GITHUB_SHA` and which is gitignored locally; when absent it must stay `null`, never an error.

**Tenancy model.** The tenant is the `X-Client-Code` request header, which equals `clients.client_code` (the platform slug, e.g. `lzhub`); it never comes from a request body and is an identifier, never an authorisation. Two middleware resolve it (aliases in `bootstrap/app.php`): the legacy `tenant` (`ResolveTenant`: header shape only, `^[a-z0-9-]{2,50}$`, `400` otherwise; used by the `/test/*` prototype) and `site` (`ResolveSite`: header → `clients` → `sites`; `404` unknown code, `403` with `status`, `status_reason`, `remarks` when the site is not `active`; exposes `tenant`, `client` and `site` request attributes). Every shop and attachment route uses `site`. Three bearer tokens exist: a **guest token** (64 hex chars, SHA-256 stored in `shop_customer_profiles.guest_token_hash`, issued by the first `POST /orders` / `PUT /customer/profile`, resolved by the `shop.customer` middleware into the `customerProfile` attribute, `401` when unknown), a **Sanctum staff token** (`auth:sanctum` + `site.staff`: active `owner|staff` user whose `site_id` is the resolved site; `site.owner` narrows to owners) and none for public catalogue reads. `ResolveSite` is prepended to the middleware priority list so site errors win over Sanctum's `401`. A staff token is never a customer token (`/orders` with one behaves as if no token were sent).

**Storage.** All tenant files go through the `tenant_uploads` disk in `config/filesystems.php`. Its root is `TENANT_UPLOAD_PATH` (local `.env` points at `~/Workspace/mybizgate/uploads/client-api`, i.e. outside this repo and shared with the rest of the workspace; the variable is not in `.env.example`), falling back to `storage/app/uploads`. The disk has `throw => true`, so storage failures raise exceptions instead of returning false. Never serve files by building paths from raw user input; `TestUploadController::validatePath()` shows the expected sanitising (tenant regex + `basename` + filename regex).

**Image pipeline.** `App\Http\Controllers\Api\TestUploadController` is the reference implementation: validate `jpg/jpeg/png/webp` up to 10 MB, convert with the GD extension to WebP (max 1600x1600, quality 80, alpha preserved), store under a UUID name, and return `view_url` / `download_url`. The `view` route sets `Cache-Control: public, max-age=86400`. The `/test/*` routes are prototypes; real media handling belongs to `media-api`, so prefer calling that service over growing this pipeline.

**Shop domain (replaces the former dummy routes).** The supplier catalogue/ordering API consumed by `../clients/client-lzhub`. The JSON contract is `../clients/client-lzhub/docs/shop/API_CONTRACT.md` (ids as strings, money in integer sen, `{"data": …}` envelopes, Malay validation messages mirroring the frontend) and the data design is `../clients/client-lzhub/SHOP_DESIGN.md`; change the contract file before changing a response shape. Code lives under `App\Http\Controllers\Api\Shop` (public: `ClientConfigController`, `CategoryController`, `ProductController`, `CustomerProfileController`, `OrderController`, `AuthController`; `Manage\*` for `/manage/*`), `App\Http\Requests\Shop`, `App\Http\Resources\Shop` (`ProductResource`/`CategoryResource`/`OrderResource` take a `managed` flag for the richer management shape), `App\Enums` (PHP enums mirroring the CHECK constraints) and `App\Services\Shop`: `OrderPricingService` (exact parity with the frontend `pricing.ts`, including JavaScript `Math.round` semantics via `jsRound()`), `OrderReferenceService` (`{prefix}-{YYYYMMDD}-{NNNN}` with `lockForUpdate()` on `shop_settings`), `OrderService` (`POST /orders` transaction), `OrderWorkflow` (customer vs staff transitions, one history row per change), `StockService` (ledger rows; orders move stock only when `shop_settings.deduct_stock_on_confirm` is on and never for `unlimited_stock` products), `ShopProductService` (management writes, slug generation, `adjustment` movements for stock edits), `GuestTokenService`, `ProductImageResolver` (one `media_attachments` query per request → `Product.images[]`). Every query goes through the `BelongsToSite::forSite()` scope. `php artisan shop:user <client_code> --role=owner|staff` creates or updates a management login with a hidden password prompt (passwords never go in SQL, seeds or docs); because production has no SSH, `--sql` prints an idempotent `INSERT … ON DUPLICATE KEY UPDATE` carrying only the bcrypt hash, resolving the site by client code, for pasting into phpMyAdmin. `database/seeders/ShopLzhubSeeder` is the Eloquent twin of `../clients/client-lzhub/docs/shop/shop_seed_lzhub.sql`.

**Media attachments (media-api integration).** Implements `../media-api/attachment_integration.md`. `App\Services\MediaApiClient` is the only code that talks to media-api (`services.media_api.base_url`, env `MEDIA_API_URL`): `upload`, `metadata`, `assign`, `delete`, plus `urls()` which derives `view_url`/`thumbnail_url`/… from a media id without a round trip. `App\Services\AttachmentService` holds the rules (upload-then-link, verify-then-assign-then-link, singleton roles replace their slot, detach never deletes in media-api, a failed row after an upload logs the orphaned `media_id`). `config/attachments.php` is the allowlist of entity types (`product`, `category`, `service`, `business` → media-api `module`; `product` and `category` also name the Eloquent `model` that must exist in the resolved site, `404` otherwise) and roles (`primary`/`logo` singleton image, `gallery` images, `attachment` any type). Routes (behind `site` + `auth:sanctum` + `site.staff`, i.e. owner/staff of the site): `GET|POST /api/v1/attachments/{entityType}/{entityId}` and `DELETE /api/v1/attachments/{attachmentId}`. Responses are `{"data": …}` with media-api URLs only, never paths. Only the 26-char `media_id` is stored; `tenant_id` stays the client code. The browser uploads to media-api itself and then links the `media_id` here (`role: primary` for the product card image).

**Database.** MySQL/MariaDB everywhere except tests: the local `.env` points at the workspace MariaDB (`127.0.0.1:3306`, database `mybizgat_platform`); `.env.example` is the single sectioned template for local and production (section A = the values that differ, each with its `production:` value commented), and production uses the server-managed `.env` at `/home/mybizgat/app/client-api/.env`. Tables: the stock cache/jobs/sessions migrations, `sample` (demo CRUD behind `App\Http\Controllers\Api\SampleController`, `Route::apiResource('sample')` at `/api/v1/sample`; copy its shape for real resources and drop it when a real one exists), `media_attachments` (`database/migrations/2026_10_30_000000_create_media_attachments_table.php`, mirrored by `../media-api/create_media_attachments.sql` for phpMyAdmin; keep the two in sync), the core tenant schema below, and Sanctum's `personal_access_tokens`. `/api/v1/health` reports `database: true` only when a PDO connection can be opened. media-api itself has no database and never reads `media_attachments`.

**Shop schema** (`database/migrations/2026_10_31_1*`, hand-applied copy `database/schema/00_shop_schema_2026-10-31.sql`, designed in `../clients/client-lzhub/SHOP_DESIGN.md` §6): `shop_settings` (one row per site, owner switch `deduct_stock_on_confirm`, reference sequence), `shop_categories`, `shop_products` (money in minor units, `unlimited_stock`, soft deletes), `shop_discount_tiers`, `shop_payment_methods` (checkout matches the `label` string, so active labels are immutable), `shop_customer_profiles` (guest token hash or future `user_id`), `shop_orders` (`reference_no` is the frontend `Order.id`), `shop_order_items`, `shop_order_status_history`, `shop_inventory_movements` (append-only ledger) and the deferred `shop_favourites`. All of them carry `site_id` with composite `(site_id, x_id)` foreign keys that rely on the `users (site_id, id)` unique key; every column has a `COMMENT`; enum-like columns use named MariaDB CHECK constraints behind the driver guard. Migrations and the SQL file were proven identical with the change procedure below. The lzhub data (`../clients/client-lzhub/docs/shop/shop_seed_lzhub.sql`) is applied by hand after the schema; `php artisan db:seed` runs the equivalent `ShopLzhubSeeder` locally.

**Mail.** Outgoing mail (password resets, notifications) goes through the cPanel mailbox `no-reply@mybizgate.com` over SMTPS (`mail.mybizgate.com:465`), configured by the `MAIL_*` block in `.env.example` section B; only `MAIL_PASSWORD` is secret and never committed. `MAIL_TEST_TO` (`mybizgateway@gmail.com`) is the inbox for test sends. The only sender so far is the password reset: `App\Services\Shop\PasswordResetService` (owns `password_reset_tokens`, stores the SHA-256 of a 64-hex token, 60 min TTL from `config/shop.php`, revokes all Sanctum tokens on reset) behind `POST /auth/forgot-password` (always 200, mails only active owner/staff) and `POST /auth/reset-password`, with `App\Mail\PasswordResetMail` (`resources/views/mail/password-reset*.blade.php`, Malay). Links point at `SHOP_FRONTEND_URL` when set (local Vite), else `https://<sites.domain>`; never at a caller-supplied host. The two routes use the named limiters in `AppServiceProvider` because inline `throttle:n,m` shares one bucket per IP across routes.

**Core tenant schema** (`database/migrations/2026_10_31_*`, designed in `database/table structure.md`, SQL in `database/schema/00_core_schema_2026-10-31.sql`). `clients` (1) → `sites` (0..1, `UNIQUE(client_id)`) → `users` and `payments`; `password_reset_tokens` hangs off `users`. Rules that the schema encodes and code must respect: `clients.client_code` is the platform slug and the `X-Client-Code` value (lowercase, CHECK-constrained to `^[a-z0-9-]{2,50}$`; `media_attachments.tenant_id` holds the same string, no FK). `sites.domain_type` is `subdomain|custom` (the platform's values), `status` is `draft|active|expired|suspended`; a site that is not `active` must refuse login and the response must carry `status`, `status_reason` and `remarks`. `users` is the stock table made tenant-local: email is unique per `(site_id, email)` only, `role` is `owner|staff|customer` (default `customer`, so public registration can never escalate; `site_id` and `role` are never request-fillable), `status` is `active|disabled`. `password_reset_tokens` is keyed by `user_id` and stores a hashed token with `expires_at`; the stock Password broker keys by email and cannot be used, so a small tenant-aware reset service owns that table. `payments` is an append-only ledger (`registration|renewal`, `pending|paid|rejected`, inclusive `period_end`); confirming one must update the row (`WHERE status = 'pending'`), set `verified_at` and advance `sites.expiry_date` in one transaction with `lockForUpdate()` on the site. All enum-like columns are `VARCHAR` with named MariaDB CHECK constraints (added only when the driver is mysql/mariadb, so the sqlite test database skips them); mirror them with PHP enums and Form Request `in:` rules. API auth is Laravel Sanctum bearer tokens (`User` uses `HasApiTokens`); `UserFactory` is still the stock one and does not set the required `site_id`, so give it a `Site` before the first test that uses it.

**Database change procedure.** Production has no SSH and the FTPS deploy never runs `php artisan migrate`, so every schema change ships twice: as a migration (local, CI, tests) and as hand-applied SQL in `database/schema/`. That directory holds exactly two kinds of file: `00_main_structure.sql`, the complete current structure plus `migrations` rows (fresh installs only, it starts with `DROP TABLE IF EXISTS`), and one `00_<task>_<YYYY-MM-DD>.sql` per change, which is what gets pasted into phpMyAdmin on a live database. For every change:

1. Write the migration(s) (`php artisan make:migration`), with CHECK constraints behind an `in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)` guard.
2. `php artisan migrate` locally (`.env` → `mybizgat_platform`); run the suite in the container if local PHP lacks `pdo_sqlite`.
3. Write `database/schema/00_<task>_<YYYY-MM-DD>.sql` by hand: a header with how to apply it, one section per table (`php artisan migrate --pretend` gives the raw statements, then add the CHECK constraints and comments), and at the end `SET @batch := (SELECT COALESCE(MAX(batch), 0) + 1 FROM migrations);` plus an `INSERT INTO migrations` row per migration file (without `.php`). The file must run exactly once and only on top of the previous `00_main_structure.sql`.
4. Prove the SQL matches the migrations on the spare local database `mybizgat_clientapi` (same MariaDB user, normally empty): `DB_DATABASE=mybizgat_clientapi php artisan migrate --force` from empty, capture `SHOW CREATE TABLE` for every table, `DB_DATABASE=mybizgat_clientapi php artisan migrate:reset --force` (this also proves every `down()`), then apply the previous `00_main_structure.sql` plus the new task file by hand and diff the two captures; they must be identical apart from `AUTO_INCREMENT` counters. Do not drop tables there by hand; use `migrate:reset`.
5. Regenerate the full structure from a database that has everything applied: `DB_DATABASE=mybizgat_clientapi php artisan schema:dump --path=database/schema/00_main_structure.sql` (never `--prune`, never `migrate:fresh`). The `--path` is required because the default name is `mysql-schema.sql`, which is no longer used.
6. Commit migrations, both SQL files and, when `media_attachments` changed, `../media-api/create_media_attachments.sql`. On production: back up, paste the task file into phpMyAdmin, then `curl .../api/v1/health` must still report `"database": true`.

## Deployment

Production is shared hosting with **no SSH**: `.github/workflows/deploy.yml` runs on every push to `deploy` (and on `workflow_dispatch`), then tests, packages and uploads via FTPS. Release flow is `git checkout deploy && git merge main && git push origin deploy`; `main` never auto-deploys.

The workflow, in order: PHP 8.3 with gd, pdo_mysql and pdo_sqlite (the feature tests need sqlite); `composer install` (with dev) and `php artisan test` + `route:list` against a throwaway CI `.env`; then `rm -rf vendor` and `composer install --no-dev --optimize-autoloader`; write `bootstrap/deployment.json`; rsync into `deploy/` excluding `.git`, `.github`, `tests/`, `.env*`, `node_modules`, runtime `storage/*` data and `bootstrap/cache/*.php`; FTPS upload with `SamKirkland/FTP-Deploy-Action` to the FTP account root (which is `/home/mybizgat/app/client-api`, `server-dir: ./`); finally poll `/api/v1/health` up to 12x10s until it reports the pushed short SHA, then check `/api/v1/info`. A failing test fails the release, so do not skip or weaken tests to get a deploy through.

Server layout that must not change: Laravel lives at `/home/mybizgat/app/client-api`, the public entry `/home/mybizgat/public_html/client-api/index.php` points at it, and the production `.env` is server-managed and never deployed (`dangerous-clean-slate: false`, `.env*` excluded). Secrets are GitHub environment `production` secrets `FTP_SERVER`, `FTP_USERNAME`, `FTP_PASSWORD`. Production vendor is built in CI; never run Composer on the host.

## Conventions

- API controllers go in `App\Http\Controllers\Api`; route all endpoints through the `v1` prefix group.
- Return `response()->json([...], <status>)` with `201` for creations; use `abort_unless`/`abort` for errors so the JSON exception renderer formats them.
- Nothing returned by `/health` or `/info` may expose absolute paths, `APP_KEY` or credentials.
- Secrets and real client data never go in this repo. `.env` is local only; `.env.example` is the template.
- Workspace-wide rules (platform CLI, deploy branches, `clients/client-<slug>/` layout) are in `../AGENTS.md` and `../MYBIZGATE_README.md`.
- `.claude/` is gitignored; `.claude/skills/` holds the Laravel Boost skills selected in `boost.json` (`laravel-best-practices`, `testing-best-practices`, …) and is regenerated by `php artisan boost:update` (or `boost:install`), so do not hand-edit those skill files. `.mcp.json` registers the `laravel-boost` MCP server (`php artisan boost:mcp`). There is no `.ai/rules` directory.

<laravel-boost-guidelines>
=== foundation rules ===

# Laravel Boost Guidelines

## Foundational Context

This application is a Laravel application running on PHP 8.3. Always use the APIs that match the installed major version of each package — do not assume a version.

Before relying on a package's API, confirm its installed version:
- PHP packages: run `composer show --direct` to list direct dependencies with versions, or `composer show <vendor/package>` for a single package.
- JS packages: check `package.json` for the installed versions.

## Skills Activation

This project has domain-specific skills available in `**/skills/**`. You MUST activate the relevant skill whenever you work in that domain—don't wait until you're stuck.

## Conventions

- You must follow all existing code conventions used in this application. When creating or editing a file, check sibling files for the correct structure, approach, and naming.
- Use descriptive names for variables and methods. For example, `isRegisteredForDiscounts`, not `discount()`.
- Check for existing components to reuse before writing a new one.

## Verification Scripts

- Do not create verification scripts or tinker when tests cover that functionality and prove they work. Unit and feature tests are more important.

## Application Structure & Architecture

- Stick to existing directory structure; don't create new base folders without approval.
- Do not change the application's dependencies without approval.

## Frontend Bundling

- If a frontend change doesn't show in the UI or you get a "Unable to locate file in Vite manifest" error, run `npm run build` or ask the user to run `npm run dev` or `composer run dev`.

## Documentation Files

- You must only create documentation files if explicitly requested by the user.

=== boost rules ===

# Laravel Boost

## Tools

- Laravel Boost is an MCP server with tools designed specifically for this application. Prefer Boost tools over manual alternatives like shell commands or file reads.
- Use `database-query` to run read-only queries against the database instead of writing raw SQL in tinker.
- Use `database-schema` to inspect table structure before writing migrations or models.
- Use `get-absolute-url` to resolve the correct scheme, domain, and port for project URLs. Always use this before sharing a URL with the user.
- Use `browser-logs` to read browser logs, errors, and exceptions. Only recent logs are useful, ignore old entries.

## Searching Documentation (IMPORTANT)

- Use `search-docs` before changes that depend on Laravel ecosystem APIs, behavior, configuration, or version-specific syntax. Skip it for copy-only edits and other changes where package documentation is irrelevant. Reuse sufficient results already in context instead of searching again.
- Pass a `packages` array to scope results when you know which packages are relevant.
- Use multiple broad, topic-based queries: `['rate limiting', 'routing rate limiting', 'routing']`. Expect the most relevant results first.
- Do not add package names to queries because package info is already shared. Use `test resource table`, not `filament 4 test resource table`.

### Search Syntax

1. Use words for auto-stemmed AND logic: `rate limit` matches both "rate" AND "limit".
2. Use `"quoted phrases"` for exact position matching: `"infinite scroll"` requires adjacent words in order.
3. Combine words and phrases for mixed queries: `middleware "rate limit"`.
4. Use multiple queries for OR logic: `queries=["authentication", "middleware"]`.

## Project Rules

- This project contains committed, area-grouped rules in `.ai/rules` when that directory exists, including path-scoped framework guidelines under `.ai/rules/boost`. Before you enter plan mode or create/edit any file, you MUST first: open @.ai/rules/index.md (it maps file globs to rule files), read every rule file whose globs cover the path(s) in scope, and run `grep -rin 'keyword' .ai/rules` to catch what a path match alone misses. Do not write code until you have read and are following every matching rule. If `.ai/rules` does not exist, continue without it.

## Artisan

- Run Artisan commands directly via the command line (e.g., `php artisan route:list`). Use `php artisan list` to discover available commands and `php artisan [command] --help` to check parameters.
- Inspect routes with `php artisan route:list`. Filter with: `--method=GET`, `--name=users`, `--path=api`, `--except-vendor`, `--only-vendor`.
- Read configuration values using dot notation: `php artisan config:show app.name`, `php artisan config:show database.default`. Or read config files directly from the `config/` directory.

## Tinker

- Execute PHP in app context for debugging and testing code. Do not create models without user approval, prefer tests with factories instead. Prefer existing Artisan commands over custom tinker code.
- Always use single quotes to prevent shell expansion: `php artisan tinker --execute 'Your::code();'`
  - Double quotes for PHP strings inside: `php artisan tinker --execute 'User::where("active", true)->count();'`

=== php rules ===

# PHP

- Always use curly braces for control structures, even for single-line bodies.
- Use PHP 8 constructor property promotion: `public function __construct(public GitHub $github) { }`. Do not leave empty zero-parameter `__construct()` methods unless the constructor is private.
- Use explicit return type declarations and type hints for all method parameters: `function isAccessible(User $user, ?string $path = null): bool`
- Use TitleCase for Enum keys: `FavoritePerson`, `BestLake`, `Monthly`.
- Prefer PHPDoc blocks over inline comments. Only add inline comments for exceptionally complex logic.
- Use array shape type definitions in PHPDoc blocks.

=== deployments rules ===

# Deployment

- Laravel can be deployed using [Laravel Cloud](https://cloud.laravel.com/), which is the fastest way to deploy and scale production Laravel applications.
- Activate the `deploying-to-cloud` skill whenever deploying to Laravel Cloud, configuring Cloud environments or resources, using the Cloud CLI, or troubleshooting Cloud deployments.

=== laravel/core rules ===

# Do Things the Laravel Way

- Use `php artisan make:` commands to create new files (i.e. migrations, controllers, models, etc.). You can list available Artisan commands using `php artisan list` and check their parameters with `php artisan [command] --help`.
- If you're creating a generic PHP class, use `php artisan make:class`.
- Pass `--no-interaction` to all Artisan commands to ensure they work without user input. You should also pass the correct `--options` to ensure correct behavior.

### Model Creation

- When creating new models, create useful factories and seeders for them too. Ask the user if they need any other things, using `php artisan make:model --help` to check the available options.

## APIs & Eloquent Resources

- For APIs, default to using Eloquent API Resources and API versioning unless existing API routes do not, then you should follow existing application convention.

## URL Generation

- When generating links to other pages, prefer named routes and the `route()` function.

## Testing

- When creating models for tests, use the factories for the models. Check if the factory has custom states that can be used before manually setting up the model.
- Faker: Use methods such as `$this->faker->word()` or `fake()->randomDigit()`. Follow existing conventions whether to use `$this->faker` or `fake()`.
- When creating tests, make use of `php artisan make:test [options] {name}` to create a feature test, and pass `--unit` to create a unit test. Most tests should be feature tests.

=== pint/core rules ===

# Laravel Pint Code Formatter

- If you have modified any PHP files, you must run `vendor/bin/pint --dirty --format agent` before finalizing changes to ensure your code matches the project's expected style.
- Do not run `vendor/bin/pint --test --format agent`, simply run `vendor/bin/pint --format agent` to fix any formatting issues.

=== phpunit/core rules ===

# PHPUnit

- This project uses PHPUnit. Create tests with `php artisan make:test --phpunit {name}`.
- Do not include the test suite directory in `{name}`. Use `SomeFeatureTest`, not `Feature/SomeFeatureTest`.
- Read the `testing-best-practices` skill for guidance on coverage, naming, structure, dependency isolation, and review.

## Running Tests

- Run the narrowest set of tests that covers the change. Pass a file path or `--filter=testName` to `php artisan test --compact`.
- Rerun a test after each change to it.
- Run `vendor/bin/phpunit` to call the test runner directly. It accepts the same file path and `--filter=testName` arguments.

</laravel-boost-guidelines>
