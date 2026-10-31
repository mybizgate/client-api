<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Replaces Laravel's email-keyed reset table with one keyed by `user_id`
 * (database/table structure.md §3.4). Emails are only unique per site, so the
 * stock table (and the stock Password broker, which keys on email) cannot be
 * used; a small tenant-aware reset service owns this table instead.
 *
 * `token` holds a hash of the emailed token, never the raw value. At most one
 * outstanding token per user (primary key), deleted after a successful reset.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::dropIfExists('password_reset_tokens');

        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->foreignId('user_id')->primary()->constrained()->cascadeOnDelete();
            $table->string('token');                       // hashed reset token
            $table->timestamp('created_at')->useCurrent();
            $table->dateTime('expires_at');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('password_reset_tokens');

        Schema::create('password_reset_tokens', function (Blueprint $table) {
            $table->string('email')->primary();
            $table->string('token');
            $table->timestamp('created_at')->nullable();
        });
    }
};
