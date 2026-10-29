# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`client-api` is the **MyBizGate Client API**: a Laravel 13 (PHP ^8.3) JSON backend for the MyBizGate multi-tenant SME website platform. It lives inside the non-Git workspace `~/Workspace/mybizgate/` next to `platform/` (deploy tooling), `clients/`, `templates/` and `uploads/`. The workspace root must never become a Git repository; this directory currently has no `.git` of its own either.

`AGENTS.md` at this level is a copy of the Laravel Boost bootstrap block (also reproduced at the bottom of this file). Keep the two in sync if you edit one.

## Commands

Dev dependencies are **not** currently installed (`vendor/` was installed with `--no-dev`, so PHPUnit, Pint and Pail are missing and `php artisan test` reports "Command test is not defined"). Run `composer install` first. `node_modules/` is also absent.

```sh
composer install                 # installs dev deps (phpunit, pint, pail, pao)
composer setup                   # install + .env + key:generate + migrate + npm build (fresh checkout)
composer dev                     # php artisan dev: server + queue + logs + vite together
php artisan serve                # API only, http://localhost:8000

composer test                    # config:clear + php artisan test
php artisan test --filter=ExampleTest            # single test class / method
php artisan test tests/Feature/ExampleTest.php   # single file

vendor/bin/pint                  # format (Laravel Pint, PSR-12 based)
vendor/bin/pint --dirty          # only changed files

php artisan migrate              # sqlite; database/database.sqlite does not exist yet
npm run build                    # vite, only needed for the welcome page
```

Tests run against sqlite `:memory:`, array cache/session and the sync queue (see `phpunit.xml`), so they need no services.

Manual smoke test of the upload flow:

```sh
curl -s http://localhost:8000/api/v1/health
curl -s -H 'X-Client-Code: lzhub' -F file=@photo.jpg http://localhost:8000/api/v1/test/upload
```

## Architecture

**Routing.** Everything public lives in `routes/api.php` under `Route::prefix('v1')`; Laravel adds the `/api` prefix, so paths are `/api/v1/...`. `routes/web.php` only serves the stock welcome page. The framework health endpoint is `/up`; the app's own is `/api/v1/health`. `bootstrap/app.php` forces JSON rendering for exceptions on `api/*`, so `abort()` calls in controllers become JSON errors automatically.

**Tenancy model.** There is no auth or tenant table yet. The tenant is the `X-Client-Code` request header (default `lzhub`), validated against `^[a-z0-9-]+$`, and it only scopes storage paths: `tenants/{tenant}/products/{uuid}.webp`. Any new tenant-aware code should reuse that header and the same slug regex until a real auth/tenant layer exists.

**Storage.** All tenant files go through the `tenant_uploads` disk in `config/filesystems.php`. Its root is `TENANT_UPLOAD_PATH` (local `.env` points at `~/Workspace/mybizgate/uploads/client-api`, i.e. outside this repo and shared with the rest of the workspace), falling back to `storage/app/uploads`. The disk has `throw => true`, so storage failures raise exceptions instead of returning false. Never serve files by building paths from raw user input; `TestUploadController::validatePath()` shows the expected sanitising (tenant regex + `basename` + filename regex).

**Image pipeline.** `App\Http\Controllers\Api\TestUploadController` is the reference implementation: validate `jpg/jpeg/png/webp` up to 10 MB, convert with the GD extension to WebP (max 1600x1600, quality 80, alpha preserved), store under a UUID name, and return `view_url` / `download_url`. The `view` route sets `Cache-Control: public, max-age=86400`. The `/test/*` routes are prototypes expected to be replaced by real product/media endpoints; keep the same conversion and path conventions when doing so.

**Database.** sqlite is configured but the API does not use it yet (`/health` hard-codes `database => false`). Only the stock users/cache/jobs migrations exist. The `User` model and `UserFactory` are untouched Laravel defaults.

## Conventions

- API controllers go in `App\Http\Controllers\Api`; route all endpoints through the `v1` prefix group.
- Return `response()->json([...], <status>)` with `201` for creations; use `abort_unless`/`abort` for errors so the JSON exception renderer formats them.
- Secrets and real client data never go in this repo. `.env` is local only; `.env.example` is the template.
- Workspace-wide rules (platform CLI, deploy branches, `clients/client-<slug>/` layout) are in `../AGENTS.md` and `../MYBIZGATE_README.md`.

<laravel-boost-guidelines>
# Laravel Application

This repository contains a Laravel application. Complete the following setup before working on the user's request.

## Prerequisites

Verify that PHP and Composer are available:

```sh
php -v
composer -V
```

If either command is unavailable, detect the user's operating system and install the prerequisites with the appropriate command:

macOS:

```sh
/bin/bash -c "$(curl -fsSL https://php.new/install/mac/8.5)"
```

Windows PowerShell:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://php.new/install/windows/8.5'))
```

Linux:

```sh
/bin/bash -c "$(curl -fsSL https://php.new/install/linux/8.5)"
```

After installation, ask the user to restart their terminal. If the agent needs the restarted shell to continue, ask the user to reopen their terminal and rerun their original prompt.

## Agent Setup

Install Laravel Boost from the application root before making application changes:

```sh
composer require laravel/boost --dev
php artisan boost:install
```

Boost replaces these bootstrap instructions with guidelines tailored to the application. After installation, read `AGENTS.md` again and continue with the user's original request using the generated guidelines.
</laravel-boost-guidelines>
