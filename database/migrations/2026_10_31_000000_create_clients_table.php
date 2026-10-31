<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * MyBizGate's business customers (database/table structure.md §3.1).
 *
 * `client_code` is the platform slug (`clients/client-<slug>/`) and the exact
 * value sent as `X-Client-Code` to this API and to media-api, so it is
 * lowercase and follows the same `^[a-z0-9-]{2,50}$` contract. It is also the
 * value stored in `media_attachments.tenant_id` (no foreign key on purpose).
 *
 * Production never runs `php artisan migrate`: the SQL in
 * `database/schema/00_core_schema_2026-10-31.sql` is applied by hand instead.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('clients', function (Blueprint $table) {
            $table->id();
            $table->string('client_code', 50)->unique();   // = platform slug = X-Client-Code
            $table->string('business_name', 200);
            $table->string('registration_no', 50)->nullable(); // SSM / business registration number
            $table->string('business_nature', 100);        // free-form: supplier, pet_hotel, salon, ...
            $table->string('contact_person', 150);
            $table->string('email');                       // contact email, not a login identity, not unique
            $table->string('phone_primary', 30);
            $table->string('phone_secondary', 30)->nullable();
            $table->string('address_line1');
            $table->string('address_line2')->nullable();
            $table->string('city', 100);
            $table->string('state', 100);
            $table->string('postcode', 15);
            $table->char('country', 2)->default('MY');     // ISO 3166-1 alpha-2
            $table->text('remarks')->nullable();
            $table->timestamps();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement("ALTER TABLE `clients` ADD CONSTRAINT `clients_client_code_format` CHECK (`client_code` COLLATE utf8mb4_bin REGEXP '^[a-z0-9-]{2,50}$')");
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('clients');
    }
};
