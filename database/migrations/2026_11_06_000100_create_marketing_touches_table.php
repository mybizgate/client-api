<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Append-only log of outreach messages sent to a prospect
 * (../marketing/app-spec/API_CONTRACT.md, POST /marketing/prospects/{id}/touches).
 * Recording a touch sets marketing_prospects.last_touch_at and moves a `new`
 * prospect to `contacted`. A prospect with touches cannot be deleted by the
 * API (409); the cascade only applies when the site itself is removed.
 *
 * Hand-applied copy: database/schema/00_marketing_schema_2026-11-06.sql.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('marketing_touches', function (Blueprint $table) {
            $table->id()->comment('Internal touch identifier.');
            $table->unsignedBigInteger('site_id')->comment('Site and tenant that owns the touch.');
            $table->unsignedBigInteger('prospect_id')->comment('Prospect that was contacted.');
            $table->string('channel', 20)->default('whatsapp')->comment('Channel used to send the message (whatsapp, call, email, instagram, facebook, other); validated by the application.');
            $table->string('template', 20)->comment('Message template sent: first_ms, first_en, followup, price, or other.');
            $table->text('note')->nullable()->comment('Optional note about this touch.');
            $table->timestamp('sent_at')->useCurrent()->comment('Date and time when the user confirmed the message was sent.');
            $table->timestamp('created_at')->nullable()->comment('Date and time when the touch was recorded.');

            $table->index(['site_id', 'sent_at'], 'marketing_touches_site_sent_index');
            $table->index(['site_id', 'prospect_id', 'sent_at'], 'marketing_touches_timeline_index');
            $table->foreign(['site_id', 'prospect_id'], 'marketing_touches_prospect_fk')->references(['site_id', 'id'])->on('marketing_prospects')->cascadeOnDelete();
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement('ALTER TABLE `marketing_touches` COMMENT = \'Append-only log of outreach messages sent to marketing prospects.\'');
            DB::statement("ALTER TABLE `marketing_touches` ADD CONSTRAINT `marketing_touches_template_check` CHECK (`template` IN ('first_ms', 'first_en', 'followup', 'price', 'other'))");
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('marketing_touches');
    }
};
