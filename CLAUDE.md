# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`client-api` is the **MyBizGate Client API**: a Laravel 13 (PHP ^8.3) JSON backend for the MyBizGate multi-tenant SME website platform. It is the business/domain API; the sibling `../media-api` (`media-api.mybizgate.com`) is the files/media API and must not be touched from here. The workspace `~/Workspace/mybizgate/` also holds `platform/` (deploy tooling), `clients/`, `templates/` and `uploads/`; the workspace root must never become a Git repository.

The canonical repo is `https://github.com/mybizgate/client-api` (branches `main` for development, `deploy` for production). This local directory is a clone of it (remote `origin` over SSH).

`AGENTS.md` is a copy of the Laravel Boost bootstrap block (also reproduced at the bottom of this file). Keep the two in sync if you edit one. `README.md` is the stock Laravel README plus a short "Production Deployment" section; `CLIENT_API_DEPLOY.md` is the full deployment spec the workflow was built from.

## Commands

Dev dependencies are **not** installed locally (`vendor/` was installed with `--no-dev`, so PHPUnit, Pint and Pail are missing and `php artisan test` reports "Command test is not defined"). Run `composer install` first. `node_modules/` is also absent.

```sh
composer install                 # installs dev deps (phpunit, pint, pail, pao)
composer setup                   # install + .env + key:generate + migrate + npm build (fresh checkout)
composer dev                     # php artisan dev: server + queue + logs + vite together
php artisan serve                # API only, http://localhost:8000

composer test                    # config:clear + php artisan test
php artisan test --filter=test_info_endpoint_returns_service_information   # single test
php artisan test tests/Feature/ExampleTest.php                            # single file

vendor/bin/pint                  # format (Laravel Pint, PSR-12 based)
vendor/bin/pint --dirty          # only changed files

php artisan migrate              # sqlite; database/database.sqlite does not exist yet
npm run build                    # vite, only needed for the welcome page
```

Tests run against sqlite `:memory:`, array cache/session and the sync queue (see `phpunit.xml`), so they need no services. All tests live in `tests/Feature/ExampleTest.php` (welcome page, `/health`, `/info`, deployment identity) plus the stock unit test.

Manual smoke test of the upload flow:

```sh
curl -s http://localhost:8000/api/v1/health
curl -s http://localhost:8000/api/v1/info
curl -s -H 'X-Client-Code: lzhub' -F file=@photo.jpg http://localhost:8000/api/v1/test/upload
```

## Architecture

**Routing.** Everything public lives in `routes/api.php` under `Route::prefix('v1')`; Laravel adds the `/api` prefix, so paths are `/api/v1/...`. `routes/web.php` only serves the stock welcome page (a test asserts `GET /` is 200, so keep it). The framework health endpoint is `/up`; the app's own is `/api/v1/health`. `bootstrap/app.php` forces JSON rendering for exceptions on `api/*`, so `abort()` calls in controllers become JSON errors automatically.

**Health / info contract.** `/api/v1/health` returns `status`, `service`, `version`, `environment`, `deployment`, `database` (hard-coded `false`) and `timestamp`; `/api/v1/info` returns `name`, `api_version`, `framework`, `laravel_version`. The deploy workflow asserts on `status`, `service`, `environment == production`, `deployment.commit` and the three `/info` fields after every release, so changing those keys or values breaks deployment verification. `deployment` is read from `bootstrap/deployment.json` (`{commit, deployed_at}`), which CI generates from `GITHUB_SHA` and which is gitignored locally; when absent it must stay `null`, never an error.

**Tenancy model.** There is no auth or tenant table yet. The tenant is the `X-Client-Code` request header (default `lzhub`), validated against `^[a-z0-9-]+$`, and it only scopes storage paths: `tenants/{tenant}/products/{uuid}.webp`. Any new tenant-aware code should reuse that header and the same slug regex until a real auth/tenant layer exists.

**Storage.** All tenant files go through the `tenant_uploads` disk in `config/filesystems.php`. Its root is `TENANT_UPLOAD_PATH` (local `.env` points at `~/Workspace/mybizgate/uploads/client-api`, i.e. outside this repo and shared with the rest of the workspace; the variable is not in `.env.example`), falling back to `storage/app/uploads`. The disk has `throw => true`, so storage failures raise exceptions instead of returning false. Never serve files by building paths from raw user input; `TestUploadController::validatePath()` shows the expected sanitising (tenant regex + `basename` + filename regex).

**Image pipeline.** `App\Http\Controllers\Api\TestUploadController` is the reference implementation: validate `jpg/jpeg/png/webp` up to 10 MB, convert with the GD extension to WebP (max 1600x1600, quality 80, alpha preserved), store under a UUID name, and return `view_url` / `download_url`. The `view` route sets `Cache-Control: public, max-age=86400`. The `/test/*` routes are prototypes; real media handling belongs to `media-api`, so prefer calling that service over growing this pipeline.

**Database.** sqlite is configured but the API does not use it yet. Only the stock users/cache/jobs migrations exist. The `User` model and `UserFactory` are untouched Laravel defaults.

## Deployment

Production is shared hosting with **no SSH**: `.github/workflows/deploy.yml` runs on every push to `deploy` (and on `workflow_dispatch`), then tests, packages and uploads via FTPS. Release flow is `git checkout deploy && git merge main && git push origin deploy`; `main` never auto-deploys.

The workflow, in order: PHP 8.3 with gd; `composer install` (with dev) and `php artisan test` + `route:list` against a throwaway CI `.env`; then `rm -rf vendor` and `composer install --no-dev --optimize-autoloader`; write `bootstrap/deployment.json`; rsync into `deploy/` excluding `.git`, `.github`, `tests/`, `.env*`, `node_modules`, runtime `storage/*` data and `bootstrap/cache/*.php`; FTPS upload with `SamKirkland/FTP-Deploy-Action` to the FTP account root (which is `/home/mybizgat/app/client-api`, `server-dir: ./`); finally poll `/api/v1/health` up to 12x10s until it reports the pushed short SHA, then check `/api/v1/info`. A failing test fails the release, so do not skip or weaken tests to get a deploy through.

Server layout that must not change: Laravel lives at `/home/mybizgat/app/client-api`, the public entry `/home/mybizgat/public_html/client-api/index.php` points at it, and the production `.env` is server-managed and never deployed (`dangerous-clean-slate: false`, `.env*` excluded). Secrets are GitHub environment `production` secrets `FTP_SERVER`, `FTP_USERNAME`, `FTP_PASSWORD`. Production vendor is built in CI; never run Composer on the host.

## Conventions

- API controllers go in `App\Http\Controllers\Api`; route all endpoints through the `v1` prefix group.
- Return `response()->json([...], <status>)` with `201` for creations; use `abort_unless`/`abort` for errors so the JSON exception renderer formats them.
- Nothing returned by `/health` or `/info` may expose absolute paths, `APP_KEY` or credentials.
- Secrets and real client data never go in this repo. `.env` is local only; `.env.example` is the template.
- Workspace-wide rules (platform CLI, deploy branches, `clients/client-<slug>/` layout) are in `../AGENTS.md` and `../MYBIZGATE_README.md`.

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
