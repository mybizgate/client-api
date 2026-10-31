<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Status audit trail of an order (SHOP_DESIGN.md §5.5, §6.8): one row per
 * transition with the actor type (customer, staff, system) and the site user
 * when known. Returned ascending as Order.history[].
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shop_order_status_history', function (Blueprint $table) {
            $table->id()->comment('Internal order status history identifier.');
            $table->unsignedBigInteger('site_id')->comment('Site and tenant that owns the status event.');
            $table->unsignedBigInteger('order_id')->comment('Order whose status changed.');
            $table->string('status', 30)->comment('Order status recorded by this event (Order.history[].status).');
            $table->string('actor_type', 20)->default('system')->comment('Who caused the change: customer (guest or user), staff (owner or staff user), or system.');
            $table->unsignedBigInteger('changed_by_user_id')->nullable()->comment('Site user who caused the change when known; NULL for guest customers and automated actions.');
            $table->string('note', 500)->nullable()->comment('Optional explanation for the status change.');
            $table->timestamp('created_at')->useCurrent()->comment('Date and time when the status event occurred (Order.history[].at).');

            $table->index(['site_id', 'order_id', 'created_at'], 'shop_order_status_history_timeline_index');
            $table->foreign(['site_id', 'order_id'], 'shop_order_status_history_order_fk')->references(['site_id', 'id'])->on('shop_orders')->cascadeOnDelete();
            $table->foreign(['site_id', 'changed_by_user_id'], 'shop_order_status_history_user_fk')->references(['site_id', 'id'])->on('users')->restrictOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `shop_order_status_history` COMMENT = \'Chronological audit trail of shop order status changes.\'');
            DB::statement("ALTER TABLE `shop_order_status_history` ADD CONSTRAINT `shop_order_status_history_status_check` CHECK (`status` IN ('draft_whatsapp', 'pending_review', 'confirmed', 'processing', 'delivered', 'completed', 'cancelled'))");
            DB::statement("ALTER TABLE `shop_order_status_history` ADD CONSTRAINT `shop_order_status_history_actor_check` CHECK (`actor_type` IN ('customer', 'staff', 'system'))");
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('shop_order_status_history');
    }
};
