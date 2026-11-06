<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Outreach prospects of a site (../marketing/app-spec/API_CONTRACT.md), used
 * by the internal `marketing` site. `phone` holds normalised digits only
 * (E.164 without "+"); the (site_id, phone) unique key rejects a second
 * prospect with the same number while MariaDB still allows any number of
 * NULL phones. `category` and `demo_slug` are validated by the application
 * only so new categories need no schema change.
 *
 * Hand-applied copy: database/schema/00_marketing_schema_2026-11-06.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('marketing_prospects', function (Blueprint $table) {
            $table->id()->comment('Internal prospect identifier; exposed to the frontend as Prospect.id.');
            $table->unsignedBigInteger('site_id')->comment('Site and tenant that owns the prospect.');
            $table->string('name', 120)->comment('Business name of the prospect.');
            $table->string('phone', 20)->nullable()->comment('Normalised phone number, digits only (E.164 without the plus sign, e.g. 60183122854); NULL when unknown.');
            $table->string('category', 30)->comment('Business category key (cat_hotel, dental, salon, auto, home_service, solar, contractor, retail, fnb, homestay, other); validated by the application.');
            $table->string('area', 120)->nullable()->comment('Town, district or area where the prospect operates.');
            $table->string('state', 60)->nullable()->comment('Malaysian state (or other region) of the prospect.');
            $table->string('channel', 200)->nullable()->comment('Where the prospect was found or its handle, free text (e.g. instagram.com/handle).');
            $table->string('website', 20)->default('unknown')->comment('Website situation: none, weak, has_site, or unknown.');
            $table->char('priority', 1)->default('B')->comment('Outreach priority from A (highest) to D (lowest).');
            $table->string('status', 20)->default('new')->comment('Pipeline status: new, contacted, replied, demo_viewed, won, lost, or do_not_contact. The first touch moves new to contacted.');
            $table->string('demo_slug', 30)->nullable()->comment('Demo to personalise for the prospect (cathotel, dental, beausalon, autocare, service, supplier); NULL when none fits.');
            $table->text('notes')->nullable()->comment('Free-text notes about the prospect.');
            $table->timestamp('last_touch_at')->nullable()->comment('Date and time of the most recent recorded touch; NULL until the first touch.');
            $table->timestamp('created_at')->nullable()->comment('Date and time when the prospect was created.');
            $table->timestamp('updated_at')->nullable()->comment('Date and time when the prospect was last updated.');

            $table->unique(['site_id', 'id'], 'marketing_prospects_site_id_unique');
            $table->unique(['site_id', 'phone'], 'marketing_prospects_site_phone_unique');
            $table->index(['site_id', 'status', 'priority'], 'marketing_prospects_pipeline_index');
            $table->foreign('site_id', 'marketing_prospects_site_fk')->references('id')->on('sites')->cascadeOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `marketing_prospects` COMMENT = \'Outreach prospects of a site (marketing pipeline); one row per business.\'');
            DB::statement("ALTER TABLE `marketing_prospects` ADD CONSTRAINT `marketing_prospects_website_check` CHECK (`website` IN ('none', 'weak', 'has_site', 'unknown'))");
            DB::statement("ALTER TABLE `marketing_prospects` ADD CONSTRAINT `marketing_prospects_priority_check` CHECK (`priority` IN ('A', 'B', 'C', 'D'))");
            DB::statement("ALTER TABLE `marketing_prospects` ADD CONSTRAINT `marketing_prospects_status_check` CHECK (`status` IN ('new', 'contacted', 'replied', 'demo_viewed', 'won', 'lost', 'do_not_contact'))");
            DB::statement("ALTER TABLE `marketing_prospects` ADD CONSTRAINT `marketing_prospects_phone_check` CHECK (`phone` IS NULL OR `phone` REGEXP '^[0-9]{8,15}$')");
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('marketing_prospects');
    }
};
