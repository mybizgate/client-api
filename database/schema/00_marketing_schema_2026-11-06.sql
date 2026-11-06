-- ---------------------------------------------------------------------------
-- MyBizGate Client API — marketing schema (outreach prospects and the touches
-- sent to them) for the internal marketing site (marketing.mybizgate.com).
--
-- Task      : marketing_schema       Date: 2026-11-06
-- Contract  : ../../marketing/app-spec/API_CONTRACT.md
-- Migrations: database/migrations/2026_11_06_000000 … 000100 (names listed at
--             the end of this file; the Laravel migrations must use exactly
--             these names so `php artisan migrate` never re-runs them)
--
-- HOW TO APPLY (production, cPanel → phpMyAdmin → database → SQL tab):
--   1. Back up the database (Export) first.
--   2. Paste this whole file and press Go. Run it exactly once.
--   3. Then, for the marketing site itself:
--      01_marketing_client_2026-11-06.sql   (clients + sites rows, owner login)
--      02_marketing_prospects_2026-11-06.sql (cat-hotel prospects; idempotent)
--   4. `curl .../api/v1/health` must still report "database": true.
--
-- Prerequisite: 00_main_structure.sql (clients, sites, users, migrations
-- exist). No data is touched. Proven identical to the migrations on
-- mybizgat_clientapi with the CLAUDE.md "Database change procedure".
-- ---------------------------------------------------------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------------
-- 1. marketing_prospects — one row per business in the outreach pipeline
-- ---------------------------------------------------------------------------
CREATE TABLE `marketing_prospects` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal prospect identifier; exposed to the frontend as Prospect.id.',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that owns the prospect.',
  `name` varchar(120) NOT NULL COMMENT 'Business name of the prospect.',
  `phone` varchar(20) DEFAULT NULL COMMENT 'Normalised phone number, digits only (E.164 without the plus sign, e.g. 60183122854); NULL when unknown.',
  `category` varchar(30) NOT NULL COMMENT 'Business category key (cat_hotel, dental, salon, auto, home_service, solar, contractor, retail, fnb, homestay, other); validated by the application.',
  `area` varchar(120) DEFAULT NULL COMMENT 'Town, district or area where the prospect operates.',
  `state` varchar(60) DEFAULT NULL COMMENT 'Malaysian state (or other region) of the prospect.',
  `channel` varchar(200) DEFAULT NULL COMMENT 'Where the prospect was found or its handle, free text (e.g. instagram.com/handle).',
  `website` varchar(20) NOT NULL DEFAULT 'unknown' COMMENT 'Website situation: none, weak, has_site, or unknown.',
  `priority` char(1) NOT NULL DEFAULT 'B' COMMENT 'Outreach priority from A (highest) to D (lowest).',
  `status` varchar(20) NOT NULL DEFAULT 'new' COMMENT 'Pipeline status: new, contacted, replied, demo_viewed, won, lost, or do_not_contact. The first touch moves new to contacted.',
  `demo_slug` varchar(30) DEFAULT NULL COMMENT 'Demo to personalise for the prospect (cathotel, dental, beausalon, autocare, service, supplier); NULL when none fits.',
  `notes` text DEFAULT NULL COMMENT 'Free-text notes about the prospect.',
  `last_touch_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time of the most recent recorded touch; NULL until the first touch.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the prospect was created.',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the prospect was last updated.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `marketing_prospects_site_id_unique` (`site_id`, `id`),
  UNIQUE KEY `marketing_prospects_site_phone_unique` (`site_id`, `phone`),
  KEY `marketing_prospects_pipeline_index` (`site_id`, `status`, `priority`),
  CONSTRAINT `marketing_prospects_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `marketing_prospects_website_check` CHECK (`website` IN ('none', 'weak', 'has_site', 'unknown')),
  CONSTRAINT `marketing_prospects_priority_check` CHECK (`priority` IN ('A', 'B', 'C', 'D')),
  CONSTRAINT `marketing_prospects_status_check` CHECK (`status` IN ('new', 'contacted', 'replied', 'demo_viewed', 'won', 'lost', 'do_not_contact')),
  CONSTRAINT `marketing_prospects_phone_check` CHECK (`phone` IS NULL OR `phone` REGEXP '^[0-9]{8,15}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Outreach prospects of a site (marketing pipeline); one row per business.';

-- ---------------------------------------------------------------------------
-- 2. marketing_touches — append-only log of messages sent to a prospect
-- ---------------------------------------------------------------------------
CREATE TABLE `marketing_touches` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal touch identifier.',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that owns the touch.',
  `prospect_id` bigint(20) unsigned NOT NULL COMMENT 'Prospect that was contacted.',
  `channel` varchar(20) NOT NULL DEFAULT 'whatsapp' COMMENT 'Channel used to send the message (whatsapp, call, email, instagram, facebook, other); validated by the application.',
  `template` varchar(20) NOT NULL COMMENT 'Message template sent: first_ms, first_en, followup, price, or other.',
  `note` text DEFAULT NULL COMMENT 'Optional note about this touch.',
  `sent_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Date and time when the user confirmed the message was sent.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the touch was recorded.',
  PRIMARY KEY (`id`),
  KEY `marketing_touches_site_sent_index` (`site_id`, `sent_at`),
  KEY `marketing_touches_timeline_index` (`site_id`, `prospect_id`, `sent_at`),
  CONSTRAINT `marketing_touches_prospect_fk` FOREIGN KEY (`site_id`, `prospect_id`) REFERENCES `marketing_prospects` (`site_id`, `id`) ON DELETE CASCADE,
  CONSTRAINT `marketing_touches_template_check` CHECK (`template` IN ('first_ms', 'first_en', 'followup', 'price', 'other'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Append-only log of outreach messages sent to marketing prospects.';

-- ---------------------------------------------------------------------------
-- 3. Record the migrations so `php artisan migrate` never re-runs them
-- ---------------------------------------------------------------------------
SET @batch := (SELECT COALESCE(MAX(`batch`), 0) + 1 FROM `migrations`);
INSERT INTO `migrations` (`migration`, `batch`) VALUES
  ('2026_11_06_000000_create_marketing_prospects_table', @batch),
  ('2026_11_06_000100_create_marketing_touches_table', @batch);
