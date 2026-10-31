<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Makes the stock `users` table tenant-local (database/table structure.md §3.3):
 * owner, staff and customer accounts all live here, scoped by `site_id`, and
 * an email is unique per site only. The global `users_email_unique` index is
 * replaced by `UNIQUE(site_id, email)`.
 *
 * `role` defaults to `customer` so public registration can never escalate;
 * owner/staff rows are provisioned by trusted code that sets the role
 * explicitly. The stock table already exists on production, so this is an
 * ALTER there (see database/schema/00_core_schema_2026-10-31.sql).
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropUnique('users_email_unique');
            $table->foreignId('site_id')->after('id')->constrained()->restrictOnDelete();
            $table->string('phone', 30)->nullable()->after('email');
            $table->string('role', 20)->default('customer')->after('password');   // owner | staff | customer
            $table->string('status', 20)->default('active')->after('role');       // active | disabled
            $table->timestamp('last_login_at')->nullable()->after('email_verified_at');
            $table->unique(['site_id', 'email']);
            $table->index(['site_id', 'role']);
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement("ALTER TABLE `users` ADD CONSTRAINT `users_role_check` CHECK (`role` IN ('owner', 'staff', 'customer'))");
            DB::statement("ALTER TABLE `users` ADD CONSTRAINT `users_status_check` CHECK (`status` IN ('active', 'disabled'))");
        }
    }

    public function down(): void
    {
        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `users` DROP CONSTRAINT `users_role_check`');
            DB::statement('ALTER TABLE `users` DROP CONSTRAINT `users_status_check`');
        }

        // The foreign key borrows the (site_id, email) index, so it goes first.
        Schema::table('users', function (Blueprint $table) {
            $table->dropForeign(['site_id']);
            $table->dropUnique(['site_id', 'email']);
            $table->dropIndex(['site_id', 'role']);
            $table->dropColumn(['site_id', 'phone', 'role', 'status', 'last_login_at']);
            $table->unique('email');
        });
    }
};
