<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * One website / web application per client (database/table structure.md §3.2).
 *
 * `UNIQUE(client_id)` enforces the one-site-per-client rule. Pricing is the
 * per-client agreed price snapshot, not a package foreign key. `domain_type`
 * uses the platform's values (`subdomain` | `custom`, see `new-client.sh
 * --domain-type`). `expiry_date` is inclusive; `status` is `draft` until the
 * first payment is verified, and a site that is not `active` refuses logins.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('sites', function (Blueprint $table) {
            $table->id();
            $table->foreignId('client_id')->unique()->constrained()->restrictOnDelete();
            $table->string('site_name', 150);
            $table->string('domain', 253)->unique();       // normalised lowercase FQDN
            $table->string('domain_type', 30);             // subdomain | custom
            $table->string('site_type', 30);               // website | web_application
            $table->string('package_name', 100);           // plain-text snapshot, no package FK
            $table->decimal('first_year_price', 10, 2);
            $table->decimal('renewal_price', 10, 2);
            $table->unsignedSmallInteger('billing_months')->default(12);
            $table->date('start_date')->nullable();        // null while draft
            $table->date('expiry_date')->nullable();       // inclusive end of the last paid period
            $table->string('status', 20)->default('draft'); // draft | active | expired | suspended
            $table->text('status_reason')->nullable();     // shown to users when login is refused
            $table->text('remarks')->nullable();
            $table->timestamps();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement("ALTER TABLE `sites` ADD CONSTRAINT `sites_domain_type_check` CHECK (`domain_type` IN ('subdomain', 'custom'))");
            DB::statement("ALTER TABLE `sites` ADD CONSTRAINT `sites_site_type_check` CHECK (`site_type` IN ('website', 'web_application'))");
            DB::statement("ALTER TABLE `sites` ADD CONSTRAINT `sites_status_check` CHECK (`status` IN ('draft', 'active', 'expired', 'suspended'))");
            DB::statement('ALTER TABLE `sites` ADD CONSTRAINT `sites_billing_months_check` CHECK (`billing_months` > 0)');
            DB::statement('ALTER TABLE `sites` ADD CONSTRAINT `sites_prices_check` CHECK (`first_year_price` >= 0 AND `renewal_price` >= 0)');
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('sites');
    }
};
