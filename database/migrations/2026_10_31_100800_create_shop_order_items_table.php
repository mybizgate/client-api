<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Immutable priced order lines (SHOP_DESIGN.md §6.8). Product, pack and price
 * values are snapshots; the product's current image and packshot are read at
 * display time through product_id.
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shop_order_items', function (Blueprint $table) {
            $table->id()->comment('Internal order line identifier.');
            $table->unsignedBigInteger('site_id')->comment('Site and tenant that owns the order line.');
            $table->unsignedBigInteger('order_id')->comment('Order header containing this line.');
            $table->unsignedInteger('line_number')->comment('Stable one-based line position within the order.');
            $table->unsignedBigInteger('product_id')->comment('Original product referenced by the order line (OrderItem.productId); its current image and packshot are read at display time.');
            $table->string('sku', 80)->nullable()->comment('Snapshot of the product SKU at order time.');
            $table->string('product_name', 200)->comment('Snapshot of the product name at order time (OrderItem.name).');
            $table->string('product_slug', 220)->comment('Snapshot of the product slug at order time (OrderItem.slug).');
            $table->string('selling_unit', 50)->comment('Snapshot of the wholesale selling unit at order time (OrderItem.unit).');
            $table->unsignedInteger('pack_quantity')->comment('Snapshot of the retail pack count per selling unit (OrderItem.packQty).');
            $table->string('pack_size', 50)->comment('Snapshot of one retail pack size (OrderItem.size).');
            $table->unsignedInteger('quantity')->comment('Whole number of wholesale selling units ordered (OrderItem.qty).');
            $table->unsignedBigInteger('base_price_minor')->comment('Catalogue price per selling unit before quantity discount, in minor units (OrderItem.basePrice).');
            $table->unsignedBigInteger('unit_price_minor')->comment('Actual price per selling unit after the applicable tier discount, in minor units (OrderItem.unitPrice).');
            $table->unsignedBigInteger('line_total_minor')->comment('Recorded line total in minor units; always quantity x unit_price_minor.');
            $table->timestamp('created_at')->nullable()->comment('Date and time when the order line was created.');
            $table->timestamp('updated_at')->nullable()->comment('Date and time when the order line was last updated.');

            $table->unique(['site_id', 'order_id', 'line_number'], 'shop_order_items_order_line_unique');
            $table->index(['site_id', 'product_id'], 'shop_order_items_product_index');
            $table->foreign(['site_id', 'order_id'], 'shop_order_items_order_fk')->references(['site_id', 'id'])->on('shop_orders')->cascadeOnDelete();
            $table->foreign(['site_id', 'product_id'], 'shop_order_items_product_fk')->references(['site_id', 'id'])->on('shop_products')->restrictOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `shop_order_items` COMMENT = \'Immutable product, pack, quantity, and pricing snapshots for shop order lines.\'');
            DB::statement('ALTER TABLE `shop_order_items` ADD CONSTRAINT `shop_order_items_line_number_check` CHECK (`line_number` > 0)');
            DB::statement('ALTER TABLE `shop_order_items` ADD CONSTRAINT `shop_order_items_pack_quantity_check` CHECK (`pack_quantity` > 0)');
            DB::statement('ALTER TABLE `shop_order_items` ADD CONSTRAINT `shop_order_items_quantity_check` CHECK (`quantity` > 0)');
            DB::statement('ALTER TABLE `shop_order_items` ADD CONSTRAINT `shop_order_items_unit_price_check` CHECK (`unit_price_minor` <= `base_price_minor`)');
            DB::statement('ALTER TABLE `shop_order_items` ADD CONSTRAINT `shop_order_items_total_check` CHECK (`line_total_minor` = (`quantity` * `unit_price_minor`))');
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('shop_order_items');
    }
};
