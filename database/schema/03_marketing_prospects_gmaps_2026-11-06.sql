-- ---------------------------------------------------------------------------
-- MyBizGate Client API — pet-boarding prospects from Google Maps sweeps of
-- Selangor, KL, Penang, Johor, Melaka, Perak, Negeri Sembilan, Pahang,
-- Kelantan, Terengganu, Kedah, Sabah and Sarawak (382 rows; focus on
-- businesses whose Google listing has NO website).
--
-- Task      : marketing_prospects_gmaps    Date: 2026-11-06
--
-- HOW TO APPLY (production, cPanel -> phpMyAdmin -> database -> SQL tab):
--   1. Apply 00_marketing_schema_2026-11-06.sql, 01_marketing_client_2026-11-06.sql
--      and 02_marketing_prospects_2026-11-06.sql first.
--   2. Paste this whole file and press Go. It is idempotent: each row is
--      inserted only when the marketing site has no prospect with the same
--      phone (or, without a phone, no phoneless prospect with the same name).
--
-- Priorities: A = no website + phone found, B = no website + no phone yet,
-- C = has a website but is clearly a boarding business.
-- ---------------------------------------------------------------------------

SET NAMES utf8mb4;
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'HapyKat Wellness Setiawangsa', '60342655666', 'cat_hotel', 'KLCC / Ampang, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (601 reviews); 27-G, Wisma MOCCIS Jalan Jelatek 2, Off, Jln Jelatek; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60342655666');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'D''Pets Kingdom', '60193319400', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (536 reviews); 8, Lebuh Satu; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60193319400');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Meow Lounge', '601188881990', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (413 reviews); 1, Jalan Melaka Raya 16; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601188881990');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'JC Puppy House Penang', '60195778808', 'cat_hotel', 'George Town, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (396 reviews); 69, Lebuh Mcnair; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60195778808');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Ming Yu Pet Station 2 ( Gong Kapas Kuala Terengganu )', '601149540793', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (359 reviews); 681, Jalan Sultan Mohamad; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601149540793');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cuddle Cat Hotel', '60134167568', 'cat_hotel', 'Sungai Petani, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (347 reviews); 11C, Persiaran BLM 6/2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60134167568');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Walk Studio', '60176357242', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.4 (316 reviews); RM 1-40; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60176357242');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pawfect Haus', '601161915202', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (292 reviews); 77, Lorong Hang Jebat; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601161915202');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Purrecious and Pawsome', '60123066488', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (285 reviews); Lot 161, Kg Chicha, Jln Pasir Puteh; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60123066488');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paragon Pets Lover Malacca', '60183238189', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (265 reviews); Jalan Iks M5; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60183238189');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Grooming (Meowy Groom)', '60107745512', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (257 reviews); 2, G9, Jalan Knmp 2a; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60107745512');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Happy Pawz Pet Care Centre', '60165592585', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (228 reviews); 21A, Persiaran Bandar Baru Tambun 16; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60165592585');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paddington Cat Hotel and Spa', '60195708200', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (215 reviews); B-44, Jalan Semambu; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60195708200');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'SiManja & SiComel Pets Shop', '60166621843', 'cat_hotel', 'Pengkalan / Lahat, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (209 reviews); 11 & 13, Jln Lapangan Symphony; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60166621843');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Domo Domo Pets Rahang Seremban', '60122666751', 'cat_hotel', 'Seremban', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.6 (206 reviews); 31, Jalan Za''aba; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60122666751');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'KH Pet House', '601111684981', 'cat_hotel', 'Austin Heights / Tebrau, JB', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (190 reviews); 28-01, 3, Jln Austin Heights 7; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111684981');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Ku Ceng Pet Shop', '601125592631', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (187 reviews); a47, Jln IM 7/1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601125592631');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'VP PAW BUDDIES CARE (PET BOARDING JOHOR)', '601128173919', 'cat_hotel', 'Pasir Gudang / Masai, Johor', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (186 reviews); 2, Jalan Lili 1/7; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601128173919');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Platinum Pets Home', '60392011210', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.6 (181 reviews); No. 40, Jalan Pandan Prima 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60392011210');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'One Love Pet Care Centre', '60146103042', 'cat_hotel', 'Ampang, Selangor', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (172 reviews); 55, Jalan Bunga Dahlia 4; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60146103042');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paw Station Pet Services', '60197999914', 'cat_hotel', 'Austin Heights / Tebrau, JB', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (163 reviews); Lake View Residency; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60197999914');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PB Artami Cat Abode', '60199563386', 'cat_hotel', 'Seremban', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (162 reviews); 7-1, Jalan Oasis 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60199563386');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PAWLAND', '601167697381', 'cat_hotel', 'Air Itam / Paya Terubong, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.3 (144 reviews); Jalan Oriental 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601167697381');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pet Paradise Hotel USJ', '60173813221', 'cat_hotel', 'Subang Jaya / USJ', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (143 reviews); 3B, Jalan USJ 1/19; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60173813221');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'OURS PET STUDIO - Sg Besi Pet Shop , Pet Grooming , Pet Boarding Service', '60397641241', 'cat_hotel', 'Kuchai Lama / OUG, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (142 reviews); B2-36-G, MIDFIELDS SQUARE EAST, Jalan 11/108c; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60397641241');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Groom De Pet Academy n Salon', '60391323519', 'cat_hotel', 'Cheras / Sungai Besi, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (138 reviews); 173, Jln Lanchang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60391323519');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Solfelix Cat Beauty & Care Centre', '60136289126', 'cat_hotel', 'Bayan Lepas / Bayan Baru, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (136 reviews); 72-2-49, ARENA CURVE, Jalan Mahsuri; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60136289126');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kitty House Pet Health Centre', '60166002190', 'cat_hotel', 'Klebang / Chemor, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (134 reviews); 26, Lengkok Meru Permai 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60166002190');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Manja Meow', '60148873266', 'cat_hotel', 'Matang / Metrocity, Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (134 reviews); Jalan Semariang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60148873266');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'ABAM KUCING Cat House', '601111300035', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (125 reviews); 17A, Jalan Sri Ampang 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111300035');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Catnip Castle Cat Hotel', '60143717456', 'cat_hotel', 'Alor Gajah, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (123 reviews); No,24 Jalan Sungai Petai 2/Utama Taman Sungai Petai Permai, Fasa 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60143717456');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat City Titiwangsa ( Outlet KL )', '60193742248', 'cat_hotel', 'KLCC / Ampang, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (117 reviews); No 30 - 1 , 30 - 2, 30 - 3, 30-4 , Jalan Lumut titiwangsa sentral; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60193742248');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Fluffy Cares Cat Hotels & Grooming', '60179664782', 'cat_hotel', 'Seri Kembangan', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (114 reviews); 56-1, Jalan Tasik Utama 5; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60179664782');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Eppy Cat House (Ladang HQ) - Pet Shop Kedai Kucing', '60179093929', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (113 reviews); Lot 5103 & 5104, Jalan Sultan Zainal Abidin; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60179093929');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Q Pets Cat Grooming Salon Kuala Terengganu', '60129889535', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.6 (111 reviews); 685A, Jalan Sultan Mohamad; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60129889535');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'CATsini Hotel Kucing & Grooming', '60176169190', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (109 reviews); A71, First Floor, 3, Lorong IM 3/19; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60176169190');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Villa Ipoh', '601111334562', 'cat_hotel', 'Klebang / Chemor, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (108 reviews); 34A, Persiaran Klebang Putra; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111334562');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cozy Pet Shop', '601188881552', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (106 reviews); 6-1, Jalan KSB 17; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601188881552');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PET KINGDOM (PET FOOD/PET BOARDING/PET GROOMING)', '601165159800', 'cat_hotel', 'Alor Setar', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (101 reviews); No.38,ground floor, Jalan Gangsa; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601165159800');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'La Molly Puppy Nursery', '60127871655', 'cat_hotel', 'Seri Kembangan', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (100 reviews); 101, Jln Damai Perdana 6/1D; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60127871655');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Yu Yu Kie (Cat Hotel & Spa)', '60197784788', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.9 (99 reviews); 30, Jalan Pandan Indah 4/4; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60197784788');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Derek''s Bunny House • Puchong', '60122252813', 'cat_hotel', 'Puchong', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (99 reviews); 71A, Jalan Kenari 20; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60122252813');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Von & Don Pet House', '60102821015', 'cat_hotel', 'Austin Heights / Tebrau, JB', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.6 (98 reviews); No 41, 1, Jalan Mutiara Emas 2A; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60102821015');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'JP Pet Suites', '60137174626', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (96 reviews); Jaya, B6 Lorong Sungai Isap Jaya 1 Taman Suria Perdana; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60137174626');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'My Pet Spa & Resort', '60137370414', 'cat_hotel', 'Petaling Jaya', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (92 reviews); 63, Jalan SS2/55; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60137370414');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'JC Pets Shop', '60124592645', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.6 (89 reviews); 61, Persiaran Desa Rishah 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60124592645');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Frenz Pet House Kubang kerian', '60139199172', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (82 reviews); Lot 2071, Jln Raja Perempuan Zainab II; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60139199172');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Wow-Wow@Meow-Meow Pet Saloon', '60392231009', 'cat_hotel', 'KLCC / Ampang, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (82 reviews); 510, Jln Pudu; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60392231009');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Mr & Mrs Cat Hotel', '60122887982', 'cat_hotel', 'Kajang', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (82 reviews); 25-1, Jalan SL 1/11; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60122887982');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kucing Kombat Cat Boarding & Store', '60176558270', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (79 reviews); A53 Lrg IM 5, 2, Jalan Sultan Abdullah; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60176558270');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Furry Paws Austin Crest', '60189626227', 'cat_hotel', 'Austin Heights / Tebrau, JB', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (77 reviews); 28-1, 10, Persiaran Jaya Putra; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60189626227');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'FURRY HAVEN', '60198481628', 'cat_hotel', 'KLCC / Ampang, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (76 reviews); 84A-1, Jalan Putra; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60198481628');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Muezza Cat Care', '60199195875', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (73 reviews); B14, TINGKAT 1, TAMAN DESA MESRA, Lor Permatang Badak Perdana 14; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60199195875');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PUFFY PET HOUSE', '60189051006', 'cat_hotel', 'Pengkalan / Lahat, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (73 reviews); 8A, TASIK BOTANI B/2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60189051006');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'ShaShaLand Paw Haus', '60126975178', 'cat_hotel', 'Kuchai Lama / OUG, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (72 reviews); 3, Jalan Awan Larat; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60126975178');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'V Pet Grooming &Pet Hotel Services', '601136020431', 'cat_hotel', 'Skudai, Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (69 reviews); 83, Jalan Seri Impian 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601136020431');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Friendly Pet House', '60102159700', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (69 reviews); 80, Laluan Perajurit 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60102159700');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Snow''s Cat Grooming & Boarding', '60163919175', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.4 (68 reviews); Section 6, No 43, Jalan 8/27d; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60163919175');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Geli Geli Kucing - Meru, Ipoh', '60135201060', 'cat_hotel', 'Klebang / Chemor, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.3 (68 reviews); 13, Jalan Meru Bestari A6; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60135201060');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Martin and Warm (Pets grooming)', '60176804668', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (67 reviews); No 5, Jalan KPKS 5 Kompleks Perniagaan Kota Syahbandar; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60176804668');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Shiro Pet Hotel & Spa', '60164341178', 'cat_hotel', 'Bayan Lepas / Bayan Baru, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (66 reviews); 1-2-12A, The One, Tingkat Mahsuri; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60164341178');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pineapple Pet House', '60123363002', 'cat_hotel', 'Kota Damansara', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (61 reviews); Perdana Exclusive Condominium, B-102, Jalan PJU 8/1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60123363002');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Mamamia Pet Sitter Kota Bharu', '60178064075', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (60 reviews); 4075-N, Jalan Raja Dewa Hilir; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60178064075');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Lovely Pet Management Sdn Bhd', '60165593047', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.2 (56 reviews); 48, Lebuh Bercham Selatan; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60165593047');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'iTSMYPET GROOMING & HOTEL', '601128206545', 'cat_hotel', 'Seremban', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (55 reviews); no 6, Lorong Matahari 1/1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601128206545');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pets Forest Retail & Grooming Centre', '60175410128', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.4 (55 reviews); 4, 4A, Lebuh Bercham Selatan 2/1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60175410128');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'NEKO CATBNB', '60197312468', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (55 reviews); No 18 Pusat Perdagangan Selaseh, Jln PPS 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60197312468');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Qutie Pet Shop / Grooming boarding service', '60126330388', 'cat_hotel', 'Kuchai Lama / OUG, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.3 (54 reviews); 227, Jalan Kuchai Maju 13; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60126330388');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'My Pet''s Avenue', '60128531891', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.4 (54 reviews); 12, Jalan Melaka Raya 14; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60128531891');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Bark Park Borneo and HASS Kennels', '60102260330', 'cat_hotel', 'Penrissen / Batu 7, Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (53 reviews); Stampin Ammo Depot Rd; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60102260330');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cathopea Empire cat spa grooming hotel', '60197728061', 'cat_hotel', 'Skudai, Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (52 reviews); No11A Jalan Pulai Mutiara 4/10,Taman pulai mutiara Skudai; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60197728061');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Yumie cat hotel & spa', '60108885066', 'cat_hotel', 'Sendayan / Seremban 2', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (52 reviews); 6-G Jalan Metro Sendayan 1/4, Persiaran Metro Sendayan; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60108885066');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PAWS (Eco Botanic)', '60168406335', 'cat_hotel', 'Iskandar Puteri / Gelang Patah', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (51 reviews); 63, Jalan Eko Botani 3/5; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60168406335');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'FURKIDS Hotel & Spa', '60195209252', 'cat_hotel', 'Jitra, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (51 reviews); No 3 Kampung Padang Tok Kesop, Jalan Kubang Lembu; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60195209252');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pink Whiskers Pet Spa & Hotel', '601123519193', 'cat_hotel', 'Bayan Lepas / Bayan Baru, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (49 reviews); 54-G, Persiaran Bayan Indah; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601123519193');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'D''zara Pet Shop , Cat Hotel & Grooming', '60192471735', 'cat_hotel', 'Sendayan / Seremban 2', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (48 reviews); METRO PARK, 1, Jalan Metro Park Sendayan 1/3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60192471735');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pet Aesthetic Woofy (PAWoofy)', '60176260626', 'cat_hotel', 'Air Itam / Paya Terubong, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (47 reviews); 18Q, Jalan Kampung Melayu; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60176260626');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'DD&CATS Cat Hotel, Grooming & Accessories Jalan Kuching Kuala Lumpur', '60126006087', 'cat_hotel', 'Mont Kiara / Sri Hartamas, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (46 reviews); Block C-1-2, Boulevard Business Park, Jln Kuching; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60126006087');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Catlefurnea Cats Hotel', '601120902313', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (46 reviews); 45, Jln M7; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601120902313');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Hotel for CATS - Kelantan', '601114840426', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (45 reviews); 2151, Taman Puteri; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601114840426');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Meowky House', '60135874132', 'cat_hotel', 'George Town, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (45 reviews); 101, Lorong Macalister; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60135874132');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Bommi Pet Beauty & Spa', '601115142932', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (45 reviews); 30, Jln Medan Ipoh 1B; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601115142932');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'QD CATS HOTEL & SPA CENTRE HQ', '60105655508', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (45 reviews); No 13 level 1 & 2, Jalan Batas Baru; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60105655508');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Super Mario Pet Hotel', '60164523619', 'cat_hotel', 'Bayan Lepas / Bayan Baru, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (44 reviews); GOLDEN TRIANGLE, Jalan Dato Ismail Hashim; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60164523619');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'AJVie Cat Centre', '60124446189', 'cat_hotel', 'Pengkalan / Lahat, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.6 (44 reviews); 18, Lapangan Perdana 11; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60124446189');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kedutaan Kucing', '60189733058', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (41 reviews); 9, Jalan Wangsa Budi 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60189733058');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'BAITUL KITTAH HOTEL & SPA KUCING', '60146651983', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.0 (41 reviews); 47 A/2 , Taman Jaya, Jalan Pusara; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60146651983');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'SM PET HOTEL', '60162982555', 'cat_hotel', 'Skudai, Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (40 reviews); Taman Pulai Hijauan, 38, Jalan Paprika 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60162982555');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'TSR Cat Hotel', '601160880504', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (40 reviews); NO 23, JLN PNG Pusat Niaga, Jalan Gangsa; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601160880504');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Lona Cattery Cat Boarding and Hotel', '60175097076', 'cat_hotel', 'Bukit Mertajam, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (40 reviews); 33, Lorong Alma Jaya 34; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60175097076');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Fluffy Animal Care', '60107080991', 'cat_hotel', 'Iskandar Puteri / Gelang Patah', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (37 reviews); 117A, Jln Sentral 24; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60107080991');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'MeowPalace & Grooming Service', '60105656726', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.6 (37 reviews); 7-1 , Jalan PNG, Jalan Gangsa; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60105656726');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Miami Pet House', '60165083181', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.4 (37 reviews); Taman Silibin Ria, 133 & 135, Lengkok Rishah 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60165083181');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Honey BearZ Pet Empire', '601118667378', 'cat_hotel', 'George Town, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (36 reviews); 326T-01, Jln Perak; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601118667378');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'House Of Cat Tanjung Bungah', '601155598838', 'cat_hotel', 'Tanjung Bungah, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (36 reviews); 22, Jalan Tanjung Bungah; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601155598838');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'ZEEMOO PET HOUSE', '601136112662', 'cat_hotel', 'Skudai, Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (35 reviews); 51-02, jalan sutera pulai 2/26; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601136112662');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'QQ Pet Boarding', '601116880919', 'cat_hotel', 'George Town, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (35 reviews); 19, Jalan Jones; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601116880919');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Mama Ta Cats Care', '60164225499', 'cat_hotel', 'Bayan Lepas / Bayan Baru, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (35 reviews); lot 29-2-40, Golden Triangle, Jalan Dato Ismail Hashim; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60164225499');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'HOUSE OF CAT Perak', '60103978897', 'cat_hotel', 'Klebang / Chemor, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (35 reviews); D.R, 11 & 13, Jalan Sci 1/2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60103978897');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Urban Pets Inn', '60175879635', 'cat_hotel', 'Alor Setar', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.6 (34 reviews); 69B, Seberang, Jln Tunku Abdul Rahman Putra; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60175879635');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pet Images', '60165128686', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.2 (34 reviews); 27 & 27A, Laluan Ipoh Permai 9; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60165128686');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PussyCat Mansion', '60102692617', 'cat_hotel', 'Sendayan / Seremban 2', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (33 reviews); 19-G, Pusat Komersial Irama Sendayan 1/2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60102692617');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pet Castle', '60106616105', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.3 (33 reviews); B-112, Jalan Rasau Aman 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60106616105');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Oasis Cuddle Cat Resort', '60105984200', 'cat_hotel', 'Batu Kawan, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (33 reviews); 48-1, Jalan Vervea 13 Bandar Cassia; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60105984200');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'DELIO PET SERVICES', '601111515617', 'cat_hotel', 'Batu Gajah / Kampar, Perak', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (32 reviews); phone-only listing; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111515617');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Katze! Hotel & Grooming', '601137932412', 'cat_hotel', 'Matang / Metrocity, Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (32 reviews); Level 1, Metrocity area; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601137932412');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Nikko Space @ Golden Nikko Cattery', '60176044438', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (31 reviews); 7, Jalan Sutera 1/2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60176044438');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'KAYANGAN CATS HOTEL & SPA', '60134332041', 'cat_hotel', 'Bukit Mertajam, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.6 (31 reviews); 497, Lorong Perda Timur 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60134332041');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kiyomi Paw', '601139282818', 'cat_hotel', 'Menggatal / Inanam, Kota Kinabalu', 'Sabah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (31 reviews); 6, Lorong Suria Inanam 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601139282818');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Katz Village Dato Onn', '60134965661', 'cat_hotel', 'Austin Heights / Tebrau, JB', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (30 reviews); No 27, Jalan Kempas 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60134965661');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'CatDreamPetHotel', '60105371171', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.6 (30 reviews); 1713 -C, Jalan Pasir Hor; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60105371171');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Fluff Pet House', '60183564623', 'cat_hotel', 'Kuchai Lama / OUG, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (30 reviews); 35, Jln 6/125d; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60183564623');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'JH Cat Boarding Dome House', '60182832130', 'cat_hotel', 'Batu Caves / Gombak', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (30 reviews); 20, Jalan 11c; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60182832130');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Azim Pet Shop & Cattery', '60139053012', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.3 (29 reviews); Lot 661-F, Kampung Pintu Geng; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60139053012');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Ella Pet Care', '601165472332', 'cat_hotel', 'Batu Caves / Gombak', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (29 reviews); 44, Jalan Ambong Kiri 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601165472332');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Tails Tale Pets Grooming & Hotel', '601110881596', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.8 (29 reviews); 203-H, Jalan Kenanga 3/29; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601110881596');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Purrfect Luxury Cat Hotel', '601154180794', 'cat_hotel', 'Kepala Batas / Bertam, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (28 reviews); Jaya, 74-1, Jalan Sepadu Jaya 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601154180794');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'VTREE Cat Hotel', '601128898939', 'cat_hotel', 'Ampang, Selangor', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (28 reviews); Jalan Bunga Tanjung 18; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601128898939');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Jebatz Villa Cat', '60127994484', 'cat_hotel', 'Skudai, Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (27 reviews); 18-01, Jalan Uda Utama 4/1 Bandar Uda Utama Johor Bahru; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60127994484');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Southern Beast Kennel JB', '601117523420', 'cat_hotel', 'Skudai, Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (27 reviews); 2, Jalan Dasa; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601117523420');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Inn Hauz', '601159880235', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (27 reviews); B6, GF, Lorong Bukit Setongkol Maju 21; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601159880235');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'CATRINA PET HOUSE -AIR PUTIH', '60109210062', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (27 reviews); Lorong Air Putih 130, B-38-B-40,Ground Floor; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60109210062');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PETS DREAM GARDEN', '60199310294', 'cat_hotel', 'Balok / Beserah, Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.1 (27 reviews); B31 Taman Padang Permai Jln Sg. Lembing; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60199310294');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pawfectly Pet Grooming (CREST AUSTIN)', '601170109981', 'cat_hotel', 'Austin Heights / Tebrau, JB', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (26 reviews); 56, 56-01, Jalan Jaya Putra 7/5; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601170109981');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paw Boutique Pet Hotel', '60185722557', 'cat_hotel', 'Mont Kiara / Sri Hartamas, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (26 reviews); 30-2, Jalan 28/70a; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60185722557');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'CATTITUDE PET HOTEL', '60182126712', 'cat_hotel', 'Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (25 reviews); 26-01, Jalan Setia Tropika 1/24; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60182126712');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Lola Cat Houz', '60137242526', 'cat_hotel', 'Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (25 reviews); Larkin Indah, 01-18, Jln Datin Halimah; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60137242526');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Miao Pet Pengkalan Chepa', '60125702767', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (25 reviews); PT2269,TANJONG MAS, Jln Tok Guru; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60125702767');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Darling Cattery Services', '60165524996', 'cat_hotel', 'Cheras / Sungai Besi, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (25 reviews); 3, 12-A, Jalan Kaskas 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60165524996');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Petsmile', '60126234848', 'cat_hotel', 'Seremban', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.3 (25 reviews); 74A, Lorong Haruan 5/3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60126234848');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Amazing Pets@Kota Kinabalu ( Penampang Branch )', '60179189959', 'cat_hotel', 'Putatan, Kota Kinabalu', 'Sabah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.3 (25 reviews); LOT 8, GROUND FLOOR, Kg MOGONIBUNG, Jalan Penampang Lama; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60179189959');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Lazy Cat Home', '60108496397', 'cat_hotel', 'Kota Kinabalu', 'Sabah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.9 (25 reviews); Kota Kinabalu; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60108496397');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Keymes Cat Hotel', '60192306689', 'cat_hotel', 'Kulim, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (24 reviews); Tingkat 1, No 55, 1, Lorong Kenari 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60192306689');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Angora Cat Hotel', '60176920233', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (24 reviews); 24-1 Jalan 11/55C, Persiaran Bukit Setiawangsa; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60176920233');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PURRADISE CAT SHOP, HOTEL & SPA', '60199026100', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (23 reviews); DEPAN CALTEX PANJI, LOT1313, Jalan Hospital; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60199026100');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'IQ Pets House senawang Lavender Heights', '60127792231', 'cat_hotel', 'Seremban', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.8 (23 reviews); NO 14-G, Jalan KLS 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60127792231');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kitty kats shop', '60105630388', 'cat_hotel', 'Kuchai Lama / OUG, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (22 reviews); 3, Jalan Kuchai Maju 13; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60105630388');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pawty Times Enterprise', '60183774263', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (22 reviews); Syah Bandar, 8-1 Jalan KSB 12,Taman Kota; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60183774263');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Woof Meow Pet Salon', '60173381719', 'cat_hotel', 'Air Itam / Paya Terubong, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.3 (22 reviews); Gembira Parade, 18-01-04, Lorong Delima 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60173381719');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'SS TAIL''Z & WAG''Z', '60109737001', 'cat_hotel', 'Seri Kembangan', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (22 reviews); 6, Jalan PUJ 2/16; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60109737001');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'LINXPET HOTEL', '60132090520', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (21 reviews); LOT 374, BLOCK, 10, Lorong Palm; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60132090520');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Nana Pets', '60198822408', 'cat_hotel', 'Subang Jaya / USJ', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (21 reviews); 32A-2, Mentari Plaza, Jalan PJS 8/2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60198822408');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Ayoh Cat Kuala Terengganu', '60108450911', 'cat_hotel', 'Gong Badak, Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (21 reviews); Lot 30863, Jalan Lapangan Terbang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60108450911');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'CATSLE BANDAR UDA UTAMA', '60169880051', 'cat_hotel', 'Skudai, Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (20 reviews); 38A, Jalan Uda Utama 4/1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60169880051');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pawpaws Inn', '60109296994', 'cat_hotel', 'Alor Setar', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (20 reviews); 176A Tingkat, 1, Jalan Kristal 5; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60109296994');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cats on Wheels - Cat Hotel & Grooming', '60172589454', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (20 reviews); Pusat Perniagaan Putra Sentosa, 17, Jalan PPPS 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60172589454');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Tiny Paws Kuching Cat Hotel', '60179561581', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (20 reviews); NBX2, PLOT 7, 2nd Floor Northbank; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60179561581');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Ruffcutts Pet Boarding and Grooming', '60128778256', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (20 reviews); 1st Floor, Sublot 15, Section 64, Panovel Commercial Centre, Jalan Simpang Tiga; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60128778256');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Tok Mama Cat House', '601110199596', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (19 reviews); LOT 1904, JALAN PANCHOR KEMUMIN; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601110199596');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'SiJali Cat Hotel & Spa', '60133030281', 'cat_hotel', 'Seremban', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 1.6 (19 reviews); 7, Jalan Angsana 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60133030281');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Dol Dol Pet Lounge', '60124447838', 'cat_hotel', 'Tanjung Bungah, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (19 reviews); 1-1-17 , 1-1, 18, Persiaran Halia 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60124447838');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'MeowMeow Inn Cat Hotel & Grooming', '601156305377', 'cat_hotel', 'Kepala Batas / Bertam, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (19 reviews); 3, 53A, Jalan Shahbandar 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601156305377');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Friendly Pet House Meru', '60166159700', 'cat_hotel', 'Klebang / Chemor, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (19 reviews); 7, Jln Meru Bestari A8; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60166159700');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Charlie''s Dog Boarding & Training Zone', '60125704641', 'cat_hotel', 'Penrissen / Batu 7, Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.5 (19 reviews); 72 Batu 15, Jalan Kuching - Serian; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60125704641');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'POPO Catz Boarding House (Cat Hotel & Spa)', '601156494981', 'cat_hotel', 'Kulim, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (18 reviews); No 20; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601156494981');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Loyal knine', '60168860957', 'cat_hotel', 'Sungai Petani, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (18 reviews); Lot 32, kampung Pinang Dalam sg lalang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60168860957');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'MeowSayang Grooming', '601126696726', 'cat_hotel', 'Merlimau / Jasin, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (18 reviews); JC2614-1, Jln PB 4; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601126696726');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Teratak Meow Pet Haven', '60122080058', 'cat_hotel', 'Seremban', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (18 reviews); 670, Jalan Haruan 4/10; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60122080058');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PETS & ME', '60125349764', 'cat_hotel', 'Tanjung Bungah, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (18 reviews); 1-1-27 The Peak Residence Persiaran Halia 3 Tanjung Bungah; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60125349764');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Petcity Hotel', '601155802950', 'cat_hotel', 'Butterworth, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (17 reviews); NO.1-(1ST FLOOR, Lorong Teras Jaya 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601155802950');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cats budget studio petshop,hotel & grooming', '60132002747', 'cat_hotel', 'Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.2 (16 reviews); 54-54B jalan stulang baru, off, Jalan Syukur; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60132002747');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Super Pet Merlimau', '601163639366', 'cat_hotel', 'Merlimau / Jasin, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.4 (16 reviews); JC 124, Bandar Baru, Jalan BMU 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601163639366');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pusak Kamek Grooming and Boarding', '60109797047', 'cat_hotel', 'Matang / Metrocity, Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (16 reviews); Q309; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60109797047');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paradise Pet Hotel', '60103977271', 'cat_hotel', 'Seri Kembangan', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (16 reviews); Jalan Cemara; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60103977271');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Hotel & Spa - Elly''s Paw Station', '60174634849', 'cat_hotel', 'Alor Setar', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (15 reviews); no 4, komplek perniagaan taman restu, Jalan Taman Sepakat; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60174634849');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Ezra Pet Shop & Hotel (Seremban 2)', '60106608527', 'cat_hotel', 'Sendayan / Seremban 2', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (15 reviews); No 9-G, Jalan RK 5, 3, Rasah Kemayan; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60106608527');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cool 9 pet house', '60175396056', 'cat_hotel', 'Bayan Lepas / Bayan Baru, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (15 reviews); 730, Jalan Sungai Dua; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60175396056');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Woofy Pet Care', '60184058206', 'cat_hotel', 'Bukit Mertajam, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (15 reviews); 33, Lorong Bayu Mutiara 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60184058206');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Four Paws Pet Boarding', '60125706889', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (15 reviews); 23, Lorong C; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60125706889');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Bark & Play', '60145960457', 'cat_hotel', 'Bangsar / Pantai, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (15 reviews); Jln Dato Abu Bakar 16/1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60145960457');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Zara Pet Sitter Johor Bahru', '60127844684', 'cat_hotel', 'Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (14 reviews); 012-784 4684; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60127844684');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Rabeena Pink Pet''s Planet', '601111684482', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (14 reviews); B42, Jalan IM3/10; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111684482');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PUG PUG LOVELY PET STORE 88', '60178663241', 'cat_hotel', 'Butterworth, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (14 reviews); No.23, Ground Floor, Jalan Tanjung Jaya 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60178663241');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pet Monster''s', '601110529921', 'cat_hotel', 'Air Itam / Paya Terubong, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (14 reviews); 363p, Jalan Sultan Azlan Shah; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601110529921');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PUTEH CATSTAY', '60124321089', 'cat_hotel', 'Bukit Mertajam, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (14 reviews); 1903, Jalan Kebun Sireh; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60124321089');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'K Pets Animal Care', '60125270419', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (14 reviews); 13, Jalan Medan Ipoh 8; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60125270419');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Waggy Tails Pet Grooming Centre', '601111025889', 'cat_hotel', 'Klebang / Chemor, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (14 reviews); 103, Jln. Kuala Kangsar; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111025889');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'AJ KENNEL PALACE', '60164057533', 'cat_hotel', 'Menggatal / Inanam, Kota Kinabalu', 'Sabah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (14 reviews); Jalan Mahandoi Kg Kiambalang Babagon Toki, Jalan Kionsom; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60164057533');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Hotel kucing dan grooming, Smart Cats homestay', '60162511351', 'cat_hotel', 'Bangsar / Pantai, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (14 reviews); Blok D4, Unit 18-5, Sri Manja Square One, Jalan PJS 3/48; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60162511351');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Eyes Hotel & Grooming', '601111950180', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (13 reviews); 11-1 Jalan Merak Mas Taman Merak Mas 8 Bukit Katil 75450 Melaka Bukit Katil; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111950180');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paws N Pups Grooming & Spa', '601115028208', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.6 (13 reviews); No30, Jalan MP2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601115028208');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'A''Pawtopia Pet Boarding & Daycare', '60173968682', 'cat_hotel', 'Air Itam / Paya Terubong, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (13 reviews); Jalan Khemah; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60173968682');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'BIbenboy tadicat petshop', '60195797170', 'cat_hotel', 'George Town, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (13 reviews); 28-G-5, taman sri pinang, JALAN veterinary; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60195797170');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Beauty Pets House', '60124809126', 'cat_hotel', 'Pengkalan / Lahat, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (13 reviews); 43, Medan Soon Choon 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60124809126');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Check-in Ipoh', '60108417818', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.2 (13 reviews); 184, Jln Sultan Nazrin Shah; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60108417818');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Haomao Cat Hotel & Grooming', '60137476737', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (13 reviews); Sublot 3, 1st Floor, Yarra Commercial Shoplot, Jalan Batu Kawa; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60137476737');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'De Little Paw', '601163380608', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (13 reviews); Lot 3241 (Sublot 28), Tt3 Commercial Centre, Jalan Canna; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601163380608');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Abang Kucing Grooming & Hotel', '60132237553', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (13 reviews); No 52-Floor 2 Pusat Komersial Cabang 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60132237553');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'CatsWorld', '60192269044', 'cat_hotel', 'KLCC / Ampang, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (12 reviews); Perumahan Angkatan Tentera Jalan Uthant, Off, Jalan Desa Pandan 1/76; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60192269044');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Lady Myaw Kittycare', '60133358102', 'cat_hotel', 'Kuala Lumpur', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (12 reviews); Jalan Jubilee; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60133358102');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Notti Dog Hostel & Daycare', '60123266155', 'cat_hotel', 'Mont Kiara / Sri Hartamas, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (12 reviews); 27, Jalan 9; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60123266155');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Lex Pets Homestay', '601156921219', 'cat_hotel', 'Sendayan / Seremban 2', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (12 reviews); 149 Jalan Idaman Bayu, 1/4, Taman Idaman Bayu 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601156921219');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'NEKO''S Cat Boarding Sungai Petani', '60194789988', 'cat_hotel', 'Sungai Petani, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (11 reviews); No 132, Tingkat Atas, Jalan Melati 1, 4, Zon Melati 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60194789988');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Seven Cats House', '60134227957', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (11 reviews); 6-M, Jalan Perdana 5/11; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60134227957');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'IPET Grooming and Boarding', '601116186087', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (11 reviews); 20, Jalan Seri 5; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601116186087');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Lovely Pet Academy', '601111991488', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.5 (11 reviews); 59, Jalan Sultan Azlan Shah Utara; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111991488');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Firkets Pet hotel and Grooming', '60102064252', 'cat_hotel', 'Cheras / Sungai Besi, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (10 reviews); 26-2, Jalan Dwitasik; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60102064252');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat CEO Boarding House', '601156273191', 'cat_hotel', 'Bayan Lepas / Bayan Baru, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (10 reviews); 1C-2, Desaria, Tingkat Kenari 6; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601156273191');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'CKY''CATs GROOMING & BOARDING', '60132576556', 'cat_hotel', 'Menggatal / Inanam, Kota Kinabalu', 'Sabah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.6 (10 reviews); 1st Floor, Lot 3, Wisma D Sulaman, Phase 5B Kingfisher Sulaman; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60132576556');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Eat Play Stay Pet Boarding Cheras', '60123908464', 'cat_hotel', 'Seri Kembangan', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (10 reviews); Jalan 3/154A Taman Delima, Cheras; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60123908464');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Dhialova Cat Hotel and Spa', '60139907289', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (10 reviews); Lot 822-A, Kg.Kepong; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60139907289');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kittycation cat hotel & grooming center', '601113111600', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (9 reviews); 76-1, Jalan Impian 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601113111600');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Aidiel Feline Cattery', '60136972344', 'cat_hotel', 'Seremban', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (9 reviews); 537, Jln Cenderawasih 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60136972344');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paws Party', '60129876344', 'cat_hotel', 'Tanjung Bungah, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (9 reviews); 1-O, Jalan Sungai Kelian; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60129876344');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Holiday Cat', '60177983588', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (9 reviews); 29, Jalan Raja Ashman Shah; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60177983588');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'LINXPET HOTEL METROCITY', '60189796697', 'cat_hotel', 'Matang / Metrocity, Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (9 reviews); Precint, Block 1, Metrocity''s Commercial, Ground Floor, Lot 14142, Jalan Matang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60189796697');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Wagging Tails With Nice Pets', '60197424088', 'cat_hotel', 'Iskandar Puteri / Gelang Patah', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (8 reviews); 56, Jalan Horizon Perdana 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60197424088');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kitty Garden Studio', '601127389574', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.9 (8 reviews); PADANG ENGGAN, PT 227, TINGKAT 1, WAKAF CHE YEH, Jalan Kuala Krai; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601127389574');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'ZOOLA Your Cat Deserves The Best', '60146126488', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.9 (8 reviews); 13, Jalan Takh 15; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60146126488');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Dottie Cattery', '60125458624', 'cat_hotel', 'Jitra, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.4 (7 reviews); 158, Jalan Taman Mahsuri Fasa 2D; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60125458624');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'BELLO PET HOUSE', '60102555779', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (7 reviews); Jalan Rahmat 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60102555779');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Miz Groomers Pet Care', '60146808051', 'cat_hotel', 'Pengkalan / Lahat, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.3 (7 reviews); 10, Medan stesen 18/7; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60146808051');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'De Champ Cattery 冠宠猫舍', '60139688808', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (7 reviews); 447, Jln 4; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60139688808');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kastor Dog Park Resort', '601114353522', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.3 (7 reviews); Jln Beverly Height; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601114353522');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Oyen & Buddy Cat Hotel & Grooming', '60123460293', 'cat_hotel', 'Sungai Petani, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.7 (6 reviews); 139-1, Jalan Melati 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60123460293');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pawsfection Hotel & Spa', '60105583883', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (6 reviews); Lot 68-B; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60105583883');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pusak Pethouse Pasir Mas', '60145426020', 'cat_hotel', 'Pasir Mas, Kelantan', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (6 reviews); Kedai No C Lot 588 KM 5 Lebuh Raya Pasir Mas-Rantau Panjang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60145426020');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'NayliS Cat Hotel', '60192122926', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (6 reviews); phone-only listing; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60192122926');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'MOLLY CATS WELLNESS', '60149376694', 'cat_hotel', 'Sendayan / Seremban 2', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.3 (6 reviews); Jalan Pusat Dagangan Sendayan 3/5; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60149376694');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cats World Pahang Cattery', '60139252055', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.0 (6 reviews); B 37,Ground Floor, Jalan Dato'' Wong Ah Jang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60139252055');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Villa Kuala Terengganu', '601155414561', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (6 reviews); PT 3576, RUMAH KEDAI KG DARAT, Jalan Bukit Tumbuh; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601155414561');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'MawaRose Katz', '60195557976', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (6 reviews); Lot 1954, Kg. Binjai Berambu; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60195557976');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Meet Cute Pet Boarding & Grooming', '60148843193', 'cat_hotel', 'Iskandar Puteri / Gelang Patah', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (5 reviews); 32-02, Jalan Indah 13/2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60148843193');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'HOTEL SI MEOW', '601116723919', 'cat_hotel', 'Alor Setar', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.4 (5 reviews); 17A TINGKAT 1 TAMAN SRI TANDOP, Jln Taman Jeliti; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601116723919');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Eirfan Petshop,Cat Hotel and Grooming', '60173444408', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (5 reviews); Lot 3103 taman indah, jalan padang tembak pengkalan chepa; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60173444408');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Twenty Twenty Five Station', '60102506495', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (5 reviews); 3-1, JALAN KOMARSIL IAN 2, Jln Industri Angkasa Nuri; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60102506495');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Beyond petshop', '60103637683', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (5 reviews); Jln RU 7; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60103637683');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'DSM Pet Enterprise', '60169001591', 'cat_hotel', 'Seremban', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (5 reviews); 52-1, Jalan PKBB 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60169001591');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Little Pawz', '60129082636', 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.4 (5 reviews); No B, 540, Jalan Air Putih; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60129082636');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'My Buddies Pet Care', '60125652595', 'cat_hotel', 'George Town, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (5 reviews); 72-B, Jalan Anson; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60125652595');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Purrrfect Dot Co', '60124393914', 'cat_hotel', 'Air Itam / Paya Terubong, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (5 reviews); 27, Tingkat Sungai Rusa 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60124393914');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pawfect Sunshine', '601158830882', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (5 reviews); 18, Persiaran Bekor 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601158830882');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'J.N.S PET VENUE', '60149142144', 'cat_hotel', 'Matang / Metrocity, Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (5 reviews); phone-only listing; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60149142144');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pets Inn & Bath', '60109600056', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (5 reviews); Jalan Nyatoh; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60109600056');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'KING CATS BOSS', '60179199519', 'cat_hotel', 'Gong Badak, Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.8 (5 reviews); Batu Rakit area; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60179199519');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Sayang Cat House', '60123831423', 'cat_hotel', 'Sungai Petani, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (4 reviews); B227, Lorong Cendana 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60123831423');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cattalesya Pet House', '601110365886', 'cat_hotel', 'Jitra, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (4 reviews); 1270 Pekan Tok Jalai, Jalan Jitra; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601110365886');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'AMRIEY CATS HOUSE', '601116220221', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (4 reviews); PT 3911, NO.26, Tingkat Atas, Jalan Setia 4; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601116220221');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pawtails Pet Centre', '60109519618', 'cat_hotel', 'Air Itam / Paya Terubong, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.0 (4 reviews); 2C-01, 12, Medan Angsana 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60109519618');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'CLAU N PAWS PET CENTRE', '601126736228', 'cat_hotel', 'Pengkalan / Lahat, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.0 (4 reviews); 5, Lebuh Lapangan Perdana 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601126736228');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Maoly Catmories Grooming & Spa', '60195997680', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (4 reviews); 1602, Jalan Panji Alam; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60195997680');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Messy Paws (Petsitting, Pet Mobile)', '60174054530', 'cat_hotel', 'Dungun area, Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (4 reviews); no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60174054530');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'NA PET GLOBAL', '601167857379', 'cat_hotel', 'Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (3 reviews); Central Park, 05-02, Persiaran Aliff Harmoni 6; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601167857379');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Bark & Bed Pet Daycare', '601136572553', 'cat_hotel', 'Sungai Petani, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (3 reviews); Lorong 40; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601136572553');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Gatto Cat Hotel & Spa', '60174762962', 'cat_hotel', 'Alor Setar', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (3 reviews); NO 2502; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60174762962');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'The Pet Vacay', '60122082007', 'cat_hotel', 'Tanjung Bungah, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (3 reviews); 29, Jalan Bunga Cempa Putih; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60122082007');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Petcity Hotel-Bagan Ajam', '601155812950', 'cat_hotel', 'Butterworth, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (3 reviews); 15, Jalan Thamby Kecil; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601155812950');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Samlex Penang', '60124411795', 'cat_hotel', 'Bukit Mertajam, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (3 reviews); 28-1, Lorong Maju Utama 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60124411795');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paws Pet Care Centre', '60175898950', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (3 reviews); Timur 1, 75A, Jalan Wira Jaya; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60175898950');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'meow si kucing pet house hotel & spa', '60138930052', 'cat_hotel', 'Klebang / Chemor, Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.3 (3 reviews); 55, Laluan Tawas Damai; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60138930052');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'V CARE PET HOTEL', '60146883283', 'cat_hotel', 'Skudai, Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); 21A,JALAN GEMILANG 1,TAMAN BUKIT GEMILANG SKUDAI; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60146883283');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'KYOE PET HOUSE (GROOMING AND BOARDING)', '60146072374', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); Lot 4373 Kg. Kubang Kacang, Jln Tiong; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60146072374');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pawfection Cat Hotel & Spa', '601156374778', 'cat_hotel', 'Pasir Puteh, Kelantan', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); PT 4362 (A, BANDAR BARU; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601156374778');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Catz Inn Hotel', '601133110362', 'cat_hotel', 'Machang area, Kelantan', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); PT 725, Jalan Haji Tuan Wook; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601133110362');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Hotel Kucing Mama', '60183993519', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); Lot 2905-C; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60183993519');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Turkish Van Cat Villa', '601155883368', 'cat_hotel', 'Seremban', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); 31, Jalan S2 B1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601155883368');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Meow The Land', '60198381455', 'cat_hotel', 'Balok / Beserah, Kuantan', 'Pahang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); Perumahan, B-8, Tingkat 1 Lorong, Lrg Kampung Padang Permai 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60198381455');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Garden Paw Pet Boarding', '60125279589', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); Jalan Perpaduan Mulia 6; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60125279589');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Angel Pet Boarding', '60185769543', 'cat_hotel', 'Batu Gajah / Kampar, Perak', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); No 13; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60185769543');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'pawsionate pet hotel', '60128201711', 'cat_hotel', 'Putatan, Kota Kinabalu', 'Sabah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); lot 19, 2nd floor, Lorong Austin Business Park 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60128201711');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Peek A Meow', '60146639632', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); 32a, Jalan Sungai Maong Hilir; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60146639632');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Macido Home Pet Care', '60143328349', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 3.0 (2 reviews); Pl, 78, Jalan tabuan dusun, Lorong Kedandi 6; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60143328349');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Si Comel Pet Store', '601117600353', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); Block A-1-07, Desa Permai, Jalan 16b; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601117600353');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kuromi Cat Spa', '60192946130', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (2 reviews); Mewah Court, Jalan Harmoni, Taman; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60192946130');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Royal Gatta Cattery', '601110613054', 'cat_hotel', 'Sungai Petani, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); 597, Jalan Bandar Puteri Jaya 3a/13a; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601110613054');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'UR Cat House', '60194551291', 'cat_hotel', 'Sungai Petani, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); no 22, Taman aman perwira; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60194551291');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Lo.Cat Friend Hotel', '601117936641', 'cat_hotel', 'Pendang, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); 35A, Persiaran Pendang Square 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601117936641');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Spa & hotel kucing kubang kerian', '60165575723', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); tingkat 1, Lot 1867, Jalan Tok Kenali; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60165575723');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Latte''s World Pet''s Homestay', '60126437088', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); 101, Jalan Ayer Jerneh; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60126437088');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Purrecious Pet', '60178718172', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); 239-1, Jalan Satu Krubong, Taman Satu Krubong; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60178718172');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'RR Petville', '601111309152', 'cat_hotel', 'Alor Gajah, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); 52, Jalan KP 4; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111309152');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Hexxy Cat Hotel & Spa', '60103317478', 'cat_hotel', 'Seremban', 'Negeri Sembilan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); 104-1, Pusat Perniagaan, Jalan Lavender Heights 1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60103317478');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cloud Paws Hub', '60172626199', 'cat_hotel', 'Batu Kawan, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); 15-G, Jalan Vervea 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60172626199');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PRO PET CARE', '60165587665', 'cat_hotel', 'Ipoh', 'Perak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); 48, Jalan Ng Weng Hup; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60165587665');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'MD Pet''s House', '60109302676', 'cat_hotel', 'Kota Kinabalu', 'Sabah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 4.0 (1 reviews); 12, Lorong Seri Fantasi 2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60109302676');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, '1077 Paw Villa', '601155036396', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); 40E, Lor Nanas Barat 4; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601155036396');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'PM Cat Hotel', '60102988530', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); MJC, Ch203; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60102988530');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'fyz smart enterprise', '60198114498', 'cat_hotel', 'Ampang, Selangor', 'Selangor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); no 18 ground floor jalan bunga tanjung 8a taman muda ampang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60198114498');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Local Pet Sitters Johor', '60177748177', 'cat_hotel', 'Austin Heights / Tebrau, JB', 'Johor', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', '99, Jalan Harmoni 1/1; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60177748177');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'cat boarding kupang kedah', '60168331894', 'cat_hotel', 'Sungai Petani, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Taman Desa Chempa; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60168331894');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Bella cattery house', '601111495837', 'cat_hotel', 'Sungai Petani, Kedah', 'Kedah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', '130, Jln Sp Heights 5; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111495837');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Beauty Cat House', '60139608725', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'LOT-1830-B, Jalan Sekolah Lundang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60139608725');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'CT CAT HOUZ CENTER', '60179080144', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', '90, Jalan Hospital; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60179080144');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Hotel Kucing Nik', '60189106479', 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'LOT 2402-A, 1177, Jalan Guchil Bayam; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60189106479');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Hotel & Makan Kucing', '60189804826', 'cat_hotel', 'Melaka City', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', '14, Jalan Seri Emas 18; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60189804826');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'FLUFFY RIZZCAT, GROOMING KUCING', '601155807783', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'MJ15, No.14; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601155807783');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cutie Q Pet House', '601126832332', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', '14, Jalan Rahmat 3A; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601126832332');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Famous Beast Cattery', '60107674628', 'cat_hotel', 'Krubong / Cheng, Melaka', 'Melaka', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Mb-1-31, Jalan Sb Utama; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60107674628');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pippy House Penang (home based pet boarding and pet grooming service)', '60126181397', 'cat_hotel', 'Air Itam / Paya Terubong, Penang', 'Penang', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', '52, Jln Tembaga; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60126181397');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pawtato.kk', '60182728128', 'cat_hotel', 'Kota Kinabalu', 'Sabah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Lorong Pokok Resam 1 Taman BDC; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60182728128');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Nur Grooming&Boarding', '60102035898', 'cat_hotel', 'Menggatal / Inanam, Kota Kinabalu', 'Sabah', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Jalan Suang Emboh; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60102035898');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Hotel (Malihah Square)', '601170058121', 'cat_hotel', 'Matang / Metrocity, Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'First Floor,Lot 8079(SL.14, Malihah Square Comm.Centre, Jalan Batu Kawa - Matang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601170058121');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Boarding SNF', '601116413827', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', '32, Lor Sim Kheng Hong Selatan 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601116413827');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pet boarding (Kampung Rembus)', '601119843743', 'cat_hotel', 'Kota Samarahan, Sarawak', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Jalan Kampung Rembus; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601119843743');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Neko Neko', '60128568690', 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'P Residence, Jalan Batu Kawa; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60128568690');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Print house cat rumah Sdn bhd', '60146459388', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Jalan maju utama taman lembah maju; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60146459388');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pick A Meow', '60124828321', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'M28, Mezzanine Floor, Ampang Point Shopping Centre, Jln Memanda 3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60124828321');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Fur Seasons Cat Hotel Ampang', '60125655802', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'A, Jalan Kolam Air Lama; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60125655802');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'MIRDOZA CAT HOUSE (Homebased Cat Services)', '601111119030', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', 'Nombor 10, Taman Nur Bakti, 1528, Jln Kuala Berang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111119030');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'sWAn pEts sErvis', '60145464748', 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'A', 'new', 'cathotel', '81B, Jalan Sekolah; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60145464748');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Dog''s Papa & Cat''s Mama Pet Store', NULL, 'cat_hotel', 'George Town, Penang', 'Penang', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 4.9 (319 reviews); 117-H, Jln Tan Sri Teh Ewe Lim, Jelutong; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Dog''s Papa & Cat''s Mama Pet Store');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kitty Cat Pet Centre', NULL, 'cat_hotel', 'Klebang / Chemor, Ipoh', 'Perak', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 4.4 (262 reviews); 24, Jalan Sci 1/3; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Kitty Cat Pet Centre');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pusak pethouse grooming & hotel kucing', NULL, 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 4.9 (161 reviews); Jalan Abdul Kadir Adabi; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Pusak pethouse grooming & hotel kucing');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Qiqi Pet House (Padang Midin)', NULL, 'cat_hotel', 'Kuala Terengganu', 'Terengganu', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 4.4 (148 reviews); No 2, lot 1658, Taman Padang Midin; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Qiqi Pet House (Padang Midin)');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kopicatz Penang', NULL, 'cat_hotel', 'Bayan Lepas / Bayan Baru, Penang', 'Penang', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 4.3 (143 reviews); No 34 20E, Jalan Tun Dr Awang; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Kopicatz Penang');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'RJ Cats Motel & Spa', NULL, 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 4.9 (125 reviews); LOT PT 836, TINGKAT BAWAH, WISMA BAKTY SEKSYEN, 48, Jln Tok Guru; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'RJ Cats Motel & Spa');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Little Paws Daily Hotel', NULL, 'cat_hotel', 'Bayan Lepas / Bayan Baru, Penang', 'Penang', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 5.0 (115 reviews); 35-2-6, Golden Triangle 2 Commercial Square, Jalan Dato Ismail Hashim; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Little Paws Daily Hotel');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kingfisher Pet House', NULL, 'cat_hotel', 'Menggatal / Inanam, Kota Kinabalu', 'Sabah', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 4.3 (83 reviews); 24-0, Plaza Kingfisher 5, Jalan Bangka Bangka; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Kingfisher Pet House');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Denzel''s Pet Home', NULL, 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 5.0 (43 reviews); 2768, Jalan Alor Akar; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Denzel''s Pet Home');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pet Haus KK', NULL, 'cat_hotel', 'Putatan, Kota Kinabalu', 'Sabah', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 4.4 (37 reviews); Lot 2-1, Block H, Lorong Grand Plaza Putatan 5, Grand Plaza Putatan; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Pet Haus KK');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Furbulous Hotel', NULL, 'cat_hotel', 'Kepala Batas / Bertam, Penang', 'Penang', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 5.0 (24 reviews); No. 85 Tingkat, 1, Persiaran Seksyen 4/7; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Furbulous Hotel');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'SHAFIQ CAT SPA & HOTEL', NULL, 'cat_hotel', 'Kuantan', 'Pahang', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 4.6 (15 reviews); A-11, 28, Jalan Jaya Gading; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'SHAFIQ CAT SPA & HOTEL');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Ginger''s turf', NULL, 'cat_hotel', 'KLCC / Ampang, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 5.0 (13 reviews); 4, Jalan Doraisamy; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Ginger''s turf');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kedai kucing fluffy cattery', NULL, 'cat_hotel', 'Pengkalan / Lahat, Ipoh', 'Perak', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 4.7 (12 reviews); 11a, Medan Stesen 19/4; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Kedai kucing fluffy cattery');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Fluffy Cat House', NULL, 'cat_hotel', 'Johor Bahru', 'Johor', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 3.8 (10 reviews); 46, Jalan Cengkerik 5; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Fluffy Cat House');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Minnie & Co Pet Sitting Ipoh', NULL, 'cat_hotel', 'Batu Gajah / Kampar, Perak', 'Perak', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 5.0 (9 reviews); no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Minnie & Co Pet Sitting Ipoh');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Joya & Friends Pet Shop & Cat Hotel Kuching @Matang', NULL, 'cat_hotel', 'Matang / Metrocity, Kuching', 'Sarawak', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 5.0 (4 reviews); Lot 9738; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Joya & Friends Pet Shop & Cat Hotel Kuching @Matang');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pet Sitter / Boarding Afiyah (Kuala Lumpur)', NULL, 'cat_hotel', 'Mont Kiara / Sri Hartamas, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 5.0 (3 reviews); no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Pet Sitter / Boarding Afiyah (Kuala Lumpur)');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Annie''s Pet House', NULL, 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 4.5 (2 reviews); 246, Lorong Keranji 4f2; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Annie''s Pet House');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'CATZ NANNY (Kuching)', NULL, 'cat_hotel', 'Kuching', 'Sarawak', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 3.0 (2 reviews); Ground Floor, Lot 436, 11J, Jalan Rubber; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'CATZ NANNY (Kuching)');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Lovely Pet Boarding', NULL, 'cat_hotel', 'Air Itam / Paya Terubong, Penang', 'Penang', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); 93-1, Jalan Pisang Embun; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Lovely Pet Boarding');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Fluffy Cattery Kulim', NULL, 'cat_hotel', 'Kulim, Kedah', 'Kedah', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Fasa 2, 1655, Persiaran Utama 4; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Fluffy Cattery Kulim');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Celly cat house', NULL, 'cat_hotel', 'Kota Bharu', 'Kelantan', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'Cabang 3, Pengkalan Chepa; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Celly cat house');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Fey''s Pet Boarding KL', NULL, 'cat_hotel', 'Cheras / Sungai Besi, KL', 'Kuala Lumpur', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', '1, Jln Razak Mansion; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Fey''s Pet Boarding KL');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Ammar Paws Cat (House Of Fluffy)', NULL, 'cat_hotel', 'Balok / Beserah, Kuantan', 'Pahang', 'Google Maps listing', 'none', 'B', 'new', 'cathotel', 'No 17, Jln KS 10/9; no website on Google listing', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Ammar Paws Cat (House Of Fluffy)');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Meow hero Family | Premium Hotel & Grooming', '60173531017', 'cat_hotel', 'Batu Caves / Gombak', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (801 reviews); G-16, Kompleks Perniagaan selayang point, Jalan SP1', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60173531017');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'FURRYTEL Wangsa Maju - CAT HOTEL & GROOMING', '60182280085', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (480 reviews); KLSC, 35H, Jalan Wangsa Delima 5', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60182280085');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Furgather Destiny Pet House Puchong 宠遇店铺 - Pet Hotel , Grooming , DayCare , Boarding & Retail', '601153801668', 'cat_hotel', 'Puchong', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.7 (356 reviews); 57-2, Jalan Op1/2, Pusat Perdagangan One Puchong', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601153801668');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pet Universe Starlux (Pet Hotel, Boarding and Grooming)', '60127325563', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.8 (301 reviews); Level 4 & Level 6, 30, Jalan Sulaiman 1', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60127325563');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Furkids & Friends Pet Hotel', '60195257970', 'cat_hotel', 'Kota Damansara', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (295 reviews); 15, Jalan PJU 5/20a', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60195257970');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Fluffy Family Pet Boarding and Hotel', '601137976657', 'cat_hotel', 'Kota Damansara', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (199 reviews); 5A, 6, Jln PJU 10/5A', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601137976657');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'G-Pet Boarding & Training Centre', '60122313183', 'cat_hotel', 'Puchong', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.4 (199 reviews); Jalan Kota Raja A 27/A', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60122313183');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'KatzGroomer - Grooming, Boarding, Mating Cat Cheras', '60162010650', 'cat_hotel', 'Seri Kembangan', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.7 (185 reviews); 12-B, Jalan Suadamai 1/2 Tun Hussein Onn', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60162010650');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Setapak Cats House - Cat Hotel, Cat Boarding, Cat Grooming, Cat Sitter & Cat delivery Kuala Lumpur', '601110670654', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.7 (183 reviews); 21-1, Jalan 9/23e', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601110670654');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Patty''s Pet Hotel', '60168150190', 'cat_hotel', 'Batu Caves / Gombak', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (177 reviews); 23b, Jln Ipoh', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60168150190');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Kitty Pets Hotel: Cat Boarding and Cat Grooming', '60143674949', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.6 (163 reviews); NO; 5 Level, 1, Jalan 3/1', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60143674949');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Meowcasa Boutique Cat Hotel & Spa', '60192373609', 'cat_hotel', 'Mont Kiara / Sri Hartamas, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (162 reviews); Block H-G-10, Boulevard Business Park, Jalan Matang, 3, Jln Kuching', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60192373609');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Catzville Cat Hotel and Grooming', '60125653193', 'cat_hotel', 'Kota Damansara', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (158 reviews); 40-G,Jalan Pju 5/20D,The Strand', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60125653193');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Leo & Friends Pet Hotel', '60122351083', 'cat_hotel', 'Kota Damansara', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.8 (147 reviews); 23, Jalan PJU 3/41', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60122351083');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'The Cat Hotel PJ', '60148188015', 'cat_hotel', 'Kota Damansara', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.7 (145 reviews); No. 11-G, Street Wing, Sunsuria Avenue Persiaran Mahogani, Kota Damansara', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60148188015');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Chino & Apex Pet Space Cabin – Pet Hotel & Dog Boarding in KL', '601126886328', 'cat_hotel', 'Mont Kiara / Sri Hartamas, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.8 (140 reviews); Block G-M-7, Perdana, Plaza Arkadia, Jalan Intisari', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601126886328');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Moment Boutique Hotel & Spa', '601113280280', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (138 reviews); B1-12, Arc @ Ampang Ukay, Persiaran Ampang Ukay', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601113280280');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'FURRYTEL Ampang - CAT HOTEL & GROOMING', '60183800085', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (118 reviews); B2-G, Jalan Selaman 1', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60183800085');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Papa Zou Pawville: Cat Hotel and Cat Grooming Ampang/Kuala Lumpur', '60169965153', 'cat_hotel', 'Ampang, Selangor', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (107 reviews); 48, Jalan Bunga Tanjung 9', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60169965153');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Grumpy Dog Hotel', '601128886260', 'cat_hotel', 'Mont Kiara / Sri Hartamas, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (105 reviews); 4-1-8, Kompleks Kantonmen Prima, 698, Jln Ipoh', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601128886260');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cocomomo Urban Pets Hotel', '60379720855', 'cat_hotel', 'Bangsar / Pantai, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.2 (98 reviews); 139, Indah UPC Business Centre, 3 1/2 Miles', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60379720855');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'UniPets Boarding & Daycare | Bukit Jalil Pet Hotel', '60196982238', 'cat_hotel', 'Seri Kembangan', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (97 reviews); Bumi, 82-2, Jalan Jalil 1, Lebuhraya Puchong Sg Besi', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60196982238');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'The Tails Zone - Cat Hotel - Boarding & Grooming', '60104650806', 'cat_hotel', 'Kuchai Lama / OUG, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (97 reviews); 21, Jalan Datuk Haji 1', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60104650806');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, '90 Meow Hotel & Spa Alam Damai', '60103917522', 'cat_hotel', 'Seri Kembangan', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (93 reviews); 73, Jln Damai Raya 6', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60103917522');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Beandpaws Cat Hotel & Cat Spa', '601119856939', 'cat_hotel', 'Cheras / Sungai Besi, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (87 reviews); D - 1 - 37 Block D1 Razak City Residences Jalan Razak Mansion, Jln Sungai Besi', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601119856939');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cat Tales Hotel', '60323830221', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (86 reviews); 1A, Jalan Memanda 7', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60323830221');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'The Paws Hotel', '60178079790', 'cat_hotel', 'KLCC / Ampang, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (79 reviews); 2-1, Jln Gurney', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60178079790');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'RawRaw Cat Hotel', '601111560123', 'cat_hotel', 'Puchong', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.7 (78 reviews); Blok D-02, 06, Jalan PPK 2', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601111560123');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Izzlisha Majesty - Cat Cafe, Cat Supplies, Cat Hotel & Spa', '60169004288', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (72 reviews); 1-1, Jalan 5/76b', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60169004288');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Swirly and Friends - Pet Hotel and Pet Boarding Subang Jaya', '60162820549', 'cat_hotel', 'Subang Jaya / USJ', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (72 reviews); ', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60162820549');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Meow Cat Oasis - Spa kucing dan Hotel', '60186249057', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (63 reviews); 29-1, Blok A Plaza, Seksyen 10, Jalan Maju Ria 1', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60186249057');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paws Season Hotel', '60169449434', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (61 reviews); 56, Jalan Usahawan 7', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60169449434');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'YaBu Pet Boarding & Grooming', '601127183306', 'cat_hotel', 'Kuchai Lama / OUG, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.7 (60 reviews); 3-2, Jalan 1/109E, Desa Business Park', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601127183306');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Doggy School Bus Hartamas (Dog Boarding, Daycare & More)', '60176158157', 'cat_hotel', 'Mont Kiara / Sri Hartamas, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (60 reviews); Plaza Crystalville 1, 31G, Jalan 22a/70a', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60176158157');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Pawprint Paradise Cat Hotel & Spa Petaling Jaya', '601121466905', 'cat_hotel', 'Bangsar / Pantai, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (49 reviews); 2nd Floor, 8A, 3, Jalan 14/20', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601121466905');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Five Paws Cat Hotel & SPA', '60149739878', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (46 reviews); 1-2B, Level 2, Ukay Boulevard, Jln Lingkaran Tengah 2', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60149739878');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Mochichi&Didi Pet Shop Pet Hotel Pet Boarding', '601126191891', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (45 reviews); Pandan Prima, 1-21, Jalan Pandan Prima 1', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601126191891');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'XM Cat Hotel', '60162424809', 'cat_hotel', 'KLCC / Ampang, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.4 (42 reviews); 22-2, Jalan Setiawangsa 8', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60162424809');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Lana & Louie Suites', '60123841385', 'cat_hotel', 'Kuala Lumpur', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (40 reviews); 126, Lrg Maarof', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60123841385');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Charles''s Pet Suite - Pet Boarding x Training | 狗狗寄宿x训练', '601110717028', 'cat_hotel', 'Seri Kembangan', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.7 (34 reviews); 7, Jalan Taming Kiri 10', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601110717028');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Hx Pets Boarding', '60122547761', 'cat_hotel', 'Cheras / Sungai Besi, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (30 reviews); 012-254 7761', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60122547761');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'MiMo Pet Hotel', '60102157224', 'cat_hotel', 'Batu Caves / Gombak', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (30 reviews); 19, Jalan Ambong Kanan 1', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60102157224');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paws and Purrs Pet Hotel', '60125911941', 'cat_hotel', 'Bangsar / Pantai, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (30 reviews); Lot 1-65, 289, Jln Klang Lama', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60125911941');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paw Nest Pet Hotel', '601120929086', 'cat_hotel', 'Batu Caves / Gombak', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (29 reviews); PS-UG-03, Lakeville Residences, 68100, Jalan Sibu', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601120929086');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'CATmatic Hotel & Spa', '60148762978', 'cat_hotel', 'KLCC / Ampang, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (26 reviews); Tingkat 2, 1-2f, Jalan Au1a/4e', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60148762978');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Meow & Woo Pet Hotel', '60167025768', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.8 (19 reviews); No.126-2-9 (Second Floor, Metro 126, Jalan Genting Kelang', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60167025768');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'MUU Cat Hotel', '601162828033', 'cat_hotel', 'Ampang, Selangor', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.7 (13 reviews); 31A, Jalan Bunga Tanjung 6a', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601162828033');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, '306 Paws House (Daycare & Boarding House)', '60102342896', 'cat_hotel', 'Kuchai Lama / OUG, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (13 reviews); 306, Jln Sepakat 8', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60102342896');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'HoMEOWner Cat Hotel', '60135026393', 'cat_hotel', 'Kajang', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (13 reviews); 29-1, Jalan Temenggung 11/9', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60135026393');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Scruffee | Doggy Daycare & Hotel', '601121428434', 'cat_hotel', 'Kuchai Lama / OUG, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.7 (12 reviews); 1-G-1, Desa Green Serviced Apartments, Jalan Desa Bakti', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601121428434');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Cheras Baru Cat Homestay', '60129785085', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (9 reviews); 8, Jalan 28 A', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60129785085');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Miawjikan Cat Boarding & Sitting', '601162868791', 'cat_hotel', 'Ampang, Selangor', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 4.9 (8 reviews); Flat', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601162868791');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Hotel Kucing RM10 Caw Ampang', '601159215414', 'cat_hotel', 'Ampang, Selangor', 'Selangor', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (8 reviews); Lot 142, Lorong Permai 8', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601159215414');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Paws and Pillows Boarding', '601160834583', 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 3.5 (2 reviews); Jalan 5/23e', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '601160834583');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Shamie Cat Boarding', '60197099586', 'cat_hotel', 'Pandan / Maluri, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'INDAH CEMPAKA APARTMENT', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60197099586');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Fluffy Private Pet Boarding Service', NULL, 'cat_hotel', 'Setapak / Wangsa Maju, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (48 reviews); Block A, Sentul Point Apartment Suite', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Fluffy Private Pet Boarding Service');
INSERT INTO `marketing_prospects` (`site_id`, `name`, `phone`, `category`, `area`, `state`, `channel`, `website`, `priority`, `status`, `demo_slug`, `notes`, `created_at`, `updated_at`)
SELECT `s`.`id`, 'Meow Homestay', NULL, 'cat_hotel', 'Bangsar / Pantai, KL', 'Kuala Lumpur', 'Google Maps listing', 'has_site', 'C', 'new', 'cathotel', 'Google rating 5.0 (1 reviews); Jalan Kerinchi Kiri 2, Bangsar South 59200 Kuala Lumpur, Wilayah Persekutuan Kuala Lumpur Kuala', UTC_TIMESTAMP(), UTC_TIMESTAMP()
FROM `sites` AS `s` JOIN `clients` AS `c` ON `c`.`id` = `s`.`client_id`
WHERE `c`.`client_code` = 'marketing'
 AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` IS NULL AND `p`.`name` = 'Meow Homestay');
-- 382 statement(s)
