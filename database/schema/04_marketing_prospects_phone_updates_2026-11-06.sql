-- ---------------------------------------------------------------------------
-- MyBizGate Client API — phone numbers found on Google Maps for prospects that
-- were imported without one in 02_marketing_prospects_2026-11-06.sql.
--
-- Task      : marketing_prospects_phones    Date: 2026-11-06
--
-- HOW TO APPLY (production, cPanel -> phpMyAdmin -> database -> SQL tab):
--   Paste this whole file and press Go. It is idempotent: each row is updated
--   only while its phone is still NULL, and skipped if another prospect
--   already holds the same number (site_id+phone is unique).
-- ---------------------------------------------------------------------------

SET NAMES utf8mb4;
UPDATE `marketing_prospects` AS `p`
JOIN `sites` AS `s` ON `s`.`id` = `p`.`site_id`
JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
LEFT JOIN (SELECT `site_id` FROM `marketing_prospects` WHERE `phone` = '60108813827') AS `dup`
  ON `dup`.`site_id` = `p`.`site_id`
SET `p`.`phone` = '60108813827',
    `p`.`notes` = CONCAT(`p`.`notes`, '\nPhone found: Paldives Pet | Cat Hotel Johor Bahru, 03-1 Jln Molek 3/20 (Google Maps)'),
    `p`.`updated_at` = UTC_TIMESTAMP()
WHERE `c`.`client_code` = 'marketing' AND `p`.`name` = 'Paldives Pet Resort'
  AND `p`.`phone` IS NULL AND `dup`.`site_id` IS NULL;
UPDATE `marketing_prospects` AS `p`
JOIN `sites` AS `s` ON `s`.`id` = `p`.`site_id`
JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
LEFT JOIN (SELECT `site_id` FROM `marketing_prospects` WHERE `phone` = '60179805656') AS `dup`
  ON `dup`.`site_id` = `p`.`site_id`
SET `p`.`phone` = '60179805656',
    `p`.`notes` = CONCAT(`p`.`notes`, '\nPhone found: DE LUNA CAT HOTEL & SPA, Jalan Wakaf Mek Zainab, Kota Bharu (Google Maps)'),
    `p`.`updated_at` = UTC_TIMESTAMP()
WHERE `c`.`client_code` = 'marketing' AND `p`.`name` = 'De Luna Cat Hotel & Spa'
  AND `p`.`phone` IS NULL AND `dup`.`site_id` IS NULL;
UPDATE `marketing_prospects` AS `p`
JOIN `sites` AS `s` ON `s`.`id` = `p`.`site_id`
JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
LEFT JOIN (SELECT `site_id` FROM `marketing_prospects` WHERE `phone` = '60104029606') AS `dup`
  ON `dup`.`site_id` = `p`.`site_id`
SET `p`.`phone` = '60104029606',
    `p`.`notes` = CONCAT(`p`.`notes`, '\nPhone found: Catzonia Kuala Lumpur branch, Jalan Wangsa Delima 13 (Google Maps)'),
    `p`.`updated_at` = UTC_TIMESTAMP()
WHERE `c`.`client_code` = 'marketing' AND `p`.`name` = 'Catzonia (chain, 9 outlets)'
  AND `p`.`phone` IS NULL AND `dup`.`site_id` IS NULL;
UPDATE `marketing_prospects` AS `p`
JOIN `sites` AS `s` ON `s`.`id` = `p`.`site_id`
JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
LEFT JOIN (SELECT `site_id` FROM `marketing_prospects` WHERE `phone` = '60105201178') AS `dup`
  ON `dup`.`site_id` = `p`.`site_id`
SET `p`.`phone` = '60105201178',
    `p`.`notes` = CONCAT(`p`.`notes`, '\nPhone found: Cattopia PJCC, 62-1 Jalan PJS 5/30 (Google Maps)'),
    `p`.`updated_at` = UTC_TIMESTAMP()
WHERE `c`.`client_code` = 'marketing' AND `p`.`name` = 'Cattopia Petaling Jaya'
  AND `p`.`phone` IS NULL AND `dup`.`site_id` IS NULL;
UPDATE `marketing_prospects` AS `p`
JOIN `sites` AS `s` ON `s`.`id` = `p`.`site_id`
JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
LEFT JOIN (SELECT `site_id` FROM `marketing_prospects` WHERE `phone` = '60198114498') AS `dup`
  ON `dup`.`site_id` = `p`.`site_id`
SET `p`.`phone` = '60198114498',
    `p`.`notes` = CONCAT(`p`.`notes`, '\nPhone found: Kittys Home HQ, Jalan Bunga Tanjung, Ampang (Google Maps)'),
    `p`.`updated_at` = UTC_TIMESTAMP()
WHERE `c`.`client_code` = 'marketing' AND `p`.`name` = 'Kitty''s Home'
  AND `p`.`phone` IS NULL AND `dup`.`site_id` IS NULL;
-- 5 statement(s)
