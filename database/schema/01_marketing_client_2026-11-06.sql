-- ---------------------------------------------------------------------------
-- MyBizGate Client API — data for the internal marketing site
-- (marketing.mybizgate.com): its clients row, sites row and owner login.
--
-- Task      : marketing_client       Date: 2026-11-06
-- Contract  : ../../marketing/app-spec/API_CONTRACT.md
--
-- HOW TO APPLY (production, cPanel → phpMyAdmin → database → SQL tab):
--   1. Back up the database (Export) first.
--   2. Apply 00_marketing_schema_2026-11-06.sql first (only once).
--   3. Paste this whole file and press Go. It is idempotent: re-running it
--      updates the same rows (and resets the owner password to this hash).
--   4. Then 02_marketing_prospects_2026-11-06.sql for the prospects.
--   5. POST /api/v1/auth/login with X-Client-Code: marketing must answer 200.
--
-- Section 3 was printed by `php artisan shop:user marketing --role=owner
-- --email=mybizgateway@gmail.com --name="MyBizGate" --sql`: it carries only
-- the bcrypt hash, never the password. Change the password after the first
-- login (forgot-password flow) and regenerate this section if it must change.
-- ---------------------------------------------------------------------------

SET NAMES utf8mb4;

-- ---------------------------------------------------------------------------
-- 1. clients — the internal MyBizGate Marketing client (client_code marketing)
-- ---------------------------------------------------------------------------
INSERT INTO `clients` (`client_code`, `business_name`, `business_nature`, `contact_person`, `email`, `phone_primary`, `address_line1`, `city`, `state`, `postcode`, `country`, `created_at`, `updated_at`)
VALUES ('marketing', 'MyBizGate Marketing', 'marketing', 'MyBizGate', 'mybizgateway@gmail.com', '601158121239', '2A Lorong Delapan, Kampung Pandan', 'Kuala Lumpur', 'Kuala Lumpur', '55100', 'MY', UTC_TIMESTAMP(), UTC_TIMESTAMP())
ON DUPLICATE KEY UPDATE `business_name` = VALUES(`business_name`), `business_nature` = VALUES(`business_nature`), `contact_person` = VALUES(`contact_person`), `email` = VALUES(`email`), `phone_primary` = VALUES(`phone_primary`), `address_line1` = VALUES(`address_line1`), `city` = VALUES(`city`), `state` = VALUES(`state`), `postcode` = VALUES(`postcode`), `updated_at` = UTC_TIMESTAMP();

-- ---------------------------------------------------------------------------
-- 2. sites — its site (marketing.mybizgate.com), resolved by client code
-- ---------------------------------------------------------------------------
INSERT INTO `sites` (`client_id`, `site_name`, `domain`, `domain_type`, `site_type`, `package_name`, `first_year_price`, `renewal_price`, `billing_months`, `start_date`, `expiry_date`, `status`, `created_at`, `updated_at`)
SELECT `c`.`id`, 'MyBizGate Marketing', 'marketing.mybizgate.com', 'subdomain', 'web_application', 'Internal', 0.00, 0.00, 12, '2026-11-06', NULL, 'active', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `clients` AS `c`
WHERE `c`.`client_code` = 'marketing'
ON DUPLICATE KEY UPDATE `site_name` = VALUES(`site_name`), `domain` = VALUES(`domain`), `domain_type` = VALUES(`domain_type`), `site_type` = VALUES(`site_type`), `package_name` = VALUES(`package_name`), `first_year_price` = VALUES(`first_year_price`), `renewal_price` = VALUES(`renewal_price`), `billing_months` = VALUES(`billing_months`), `status` = VALUES(`status`), `updated_at` = UTC_TIMESTAMP();

-- ---------------------------------------------------------------------------
-- 3. users — owner login of the marketing site (bcrypt hash only)
-- ---------------------------------------------------------------------------
-- shop:user marketing --role=owner (generated 2026-11-06 11:24:53, bcrypt hash only)
INSERT INTO `users` (`site_id`, `name`, `email`, `password`, `role`, `status`, `email_verified_at`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'MyBizGate', 'mybizgateway@gmail.com', '$2y$12$RQ3C60h/vYf3Ed0pcI8qbONPnlBMMzBIjhUXtOFg1Oui.F2qWldo6', 'owner', 'active', NOW(), NOW(), NOW()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `password` = VALUES(`password`), `role` = VALUES(`role`), `status` = VALUES(`status`), `updated_at` = NOW();
