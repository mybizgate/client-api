<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Composite `(site_id, id)` unique key on `users` so the shop tables can hold
 * tenant-safe composite foreign keys `(site_id, created_by_user_id)` →
 * `users (site_id, id)` (SHOP_DESIGN.md §6.1). Redundant with the primary key
 * for lookups, required by InnoDB for the composite references.
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->unique(['site_id', 'id'], 'users_site_id_id_unique');
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropUnique('users_site_id_id_unique');
        });
    }
};
