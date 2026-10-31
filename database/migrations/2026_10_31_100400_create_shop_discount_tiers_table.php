<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Site-wide quantity discount tiers (SHOP_DESIGN.md §6.5): the highest tier
 * whose minimum_quantity a line reaches applies to that line. Rates are basis
 * points (200 = 2 %) so the pricing engine never stores floats.
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shop_discount_tiers', function (Blueprint $table) {
            $table->id()->comment('Internal quantity discount tier identifier.');
            $table->unsignedBigInteger('site_id')->comment('Site and tenant that owns the discount tier.');
            $table->unsignedInteger('minimum_quantity')->comment('Minimum whole quantity of one order line needed to qualify for this tier (QuantityDiscount.minQty).');
            $table->unsignedInteger('discount_basis_points')->comment('Discount rate in basis points, where 200 means 2 percent (QuantityDiscount.rate x 10000).');
            $table->boolean('is_active')->default(true)->comment('Whether the pricing engine may apply this tier.');
            $table->timestamp('created_at')->nullable()->comment('Date and time when the discount tier was created.');
            $table->timestamp('updated_at')->nullable()->comment('Date and time when the discount tier was last updated.');

            $table->unique(['site_id', 'minimum_quantity'], 'shop_discount_tiers_site_quantity_unique');
            $table->index(['site_id', 'is_active', 'minimum_quantity'], 'shop_discount_tiers_active_index');
            $table->foreign('site_id', 'shop_discount_tiers_site_fk')->references('id')->on('sites')->cascadeOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `shop_discount_tiers` COMMENT = \'Site-wide per-line quantity thresholds and percentage discounts used during shop pricing.\'');
            DB::statement('ALTER TABLE `shop_discount_tiers` ADD CONSTRAINT `shop_discount_tiers_quantity_check` CHECK (`minimum_quantity` > 1)');
            DB::statement('ALTER TABLE `shop_discount_tiers` ADD CONSTRAINT `shop_discount_tiers_rate_check` CHECK (`discount_basis_points` > 0 AND `discount_basis_points` <= 10000)');
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('shop_discount_tiers');
    }
};
