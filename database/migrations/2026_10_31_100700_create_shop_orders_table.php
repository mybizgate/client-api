<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Order headers (SHOP_DESIGN.md §5.5, §6.8): customer snapshot, workflow
 * status and money totals in minor units. `reference_no` is what the frontend
 * shows and routes on as Order.id. Amounts are estimates confirmed by the
 * supplier over WhatsApp.
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shop_orders', function (Blueprint $table) {
            $table->id()->comment('Internal order identifier; not exposed to the frontend.');
            $table->unsignedBigInteger('site_id')->comment('Site and tenant that received the order.');
            $table->string('reference_no', 50)->comment('Human-readable order reference unique within the site; exposed as Order.id, used in the /orders/{id} route and the WhatsApp message.');
            $table->unsignedBigInteger('customer_profile_id')->comment('Customer profile (guest or user) that placed the order and may view or cancel it.');
            $table->string('status', 30)->default('draft_whatsapp')->comment('Current order workflow status; one of the frontend OrderStatus values.');
            $table->string('source', 20)->default('web')->comment('Channel that created the order: web, whatsapp, or backoffice.');
            $table->string('store_name', 200)->comment('Snapshot of the customer store or company name at order time.');
            $table->string('contact_name', 150)->comment('Snapshot of the customer contact name at order time.');
            $table->string('contact_phone', 30)->comment('Snapshot of the customer telephone number at order time.');
            $table->string('fulfilment_method', 20)->comment('Requested fulfilment method: delivery or pickup (Order.fulfilment).');
            $table->text('delivery_address')->nullable()->comment('Free-text delivery address snapshot (Order.customer.address); NULL is allowed for pickup.');
            $table->date('requested_date')->comment('Customer-requested delivery or pickup date, at least tomorrow at submission, subject to confirmation.');
            $table->string('payment_method_code', 50)->comment('Snapshot of the selected payment method code, resolved from the submitted label.');
            $table->string('payment_method_label', 150)->comment('Snapshot of the selected payment method label as submitted (Order.paymentMethod).');
            $table->char('currency', 3)->default('MYR')->comment('ISO 4217 currency code used for all stored order amounts.');
            $table->unsignedBigInteger('subtotal_minor')->comment('Sum of discounted order line totals before delivery in currency minor units (Order.subtotal).');
            $table->unsignedBigInteger('discount_minor')->default(0)->comment('Quantity-discount savings already reflected in subtotal_minor, stored for reporting only.');
            $table->unsignedBigInteger('delivery_fee_minor')->default(0)->comment('Estimated delivery charge in currency minor units (Order.deliveryFee).');
            $table->unsignedBigInteger('total_minor')->comment('Recorded estimated total in currency minor units (Order.total); final price is confirmed by the supplier.');
            $table->string('notes', 500)->nullable()->comment('Optional customer notes submitted with the order; returned as an empty string when NULL.');
            $table->timestamp('whatsapp_sent_at')->nullable()->comment('Time the customer marked the WhatsApp message as sent; this is not WhatsApp delivery verification.');
            $table->timestamp('confirmed_at')->nullable()->comment('Time an owner or staff user confirmed the order.');
            $table->timestamp('completed_at')->nullable()->comment('Time the order reached the completed state.');
            $table->timestamp('cancelled_at')->nullable()->comment('Time the order was cancelled by the customer or the supplier.');
            $table->timestamp('created_at')->nullable()->comment('Date and time when the order was created (Order.createdAt).');
            $table->timestamp('updated_at')->nullable()->comment('Date and time when the order was last updated.');

            $table->unique(['site_id', 'reference_no'], 'shop_orders_site_reference_unique');
            $table->unique(['site_id', 'id'], 'shop_orders_site_id_unique');
            $table->index(['site_id', 'customer_profile_id', 'created_at'], 'shop_orders_customer_index');
            $table->index(['site_id', 'status', 'created_at'], 'shop_orders_management_index');
            $table->foreign('site_id', 'shop_orders_site_fk')->references('id')->on('sites')->restrictOnDelete();
            $table->foreign(['site_id', 'customer_profile_id'], 'shop_orders_customer_fk')->references(['site_id', 'id'])->on('shop_customer_profiles')->restrictOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `shop_orders` COMMENT = \'Shop order headers containing customer snapshots, workflow status, and monetary totals.\'');
            DB::statement("ALTER TABLE `shop_orders` ADD CONSTRAINT `shop_orders_status_check` CHECK (`status` IN ('draft_whatsapp', 'pending_review', 'confirmed', 'processing', 'delivered', 'completed', 'cancelled'))");
            DB::statement("ALTER TABLE `shop_orders` ADD CONSTRAINT `shop_orders_source_check` CHECK (`source` IN ('web', 'whatsapp', 'backoffice'))");
            DB::statement("ALTER TABLE `shop_orders` ADD CONSTRAINT `shop_orders_fulfilment_check` CHECK (`fulfilment_method` IN ('delivery', 'pickup'))");
            DB::statement("ALTER TABLE `shop_orders` ADD CONSTRAINT `shop_orders_address_check` CHECK (`fulfilment_method` = 'pickup' OR `delivery_address` IS NOT NULL)");
            DB::statement('ALTER TABLE `shop_orders` ADD CONSTRAINT `shop_orders_amount_check` CHECK (`total_minor` = (`subtotal_minor` + `delivery_fee_minor`))');
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('shop_orders');
    }
};
