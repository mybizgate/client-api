<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Laravel Logo"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Build Status"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>
<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>
</p>

## About Laravel

Laravel is a web application framework with expressive, elegant syntax. We believe development must be an enjoyable and creative experience to be truly fulfilling. Laravel takes the pain out of development by easing common tasks used in many web projects, such as:

- [Simple, fast routing engine](https://laravel.com/docs/routing).
- [Powerful dependency injection container](https://laravel.com/docs/container).
- Multiple back-ends for [session](https://laravel.com/docs/session) and [cache](https://laravel.com/docs/cache) storage.
- Expressive, intuitive [database ORM](https://laravel.com/docs/eloquent).
- Database agnostic [schema migrations](https://laravel.com/docs/migrations).
- [Robust background job processing](https://laravel.com/docs/queues).
- [Real-time event broadcasting](https://laravel.com/docs/broadcasting).

Laravel is accessible, powerful, and provides tools required for large, robust applications.

## Learning Laravel

Laravel has the most extensive and thorough [documentation](https://laravel.com/docs) and video tutorial library of all modern web application frameworks, making it a breeze to get started with the framework.

In addition, [Laracasts](https://laracasts.com) contains thousands of video tutorials on a range of topics including Laravel, modern PHP, unit testing, and JavaScript. Boost your skills by digging into our comprehensive video library.

You can also watch bite-sized lessons with real-world projects on [Laravel Learn](https://laravel.com/learn), where you will be guided through building a Laravel application from scratch while learning PHP fundamentals.

## Agentic Development

Laravel's predictable structure and conventions make it ideal for AI coding agents like Claude Code, Cursor, and GitHub Copilot. Install [Laravel Boost](https://laravel.com/docs/ai) to supercharge your AI workflow:

```bash
composer require laravel/boost --dev

php artisan boost:install
```

Boost provides your agent 15+ tools and skills that help agents build Laravel applications while following best practices.

## Contributing

Thank you for considering contributing to the Laravel framework! The contribution guide can be found in the [Laravel documentation](https://laravel.com/docs/contributions).

## Code of Conduct

In order to ensure that the Laravel community is welcoming to all, please review and abide by the [Code of Conduct](https://laravel.com/docs/contributions#code-of-conduct).

## Security Vulnerabilities

If you discover a security vulnerability within Laravel, please send an e-mail to Taylor Otwell via [taylor@laravel.com](mailto:taylor@laravel.com). All security vulnerabilities will be promptly addressed.

## License

The Laravel framework is open-sourced software licensed under the [MIT license](https://opensource.org/licenses/MIT).

## Production Deployment

Repository: https://github.com/mybizgate/client-api

Deploy branch: `deploy`

Production application: `/home/mybizgat/app/client-api`

Public entry: `/home/mybizgat/public_html/client-api`

Production URL: https://client-api.mybizgate.com

Health: https://client-api.mybizgate.com/api/v1/health

Push to the `deploy` branch to deploy through GitHub Actions. The production
`.env` is server-managed and is never deployed.

### Environment

`.env.example` is the single template for every environment. Section **A** holds the only values that differ
between local development and production (each line carries its `production:` value as a comment); section **B**
is identical everywhere. Tests ignore the file (`phpunit.xml` forces sqlite `:memory:`).

Local: `cp .env.example .env && php artisan key:generate && php artisan migrate` against the workspace MariaDB.

Production (`/home/mybizgat/app/client-api/.env`): copy `.env.example` and set section A to

```env
APP_ENV=production
APP_DEBUG=false
APP_URL=https://client-api.mybizgate.com
APP_KEY=                      # php artisan key:generate --show, generated once, never changed
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=mybizgat_platform # cPanel database for client-api
DB_USERNAME=                  # cPanel MySQL user granted on that database
DB_PASSWORD=
TENANT_UPLOAD_PATH=/home/mybizgat/data/client-api/uploads
MEDIA_API_URL=https://media-api.mybizgate.com/api/v1
LOG_LEVEL=warning
```

### Database schema on production

The deploy never runs migrations. The schema travels as `database/schema/mysql-schema.sql`, generated from the
local MariaDB with `php artisan schema:dump` (every table plus the rows of the `migrations` table, no data, no
credentials). Keep `cache`, `session` and `queue` on the file/sync drivers so no extra tables are needed at runtime.

First install:

1. cPanel → MySQL Databases: create the database and a user, grant the user all privileges on it, put them in the
   production `.env` (`DB_*`).
2. cPanel → phpMyAdmin → select the database → SQL tab → paste the whole `database/schema/mysql-schema.sql` → Go.
   **Only on an empty database**: the file starts every table with `DROP TABLE IF EXISTS`, so re-running it on a
   live database destroys all data.
3. `curl https://client-api.mybizgate.com/api/v1/health` must report `"database": true`.

Every later migration:

1. Write the migration, then **before** running it locally capture its SQL:
   `php artisan migrate --pretend` (prints the statements without executing).
2. `php artisan migrate` locally, then `php artisan schema:dump` and commit the refreshed schema file.
3. In phpMyAdmin run the captured statements, then record the migration so Laravel never tries to run it again:
   `INSERT INTO migrations (migration, batch) VALUES ('<file name without .php>', <last batch + 1>);`
   (the `INSERT` lines at the bottom of the schema file show the exact format).

Never run `php artisan migrate:fresh` or `schema:dump --prune`; the migration files stay the source of truth.
