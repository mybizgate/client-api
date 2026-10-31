<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Customer favourites (SHOP_DESIGN.md §6.11). Deferred feature: the screens
 * keep favourites in the browser for now; the table exists so no second
 * schema change is needed when favourites are synced to the server.
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shop_favourites', function (Blueprint $table) {
            $table->unsignedBigInteger('site_id')->comment('Site and tenant in which the favourite exists.');
            $table->unsignedBigInteger('customer_profile_id')->comment('Customer profile that saved the product.');
            $table->unsignedBigInteger('product_id')->comment('Product saved by the customer.');
            $table->timestamp('created_at')->nullable()->comment('Date and time when the product was saved.');

            $table->primary(['site_id', 'customer_profile_id', 'product_id']);
            $table->index(['site_id', 'product_id'], 'shop_favourites_product_index');
            $table->foreign(['site_id', 'customer_profile_id'], 'shop_favourites_profile_fk')->references(['site_id', 'id'])->on('shop_customer_profiles')->cascadeOnDelete();
            $table->foreign(['site_id', 'product_id'], 'shop_favourites_product_fk')->references(['site_id', 'id'])->on('shop_products')->cascadeOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `shop_favourites` COMMENT = \'Products saved as favourites by shop customers; deferred until favourites are synced to the server.\'');
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('shop_favourites');
    }
};
