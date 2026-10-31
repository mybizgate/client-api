<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Site-level commercial settings of the shop (SHOP_DESIGN.md §6.2): minimum
 * order, delivery fee, free-delivery threshold, order reference sequence and
 * the owner's stock switch. One row per site, keyed by site_id.
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shop_settings', function (Blueprint $table) {
            $table->unsignedBigInteger('site_id')->comment('Site and tenant that owns these shop settings.');
            $table->char('currency', 3)->default('MYR')->comment('ISO 4217 currency code used by the shop.');
            $table->unsignedBigInteger('minimum_order_minor')->default(0)->comment('Minimum discounted subtotal in currency minor units, such as sen, before an order is accepted.');
            $table->unsignedBigInteger('delivery_fee_minor')->default(0)->comment('Default delivery fee in currency minor units.');
            $table->unsignedBigInteger('free_delivery_from_minor')->nullable()->comment('Subtotal in minor units from which delivery becomes free; NULL disables the rule.');
            $table->boolean('allow_whatsapp_order')->default(true)->comment('Whether checkout may open a prepared WhatsApp order message.');
            $table->boolean('deduct_stock_on_confirm')->default(false)->comment('Owner switch: 1 deducts tracked product stock when an order is confirmed and restores it on cancellation; 0 leaves stock untouched by orders.');
            $table->string('reference_prefix', 12)->comment('Short prefix used when generating human-readable order references, for example LZ.');
            $table->unsignedBigInteger('next_order_number')->default(1)->comment('Next sequence number reserved transactionally for an order reference.');
            $table->timestamp('created_at')->nullable()->comment('Date and time when the settings row was created.');
            $table->timestamp('updated_at')->nullable()->comment('Date and time when the settings row was last updated.');

            $table->primary('site_id');
            $table->foreign('site_id', 'shop_settings_site_fk')->references('id')->on('sites')->cascadeOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `shop_settings` COMMENT = \'Site-level commercial and checkout settings for the shop domain.\'');
            DB::statement('ALTER TABLE `shop_settings` ADD CONSTRAINT `shop_settings_minimum_check` CHECK (`minimum_order_minor` >= 0)');
            DB::statement('ALTER TABLE `shop_settings` ADD CONSTRAINT `shop_settings_delivery_check` CHECK (`delivery_fee_minor` >= 0)');
            DB::statement('ALTER TABLE `shop_settings` ADD CONSTRAINT `shop_settings_free_delivery_check` CHECK (`free_delivery_from_minor` IS NULL OR `free_delivery_from_minor` >= 0)');
            DB::statement('ALTER TABLE `shop_settings` ADD CONSTRAINT `shop_settings_next_order_check` CHECK (`next_order_number` > 0)');
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('shop_settings');
    }
};
