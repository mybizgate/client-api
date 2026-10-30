<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Links business records to media-api items (attachment_integration.md §4,
 * option B). Mirrors media-api/create_media_attachments.sql, which is the
 * copy applied by hand (phpMyAdmin) on production, where FTPS deploys never
 * run `php artisan migrate`. Keep the two in sync.
 *
 * Only the media id is stored: never paths, filenames or bytes.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('media_attachments', function (Blueprint $table) {
            $table->char('id', 26)->primary();
            $table->string('tenant_id', 64);          // same value as X-Client-Code
            $table->string('entity_type', 48);        // product | service | business (config/attachments.php)
            $table->string('entity_id', 64);          // business record id as string
            $table->char('media_id', 26);             // media-api ULID, no foreign key
            $table->string('role', 40)->default('attachment'); // primary | logo | gallery | attachment
            $table->string('slot', 40)->nullable();   // = role for singleton roles, NULL for multi-file roles
            $table->unsignedInteger('sort_order')->default(0);
            $table->timestamps();

            $table->unique(['tenant_id', 'entity_type', 'entity_id', 'media_id', 'role'], 'ma_entity_media_role_unique');
            $table->unique(['tenant_id', 'entity_type', 'entity_id', 'slot'], 'ma_one_per_slot');
            $table->index(['tenant_id', 'entity_type', 'entity_id', 'role', 'sort_order'], 'ma_lookup');
            $table->index(['tenant_id', 'media_id'], 'ma_media_lookup');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('media_attachments');
    }
};
