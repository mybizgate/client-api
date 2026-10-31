<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Append-only stock ledger (SHOP_DESIGN.md §5.7, §6.9). Every change of
 * shop_products.stock_quantity writes one row here in the same transaction;
 * sale/cancellation rows reference the order that caused them.
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shop_inventory_movements', function (Blueprint $table) {
            $table->id()->comment('Internal inventory movement identifier.');
            $table->unsignedBigInteger('site_id')->comment('Site and tenant that owns the inventory movement.');
            $table->unsignedBigInteger('product_id')->comment('Product whose stock balance changed.');
            $table->unsignedBigInteger('order_id')->nullable()->comment('Related order when the movement was caused by an order confirmation or cancellation.');
            $table->string('movement_type', 30)->comment('Reason for the movement: opening, restock, sale, adjustment, return, or cancellation.');
            $table->integer('quantity_delta')->comment('Signed whole stock change in selling units; positive adds stock and negative removes stock.');
            $table->unsignedInteger('balance_after')->comment('Product stock balance immediately after applying this movement.');
            $table->string('note', 500)->nullable()->comment('Optional explanation or external stock reference.');
            $table->unsignedBigInteger('created_by_user_id')->nullable()->comment('User who recorded the movement; NULL represents an automated system action.');
            $table->timestamp('created_at')->useCurrent()->comment('Date and time when the inventory movement was recorded.');

            $table->index(['site_id', 'product_id', 'created_at'], 'shop_inventory_movements_product_index');
            $table->index(['site_id', 'order_id'], 'shop_inventory_movements_order_index');
            $table->foreign(['site_id', 'product_id'], 'shop_inventory_movements_product_fk')->references(['site_id', 'id'])->on('shop_products')->restrictOnDelete();
            $table->foreign(['site_id', 'order_id'], 'shop_inventory_movements_order_fk')->references(['site_id', 'id'])->on('shop_orders')->restrictOnDelete();
            $table->foreign(['site_id', 'created_by_user_id'], 'shop_inventory_movements_user_fk')->references(['site_id', 'id'])->on('users')->restrictOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `shop_inventory_movements` COMMENT = \'Append-only audit ledger for product stock changes in the shop domain.\'');
            DB::statement("ALTER TABLE `shop_inventory_movements` ADD CONSTRAINT `shop_inventory_movements_type_check` CHECK (`movement_type` IN ('opening', 'restock', 'sale', 'adjustment', 'return', 'cancellation'))");
            DB::statement('ALTER TABLE `shop_inventory_movements` ADD CONSTRAINT `shop_inventory_movements_delta_check` CHECK (`quantity_delta` <> 0)');
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('shop_inventory_movements');
    }
};
