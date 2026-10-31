-- ---------------------------------------------------------------------------
-- MyBizGate Client API — core tenant schema (clients, sites, users, password
-- reset tokens, payments) + Sanctum API tokens.
--
-- Task      : core_schema            Date: 2026-10-31
-- Design    : database/table structure.md
-- Migrations: database/migrations/2026_10_31_000000 … 000400 and
--             2026_10_31_022105_create_personal_access_tokens_table
--
-- HOW TO APPLY (production, cPanel → phpMyAdmin → database → SQL tab):
--   1. Back up the database (Export) first.
--   2. Paste this whole file and press Go. Run it exactly once.
--   3. `users` must be EMPTY before step 2 (it is on a fresh install): the new
--      NOT NULL `site_id` column cannot be filled for existing rows.
--   4. Afterwards `database/schema/00_main_structure.sql` describes the
--      resulting structure; do NOT run that file on a live database.
--
-- Prerequisite: the tables from the previous 00_main_structure.sql /
-- mysql-schema.sql (users, password_reset_tokens, migrations, ...) exist.
-- ---------------------------------------------------------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------------
-- 1. clients — MyBizGate's business customers
--    client_code = platform slug = X-Client-Code (lowercase, ^[a-z0-9-]{2,50}$)
-- ---------------------------------------------------------------------------
CREATE TABLE `clients` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_code` varchar(50) NOT NULL,
  `business_name` varchar(200) NOT NULL,
  `registration_no` varchar(50) DEFAULT NULL,
  `business_nature` varchar(100) NOT NULL,
  `contact_person` varchar(150) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone_primary` varchar(30) NOT NULL,
  `phone_secondary` varchar(30) DEFAULT NULL,
  `address_line1` varchar(255) NOT NULL,
  `address_line2` varchar(255) DEFAULT NULL,
  `city` varchar(100) NOT NULL,
  `state` varchar(100) NOT NULL,
  `postcode` varchar(15) NOT NULL,
  `country` char(2) NOT NULL DEFAULT 'MY',
  `remarks` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `clients_client_code_unique` (`client_code`),
  CONSTRAINT `clients_client_code_format` CHECK (`client_code` COLLATE utf8mb4_bin REGEXP '^[a-z0-9-]{2,50}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 2. sites — exactly one website / web application per client
--    domain_type: subdomain | custom      site_type: website | web_application
--    status: draft | active | expired | suspended (non-active sites refuse login
--    and return status_reason)            expiry_date is inclusive
-- ---------------------------------------------------------------------------
CREATE TABLE `sites` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` bigint(20) unsigned NOT NULL,
  `site_name` varchar(150) NOT NULL,
  `domain` varchar(253) NOT NULL,
  `domain_type` varchar(30) NOT NULL,
  `site_type` varchar(30) NOT NULL,
  `package_name` varchar(100) NOT NULL,
  `first_year_price` decimal(10,2) NOT NULL,
  `renewal_price` decimal(10,2) NOT NULL,
  `billing_months` smallint(5) unsigned NOT NULL DEFAULT 12,
  `start_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'draft',
  `status_reason` text DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sites_client_id_unique` (`client_id`),
  UNIQUE KEY `sites_domain_unique` (`domain`),
  CONSTRAINT `sites_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `sites_domain_type_check` CHECK (`domain_type` IN ('subdomain','custom')),
  CONSTRAINT `sites_site_type_check` CHECK (`site_type` IN ('website','web_application')),
  CONSTRAINT `sites_status_check` CHECK (`status` IN ('draft','active','expired','suspended')),
  CONSTRAINT `sites_billing_months_check` CHECK (`billing_months` > 0),
  CONSTRAINT `sites_prices_check` CHECK (`first_year_price` >= 0 AND `renewal_price` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 3. users — make the stock table tenant-local
--    email unique per site only; role: owner | staff | customer;
--    status: active | disabled
-- ---------------------------------------------------------------------------
ALTER TABLE `users`
  DROP INDEX `users_email_unique`,
  ADD COLUMN `site_id` bigint(20) unsigned NOT NULL AFTER `id`,
  ADD COLUMN `phone` varchar(30) DEFAULT NULL AFTER `email`,
  ADD COLUMN `role` varchar(20) NOT NULL DEFAULT 'customer' AFTER `password`,
  ADD COLUMN `status` varchar(20) NOT NULL DEFAULT 'active' AFTER `role`,
  ADD COLUMN `last_login_at` timestamp NULL DEFAULT NULL AFTER `email_verified_at`,
  ADD UNIQUE KEY `users_site_id_email_unique` (`site_id`,`email`),
  ADD KEY `users_site_id_role_index` (`site_id`,`role`),
  ADD CONSTRAINT `users_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE RESTRICT,
  ADD CONSTRAINT `users_role_check` CHECK (`role` IN ('owner','staff','customer')),
  ADD CONSTRAINT `users_status_check` CHECK (`status` IN ('active','disabled'));

-- ---------------------------------------------------------------------------
-- 4. password_reset_tokens — one hashed, expiring token per user (not per
--    email: emails repeat across sites). Replaces the stock email-keyed table.
-- ---------------------------------------------------------------------------
DROP TABLE IF EXISTS `password_reset_tokens`;
CREATE TABLE `password_reset_tokens` (
  `user_id` bigint(20) unsigned NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `password_reset_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 5. payments — registration / renewal ledger (history is never rewritten)
--    payment_type: registration | renewal   status: pending | paid | rejected
--    payment_method: bank_transfer | cash | other   period_end is inclusive
-- ---------------------------------------------------------------------------
CREATE TABLE `payments` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint(20) unsigned NOT NULL,
  `payment_type` varchar(20) NOT NULL,
  `amount` decimal(10,2) NOT NULL,
  `currency` char(3) NOT NULL DEFAULT 'MYR',
  `payment_method` varchar(30) DEFAULT NULL,
  `reference_no` varchar(100) DEFAULT NULL,
  `status` varchar(20) NOT NULL DEFAULT 'pending',
  `period_start` date NOT NULL,
  `period_end` date NOT NULL,
  `paid_at` timestamp NULL DEFAULT NULL,
  `verified_at` timestamp NULL DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `payments_site_id_status_period_end_index` (`site_id`,`status`,`period_end`),
  CONSTRAINT `payments_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `payments_payment_type_check` CHECK (`payment_type` IN ('registration','renewal')),
  CONSTRAINT `payments_status_check` CHECK (`status` IN ('pending','paid','rejected')),
  CONSTRAINT `payments_amount_check` CHECK (`amount` >= 0),
  CONSTRAINT `payments_period_check` CHECK (`period_end` >= `period_start`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 6. personal_access_tokens — Laravel Sanctum bearer tokens for the Vue sites
--    (infrastructure table, shape of Sanctum 4.3's migration)
-- ---------------------------------------------------------------------------
CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) unsigned NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  KEY `personal_access_tokens_expires_at_index` (`expires_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ---------------------------------------------------------------------------
-- 7. Record the migrations so `php artisan migrate` never re-runs them
-- ---------------------------------------------------------------------------
SET @batch := (SELECT COALESCE(MAX(`batch`), 0) + 1 FROM `migrations`);
INSERT INTO `migrations` (`migration`, `batch`) VALUES
  ('2026_10_31_000000_create_clients_table', @batch),
  ('2026_10_31_000100_create_sites_table', @batch),
  ('2026_10_31_000200_add_site_scope_to_users_table', @batch),
  ('2026_10_31_000300_recreate_password_reset_tokens_table', @batch),
  ('2026_10_31_000400_create_payments_table', @batch),
  ('2026_10_31_022105_create_personal_access_tokens_table', @batch);
