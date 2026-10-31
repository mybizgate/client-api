<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Payment choices offered at checkout (SHOP_DESIGN.md §6.6). The frontend
 * submits the `label` string, so labels are unique per site and an active
 * method must never be renamed (deactivate and create instead).
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shop_payment_methods', function (Blueprint $table) {
            $table->id()->comment('Internal checkout payment method identifier.');
            $table->unsignedBigInteger('site_id')->comment('Site and tenant that offers the payment method.');
            $table->string('code', 50)->comment('Stable machine-readable payment method code, for example cod or bank_transfer.');
            $table->string('label', 150)->comment('Customer-facing label; this exact string is what checkout sends as paymentMethod, so it must be unique within the site.');
            $table->text('instructions')->nullable()->comment('Optional instructions displayed after the customer selects this method.');
            $table->unsignedInteger('sort_order')->default(0)->comment('Ascending display position at checkout.');
            $table->boolean('is_active')->default(true)->comment('Whether customers may currently select this payment method.');
            $table->timestamp('created_at')->nullable()->comment('Date and time when the payment method was created.');
            $table->timestamp('updated_at')->nullable()->comment('Date and time when the payment method was last updated.');

            $table->unique(['site_id', 'code'], 'shop_payment_methods_site_code_unique');
            $table->unique(['site_id', 'label'], 'shop_payment_methods_site_label_unique');
            $table->index(['site_id', 'is_active', 'sort_order'], 'shop_payment_methods_display_index');
            $table->foreign('site_id', 'shop_payment_methods_site_fk')->references('id')->on('sites')->cascadeOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `shop_payment_methods` COMMENT = \'Payment choices offered by a site during shop checkout.\'');
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('shop_payment_methods');
    }
};
