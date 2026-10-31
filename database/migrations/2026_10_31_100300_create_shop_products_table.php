<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Products of a site (SHOP_DESIGN.md §6.4): catalogue details, wholesale pack
 * information, prices in minor units, ranking, publishing flags and the stock
 * balance with its per-product `unlimited_stock` switch. Images live in
 * `media_attachments` (entity_type product), never here.
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shop_products', function (Blueprint $table) {
            $table->id()->comment('Internal product identifier; exposed to the frontend as Product.id (string) and used as the media_attachments entity_id.');
            $table->unsignedBigInteger('site_id')->comment('Site and tenant that owns the product.');
            $table->unsignedBigInteger('category_id')->comment('Category containing the product (Product.categoryId).');
            $table->string('sku', 80)->nullable()->comment('Optional stock keeping unit unique within the site; shown on the product screen and searchable.');
            $table->string('name', 200)->comment('Customer-facing product name.');
            $table->string('slug', 220)->comment('URL-safe product identifier unique within the site; used by the /product/{slug} route.');
            $table->string('short_description', 500)->nullable()->comment('Short summary for catalogue cards or search results; not displayed by the current screens.');
            $table->longText('description')->nullable()->comment('Full product description shown on the product detail screen.');
            $table->string('brand', 150)->nullable()->comment('Product manufacturer or brand name; shown and searchable.');
            $table->string('selling_unit', 50)->comment('Wholesale selling unit such as karton or guni (Product.unit).');
            $table->unsignedInteger('pack_quantity')->default(1)->comment('Number of retail packs contained in one selling unit (Product.packQty).');
            $table->string('pack_size', 50)->comment('Display size of one retail pack, for example 1kg or 650ml (Product.size).');
            $table->unsignedBigInteger('selling_price_minor')->comment('Current price for one selling unit in currency minor units (Product.price).');
            $table->unsignedBigInteger('compare_at_price_minor')->nullable()->comment('Previous price in minor units used to display a promotion (Product.oldPrice); NULL means no promotion.');
            $table->unsignedInteger('minimum_order_quantity')->default(1)->comment('Smallest whole number of selling units allowed per order line (Product.minimumQuantity).');
            $table->unsignedInteger('stock_quantity')->default(0)->comment('Current available stock in whole selling units (Product.stock); ignored when unlimited_stock is 1.');
            $table->boolean('unlimited_stock')->default(false)->comment('Per-product switch: 1 means the product can always be ordered in any quantity, the API returns stock null and no inventory movements are recorded.');
            $table->unsignedInteger('low_stock_threshold')->default(10)->comment('Stock level below which the API reports stockStatus low.');
            $table->unsignedInteger('sort_order')->default(0)->comment('Ascending catalogue position used by the default "popular" sort.');
            $table->boolean('is_featured')->default(false)->comment('Whether the product appears in the home hero artwork and featured sections (Product.featured).');
            $table->string('status', 20)->default('draft')->comment('Publication state: draft, active, or archived. Only active products are returned to customers.');
            $table->json('placeholder_art_json')->nullable()->comment('Optional packshot configuration {shape,color,motif,label} (Product.art) used only when no product image is attached.');
            $table->timestamp('published_at')->nullable()->comment('Date and time when the product was first made publicly available.');
            $table->unsignedBigInteger('created_by_user_id')->nullable()->comment('Owner or staff user who created the product.');
            $table->unsignedBigInteger('updated_by_user_id')->nullable()->comment('Owner or staff user who most recently updated the product.');
            $table->timestamp('created_at')->nullable()->comment('Date and time when the product was created.');
            $table->timestamp('updated_at')->nullable()->comment('Date and time when the product was last updated (Product.updatedAt).');
            $table->timestamp('deleted_at')->nullable()->comment('Soft-deletion time; NULL means the product has not been deleted. Order lines keep pointing at deleted products.');

            $table->unique(['site_id', 'slug'], 'shop_products_site_slug_unique');
            $table->unique(['site_id', 'sku'], 'shop_products_site_sku_unique');
            $table->unique(['site_id', 'id'], 'shop_products_site_id_unique');
            $table->index(['site_id', 'status', 'category_id', 'sort_order'], 'shop_products_catalogue_index');
            $table->index(['site_id', 'status', 'selling_price_minor'], 'shop_products_price_index');
            $table->foreign('site_id', 'shop_products_site_fk')->references('id')->on('sites')->cascadeOnDelete();
            $table->foreign(['site_id', 'category_id'], 'shop_products_category_fk')->references(['site_id', 'id'])->on('shop_categories')->restrictOnDelete();
            $table->foreign(['site_id', 'created_by_user_id'], 'shop_products_created_by_fk')->references(['site_id', 'id'])->on('users')->restrictOnDelete();
            $table->foreign(['site_id', 'updated_by_user_id'], 'shop_products_updated_by_fk')->references(['site_id', 'id'])->on('users')->restrictOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `shop_products` COMMENT = \'Products and current catalogue, pricing, pack, ranking, and stock information for a site.\'');
            DB::statement("ALTER TABLE `shop_products` ADD CONSTRAINT `shop_products_status_check` CHECK (`status` IN ('draft', 'active', 'archived'))");
            DB::statement('ALTER TABLE `shop_products` ADD CONSTRAINT `shop_products_pack_quantity_check` CHECK (`pack_quantity` > 0)');
            DB::statement('ALTER TABLE `shop_products` ADD CONSTRAINT `shop_products_price_check` CHECK (`selling_price_minor` >= 0)');
            DB::statement('ALTER TABLE `shop_products` ADD CONSTRAINT `shop_products_compare_price_check` CHECK (`compare_at_price_minor` IS NULL OR `compare_at_price_minor` > `selling_price_minor`)');
            DB::statement('ALTER TABLE `shop_products` ADD CONSTRAINT `shop_products_minimum_quantity_check` CHECK (`minimum_order_quantity` > 0)');
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('shop_products');
    }
};
