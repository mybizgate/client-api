<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Shop customer identity (SHOP_DESIGN.md §5.6, §6.7). The confirmed screens
 * have no login, so a profile is either owned by a site user (future) or by
 * a browser holding a guest token whose SHA-256 is stored here. At least one
 * of the two identities is required (CHECK on MariaDB).
 *
 * Hand-applied copy: database/schema/00_shop_schema_2026-10-31.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('shop_customer_profiles', function (Blueprint $table) {
            $table->id()->comment('Internal shop customer profile identifier.');
            $table->unsignedBigInteger('site_id')->comment('Site and tenant in which the customer profile exists.');
            $table->unsignedBigInteger('user_id')->nullable()->comment('Authenticated customer user that owns this profile; NULL for a guest identified by guest_token_hash.');
            $table->char('guest_token_hash', 64)->nullable()->comment('SHA-256 hex of the bearer guest token issued to a browser without an account; NULL once the profile belongs to a user or the token is revoked.');
            $table->string('store_name', 200)->comment('Customer shop or company name used for wholesale orders (Customer.storeName).');
            $table->string('contact_name', 150)->comment('Primary person to contact for orders (Customer.contactName).');
            $table->string('phone', 30)->comment('Primary order contact telephone number (Customer.phone).');
            $table->text('address')->nullable()->comment('Free-text shop address as typed on the account screen (Customer.address); NULL or empty when not provided.');
            $table->timestamp('last_seen_at')->nullable()->comment('Last time the guest token or user was used on a customer endpoint; supports cleanup of abandoned guest profiles.');
            $table->timestamp('created_at')->nullable()->comment('Date and time when the profile was created.');
            $table->timestamp('updated_at')->nullable()->comment('Date and time when the profile was last updated.');

            $table->unique(['site_id', 'user_id'], 'shop_customer_profiles_site_user_unique');
            $table->unique('guest_token_hash', 'shop_customer_profiles_guest_token_unique');
            $table->unique(['site_id', 'id'], 'shop_customer_profiles_site_id_unique');
            $table->foreign('site_id', 'shop_customer_profiles_site_fk')->references('id')->on('sites')->cascadeOnDelete();
            $table->foreign(['site_id', 'user_id'], 'shop_customer_profiles_user_fk')->references(['site_id', 'id'])->on('users')->cascadeOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `shop_customer_profiles` COMMENT = \'Shop customer identity (guest token or site user) with the store details shown on the account screen.\'');
            DB::statement('ALTER TABLE `shop_customer_profiles` ADD CONSTRAINT `shop_customer_profiles_identity_check` CHECK (`user_id` IS NOT NULL OR `guest_token_hash` IS NOT NULL)');
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('shop_customer_profiles');
    }
};
