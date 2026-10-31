<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Catalogue categories of a site (SHOP_DESIGN.md §6.3). `parent_id` allows a
 * tree later; the current screens render one flat list. Cycle prevention is
 * an application rule (MariaDB cannot express it in a CHECK).
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shop_categories', function (Blueprint $table) {
            $table->id()->comment('Internal category identifier; exposed to the frontend as Category.id (string).');
            $table->unsignedBigInteger('site_id')->comment('Site and tenant that owns the category.');
            $table->unsignedBigInteger('parent_id')->nullable()->comment('Parent category in the same site; NULL identifies a top-level category. The current screens render a flat list.');
            $table->string('name', 150)->comment('Customer-facing category name.');
            $table->string('slug', 180)->comment('URL-safe category identifier unique within the site; used by the /category/{slug} route.');
            $table->text('description')->nullable()->comment('Optional category description displayed in the catalogue.');
            $table->unsignedInteger('sort_order')->default(0)->comment('Ascending display position among sibling categories.');
            $table->string('status', 20)->default('draft')->comment('Publication state: draft, active, or archived. Only active categories are returned to customers.');
            $table->unsignedBigInteger('created_by_user_id')->nullable()->comment('Owner or staff user who created the category.');
            $table->unsignedBigInteger('updated_by_user_id')->nullable()->comment('Owner or staff user who most recently updated the category.');
            $table->timestamp('created_at')->nullable()->comment('Date and time when the category was created.');
            $table->timestamp('updated_at')->nullable()->comment('Date and time when the category was last updated.');
            $table->timestamp('deleted_at')->nullable()->comment('Soft-deletion time; NULL means the category has not been deleted.');

            $table->unique(['site_id', 'slug'], 'shop_categories_site_slug_unique');
            $table->unique(['site_id', 'id'], 'shop_categories_site_id_unique');
            $table->index(['site_id', 'status', 'parent_id', 'sort_order'], 'shop_categories_browse_index');
            $table->foreign('site_id', 'shop_categories_site_fk')->references('id')->on('sites')->cascadeOnDelete();
            $table->foreign(['site_id', 'parent_id'], 'shop_categories_parent_fk')->references(['site_id', 'id'])->on('shop_categories')->restrictOnDelete();
            $table->foreign(['site_id', 'created_by_user_id'], 'shop_categories_created_by_fk')->references(['site_id', 'id'])->on('users')->restrictOnDelete();
            $table->foreign(['site_id', 'updated_by_user_id'], 'shop_categories_updated_by_fk')->references(['site_id', 'id'])->on('users')->restrictOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `shop_categories` COMMENT = \'Catalogue categories owned by a site; parent_id allows a tree later.\'');
            DB::statement("ALTER TABLE `shop_categories` ADD CONSTRAINT `shop_categories_status_check` CHECK (`status` IN ('draft', 'active', 'archived'))");
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('shop_categories');
    }
};
