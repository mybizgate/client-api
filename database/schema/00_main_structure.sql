/*M!999999\- enable the sandbox mode */ 
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
DROP TABLE IF EXISTS `cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` bigint(20) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `cache_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` bigint(20) NOT NULL,
  PRIMARY KEY (`key`),
  KEY `cache_locks_expiration_index` (`expiration`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `clients`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
  CONSTRAINT `clients_client_code_format` CHECK (`client_code` collate utf8mb4_bin regexp '^[a-z0-9-]{2,50}$')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `failed_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `failed_jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `uuid` varchar(255) NOT NULL,
  `connection` varchar(255) NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`),
  KEY `failed_jobs_connection_queue_failed_at_index` (`connection`,`queue`,`failed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `job_batches`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `jobs` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` smallint(5) unsigned NOT NULL,
  `reserved_at` int(10) unsigned DEFAULT NULL,
  `available_at` int(10) unsigned NOT NULL,
  `created_at` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `jobs_queue_index` (`queue`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `media_attachments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `media_attachments` (
  `id` char(26) NOT NULL,
  `tenant_id` varchar(64) NOT NULL,
  `entity_type` varchar(48) NOT NULL,
  `entity_id` varchar(64) NOT NULL,
  `media_id` char(26) NOT NULL,
  `role` varchar(40) NOT NULL DEFAULT 'attachment',
  `slot` varchar(40) DEFAULT NULL,
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ma_entity_media_role_unique` (`tenant_id`,`entity_type`,`entity_id`,`media_id`,`role`),
  UNIQUE KEY `ma_one_per_slot` (`tenant_id`,`entity_type`,`entity_id`,`slot`),
  KEY `ma_lookup` (`tenant_id`,`entity_type`,`entity_id`,`role`,`sort_order`),
  KEY `ma_media_lookup` (`tenant_id`,`media_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `user_id` bigint(20) unsigned NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime NOT NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `password_reset_tokens_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
  CONSTRAINT `payments_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`),
  CONSTRAINT `payments_payment_type_check` CHECK (`payment_type` in ('registration','renewal')),
  CONSTRAINT `payments_status_check` CHECK (`status` in ('pending','paid','rejected')),
  CONSTRAINT `payments_amount_check` CHECK (`amount` >= 0),
  CONSTRAINT `payments_period_check` CHECK (`period_end` >= `period_start`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `personal_access_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sample`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sample` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(150) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sample_is_active_created_at_index` (`is_active`,`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) unsigned DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sessions_user_id_index` (`user_id`),
  KEY `sessions_last_activity_index` (`last_activity`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `shop_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_categories` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal category identifier; exposed to the frontend as Category.id (string).',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that owns the category.',
  `parent_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Parent category in the same site; NULL identifies a top-level category. The current screens render a flat list.',
  `name` varchar(150) NOT NULL COMMENT 'Customer-facing category name.',
  `slug` varchar(180) NOT NULL COMMENT 'URL-safe category identifier unique within the site; used by the /category/{slug} route.',
  `description` text DEFAULT NULL COMMENT 'Optional category description displayed in the catalogue.',
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Ascending display position among sibling categories.',
  `status` varchar(20) NOT NULL DEFAULT 'draft' COMMENT 'Publication state: draft, active, or archived. Only active categories are returned to customers.',
  `created_by_user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Owner or staff user who created the category.',
  `updated_by_user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Owner or staff user who most recently updated the category.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the category was created.',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the category was last updated.',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT 'Soft-deletion time; NULL means the category has not been deleted.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_categories_site_slug_unique` (`site_id`,`slug`),
  UNIQUE KEY `shop_categories_site_id_unique` (`site_id`,`id`),
  KEY `shop_categories_browse_index` (`site_id`,`status`,`parent_id`,`sort_order`),
  KEY `shop_categories_parent_fk` (`site_id`,`parent_id`),
  KEY `shop_categories_created_by_fk` (`site_id`,`created_by_user_id`),
  KEY `shop_categories_updated_by_fk` (`site_id`,`updated_by_user_id`),
  CONSTRAINT `shop_categories_created_by_fk` FOREIGN KEY (`site_id`, `created_by_user_id`) REFERENCES `users` (`site_id`, `id`),
  CONSTRAINT `shop_categories_parent_fk` FOREIGN KEY (`site_id`, `parent_id`) REFERENCES `shop_categories` (`site_id`, `id`),
  CONSTRAINT `shop_categories_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shop_categories_updated_by_fk` FOREIGN KEY (`site_id`, `updated_by_user_id`) REFERENCES `users` (`site_id`, `id`),
  CONSTRAINT `shop_categories_status_check` CHECK (`status` in ('draft','active','archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Catalogue categories owned by a site; parent_id allows a tree later.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `shop_customer_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_customer_profiles` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal shop customer profile identifier.',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant in which the customer profile exists.',
  `user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Authenticated customer user that owns this profile; NULL for a guest identified by guest_token_hash.',
  `guest_token_hash` char(64) DEFAULT NULL COMMENT 'SHA-256 hex of the bearer guest token issued to a browser without an account; NULL once the profile belongs to a user or the token is revoked.',
  `store_name` varchar(200) NOT NULL COMMENT 'Customer shop or company name used for wholesale orders (Customer.storeName).',
  `contact_name` varchar(150) NOT NULL COMMENT 'Primary person to contact for orders (Customer.contactName).',
  `phone` varchar(30) NOT NULL COMMENT 'Primary order contact telephone number (Customer.phone).',
  `address` text DEFAULT NULL COMMENT 'Free-text shop address as typed on the account screen (Customer.address); NULL or empty when not provided.',
  `last_seen_at` timestamp NULL DEFAULT NULL COMMENT 'Last time the guest token or user was used on a customer endpoint; supports cleanup of abandoned guest profiles.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the profile was created.',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the profile was last updated.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_customer_profiles_site_id_unique` (`site_id`,`id`),
  UNIQUE KEY `shop_customer_profiles_site_user_unique` (`site_id`,`user_id`),
  UNIQUE KEY `shop_customer_profiles_guest_token_unique` (`guest_token_hash`),
  CONSTRAINT `shop_customer_profiles_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shop_customer_profiles_user_fk` FOREIGN KEY (`site_id`, `user_id`) REFERENCES `users` (`site_id`, `id`) ON DELETE CASCADE,
  CONSTRAINT `shop_customer_profiles_identity_check` CHECK (`user_id` is not null or `guest_token_hash` is not null)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Shop customer identity (guest token or site user) with the store details shown on the account screen.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `shop_discount_tiers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_discount_tiers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal quantity discount tier identifier.',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that owns the discount tier.',
  `minimum_quantity` int(10) unsigned NOT NULL COMMENT 'Minimum whole quantity of one order line needed to qualify for this tier (QuantityDiscount.minQty).',
  `discount_basis_points` int(10) unsigned NOT NULL COMMENT 'Discount rate in basis points, where 200 means 2 percent (QuantityDiscount.rate x 10000).',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Whether the pricing engine may apply this tier.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the discount tier was created.',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the discount tier was last updated.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_discount_tiers_site_quantity_unique` (`site_id`,`minimum_quantity`),
  KEY `shop_discount_tiers_active_index` (`site_id`,`is_active`,`minimum_quantity`),
  CONSTRAINT `shop_discount_tiers_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shop_discount_tiers_quantity_check` CHECK (`minimum_quantity` > 1),
  CONSTRAINT `shop_discount_tiers_rate_check` CHECK (`discount_basis_points` > 0 and `discount_basis_points` <= 10000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Site-wide per-line quantity thresholds and percentage discounts used during shop pricing.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `shop_favourites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_favourites` (
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant in which the favourite exists.',
  `customer_profile_id` bigint(20) unsigned NOT NULL COMMENT 'Customer profile that saved the product.',
  `product_id` bigint(20) unsigned NOT NULL COMMENT 'Product saved by the customer.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the product was saved.',
  PRIMARY KEY (`site_id`,`customer_profile_id`,`product_id`),
  KEY `shop_favourites_product_index` (`site_id`,`product_id`),
  CONSTRAINT `shop_favourites_product_fk` FOREIGN KEY (`site_id`, `product_id`) REFERENCES `shop_products` (`site_id`, `id`) ON DELETE CASCADE,
  CONSTRAINT `shop_favourites_profile_fk` FOREIGN KEY (`site_id`, `customer_profile_id`) REFERENCES `shop_customer_profiles` (`site_id`, `id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Products saved as favourites by shop customers; deferred until favourites are synced to the server.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `shop_inventory_movements`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_inventory_movements` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal inventory movement identifier.',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that owns the inventory movement.',
  `product_id` bigint(20) unsigned NOT NULL COMMENT 'Product whose stock balance changed.',
  `order_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Related order when the movement was caused by an order confirmation or cancellation.',
  `movement_type` varchar(30) NOT NULL COMMENT 'Reason for the movement: opening, restock, sale, adjustment, return, or cancellation.',
  `quantity_delta` int(11) NOT NULL COMMENT 'Signed whole stock change in selling units; positive adds stock and negative removes stock.',
  `balance_after` int(10) unsigned NOT NULL COMMENT 'Product stock balance immediately after applying this movement.',
  `note` varchar(500) DEFAULT NULL COMMENT 'Optional explanation or external stock reference.',
  `created_by_user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'User who recorded the movement; NULL represents an automated system action.',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Date and time when the inventory movement was recorded.',
  PRIMARY KEY (`id`),
  KEY `shop_inventory_movements_product_index` (`site_id`,`product_id`,`created_at`),
  KEY `shop_inventory_movements_order_index` (`site_id`,`order_id`),
  KEY `shop_inventory_movements_user_fk` (`site_id`,`created_by_user_id`),
  CONSTRAINT `shop_inventory_movements_order_fk` FOREIGN KEY (`site_id`, `order_id`) REFERENCES `shop_orders` (`site_id`, `id`),
  CONSTRAINT `shop_inventory_movements_product_fk` FOREIGN KEY (`site_id`, `product_id`) REFERENCES `shop_products` (`site_id`, `id`),
  CONSTRAINT `shop_inventory_movements_user_fk` FOREIGN KEY (`site_id`, `created_by_user_id`) REFERENCES `users` (`site_id`, `id`),
  CONSTRAINT `shop_inventory_movements_type_check` CHECK (`movement_type` in ('opening','restock','sale','adjustment','return','cancellation')),
  CONSTRAINT `shop_inventory_movements_delta_check` CHECK (`quantity_delta` <> 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Append-only audit ledger for product stock changes in the shop domain.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `shop_order_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_order_items` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal order line identifier.',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that owns the order line.',
  `order_id` bigint(20) unsigned NOT NULL COMMENT 'Order header containing this line.',
  `line_number` int(10) unsigned NOT NULL COMMENT 'Stable one-based line position within the order.',
  `product_id` bigint(20) unsigned NOT NULL COMMENT 'Original product referenced by the order line (OrderItem.productId); its current image and packshot are read at display time.',
  `sku` varchar(80) DEFAULT NULL COMMENT 'Snapshot of the product SKU at order time.',
  `product_name` varchar(200) NOT NULL COMMENT 'Snapshot of the product name at order time (OrderItem.name).',
  `product_slug` varchar(220) NOT NULL COMMENT 'Snapshot of the product slug at order time (OrderItem.slug).',
  `selling_unit` varchar(50) NOT NULL COMMENT 'Snapshot of the wholesale selling unit at order time (OrderItem.unit).',
  `pack_quantity` int(10) unsigned NOT NULL COMMENT 'Snapshot of the retail pack count per selling unit (OrderItem.packQty).',
  `pack_size` varchar(50) NOT NULL COMMENT 'Snapshot of one retail pack size (OrderItem.size).',
  `quantity` int(10) unsigned NOT NULL COMMENT 'Whole number of wholesale selling units ordered (OrderItem.qty).',
  `base_price_minor` bigint(20) unsigned NOT NULL COMMENT 'Catalogue price per selling unit before quantity discount, in minor units (OrderItem.basePrice).',
  `unit_price_minor` bigint(20) unsigned NOT NULL COMMENT 'Actual price per selling unit after the applicable tier discount, in minor units (OrderItem.unitPrice).',
  `line_total_minor` bigint(20) unsigned NOT NULL COMMENT 'Recorded line total in minor units; always quantity x unit_price_minor.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the order line was created.',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the order line was last updated.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_order_items_order_line_unique` (`site_id`,`order_id`,`line_number`),
  KEY `shop_order_items_product_index` (`site_id`,`product_id`),
  CONSTRAINT `shop_order_items_order_fk` FOREIGN KEY (`site_id`, `order_id`) REFERENCES `shop_orders` (`site_id`, `id`) ON DELETE CASCADE,
  CONSTRAINT `shop_order_items_product_fk` FOREIGN KEY (`site_id`, `product_id`) REFERENCES `shop_products` (`site_id`, `id`),
  CONSTRAINT `shop_order_items_line_number_check` CHECK (`line_number` > 0),
  CONSTRAINT `shop_order_items_pack_quantity_check` CHECK (`pack_quantity` > 0),
  CONSTRAINT `shop_order_items_quantity_check` CHECK (`quantity` > 0),
  CONSTRAINT `shop_order_items_unit_price_check` CHECK (`unit_price_minor` <= `base_price_minor`),
  CONSTRAINT `shop_order_items_total_check` CHECK (`line_total_minor` = `quantity` * `unit_price_minor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Immutable product, pack, quantity, and pricing snapshots for shop order lines.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `shop_order_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_order_status_history` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal order status history identifier.',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that owns the status event.',
  `order_id` bigint(20) unsigned NOT NULL COMMENT 'Order whose status changed.',
  `status` varchar(30) NOT NULL COMMENT 'Order status recorded by this event (Order.history[].status).',
  `actor_type` varchar(20) NOT NULL DEFAULT 'system' COMMENT 'Who caused the change: customer (guest or user), staff (owner or staff user), or system.',
  `changed_by_user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Site user who caused the change when known; NULL for guest customers and automated actions.',
  `note` varchar(500) DEFAULT NULL COMMENT 'Optional explanation for the status change.',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp() COMMENT 'Date and time when the status event occurred (Order.history[].at).',
  PRIMARY KEY (`id`),
  KEY `shop_order_status_history_timeline_index` (`site_id`,`order_id`,`created_at`),
  KEY `shop_order_status_history_user_fk` (`site_id`,`changed_by_user_id`),
  CONSTRAINT `shop_order_status_history_order_fk` FOREIGN KEY (`site_id`, `order_id`) REFERENCES `shop_orders` (`site_id`, `id`) ON DELETE CASCADE,
  CONSTRAINT `shop_order_status_history_user_fk` FOREIGN KEY (`site_id`, `changed_by_user_id`) REFERENCES `users` (`site_id`, `id`),
  CONSTRAINT `shop_order_status_history_status_check` CHECK (`status` in ('draft_whatsapp','pending_review','confirmed','processing','delivered','completed','cancelled')),
  CONSTRAINT `shop_order_status_history_actor_check` CHECK (`actor_type` in ('customer','staff','system'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Chronological audit trail of shop order status changes.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `shop_orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_orders` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal order identifier; not exposed to the frontend.',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that received the order.',
  `reference_no` varchar(50) NOT NULL COMMENT 'Human-readable order reference unique within the site; exposed as Order.id, used in the /orders/{id} route and the WhatsApp message.',
  `customer_profile_id` bigint(20) unsigned NOT NULL COMMENT 'Customer profile (guest or user) that placed the order and may view or cancel it.',
  `status` varchar(30) NOT NULL DEFAULT 'draft_whatsapp' COMMENT 'Current order workflow status; one of the frontend OrderStatus values.',
  `source` varchar(20) NOT NULL DEFAULT 'web' COMMENT 'Channel that created the order: web, whatsapp, or backoffice.',
  `store_name` varchar(200) NOT NULL COMMENT 'Snapshot of the customer store or company name at order time.',
  `contact_name` varchar(150) NOT NULL COMMENT 'Snapshot of the customer contact name at order time.',
  `contact_phone` varchar(30) NOT NULL COMMENT 'Snapshot of the customer telephone number at order time.',
  `fulfilment_method` varchar(20) NOT NULL COMMENT 'Requested fulfilment method: delivery or pickup (Order.fulfilment).',
  `delivery_address` text DEFAULT NULL COMMENT 'Free-text delivery address snapshot (Order.customer.address); NULL is allowed for pickup.',
  `requested_date` date NOT NULL COMMENT 'Customer-requested delivery or pickup date, at least tomorrow at submission, subject to confirmation.',
  `payment_method_code` varchar(50) NOT NULL COMMENT 'Snapshot of the selected payment method code, resolved from the submitted label.',
  `payment_method_label` varchar(150) NOT NULL COMMENT 'Snapshot of the selected payment method label as submitted (Order.paymentMethod).',
  `currency` char(3) NOT NULL DEFAULT 'MYR' COMMENT 'ISO 4217 currency code used for all stored order amounts.',
  `subtotal_minor` bigint(20) unsigned NOT NULL COMMENT 'Sum of discounted order line totals before delivery in currency minor units (Order.subtotal).',
  `discount_minor` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Quantity-discount savings already reflected in subtotal_minor, stored for reporting only.',
  `delivery_fee_minor` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Estimated delivery charge in currency minor units (Order.deliveryFee).',
  `total_minor` bigint(20) unsigned NOT NULL COMMENT 'Recorded estimated total in currency minor units (Order.total); final price is confirmed by the supplier.',
  `notes` varchar(500) DEFAULT NULL COMMENT 'Optional customer notes submitted with the order; returned as an empty string when NULL.',
  `whatsapp_sent_at` timestamp NULL DEFAULT NULL COMMENT 'Time the customer marked the WhatsApp message as sent; this is not WhatsApp delivery verification.',
  `confirmed_at` timestamp NULL DEFAULT NULL COMMENT 'Time an owner or staff user confirmed the order.',
  `completed_at` timestamp NULL DEFAULT NULL COMMENT 'Time the order reached the completed state.',
  `cancelled_at` timestamp NULL DEFAULT NULL COMMENT 'Time the order was cancelled by the customer or the supplier.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the order was created (Order.createdAt).',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the order was last updated.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_orders_site_reference_unique` (`site_id`,`reference_no`),
  UNIQUE KEY `shop_orders_site_id_unique` (`site_id`,`id`),
  KEY `shop_orders_customer_index` (`site_id`,`customer_profile_id`,`created_at`),
  KEY `shop_orders_management_index` (`site_id`,`status`,`created_at`),
  CONSTRAINT `shop_orders_customer_fk` FOREIGN KEY (`site_id`, `customer_profile_id`) REFERENCES `shop_customer_profiles` (`site_id`, `id`),
  CONSTRAINT `shop_orders_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`),
  CONSTRAINT `shop_orders_status_check` CHECK (`status` in ('draft_whatsapp','pending_review','confirmed','processing','delivered','completed','cancelled')),
  CONSTRAINT `shop_orders_source_check` CHECK (`source` in ('web','whatsapp','backoffice')),
  CONSTRAINT `shop_orders_fulfilment_check` CHECK (`fulfilment_method` in ('delivery','pickup')),
  CONSTRAINT `shop_orders_address_check` CHECK (`fulfilment_method` = 'pickup' or `delivery_address` is not null),
  CONSTRAINT `shop_orders_amount_check` CHECK (`total_minor` = `subtotal_minor` + `delivery_fee_minor`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Shop order headers containing customer snapshots, workflow status, and monetary totals.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `shop_payment_methods`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_payment_methods` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal checkout payment method identifier.',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that offers the payment method.',
  `code` varchar(50) NOT NULL COMMENT 'Stable machine-readable payment method code, for example cod or bank_transfer.',
  `label` varchar(150) NOT NULL COMMENT 'Customer-facing label; this exact string is what checkout sends as paymentMethod, so it must be unique within the site.',
  `instructions` text DEFAULT NULL COMMENT 'Optional instructions displayed after the customer selects this method.',
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Ascending display position at checkout.',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Whether customers may currently select this payment method.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the payment method was created.',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the payment method was last updated.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_payment_methods_site_code_unique` (`site_id`,`code`),
  UNIQUE KEY `shop_payment_methods_site_label_unique` (`site_id`,`label`),
  KEY `shop_payment_methods_display_index` (`site_id`,`is_active`,`sort_order`),
  CONSTRAINT `shop_payment_methods_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Payment choices offered by a site during shop checkout.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `shop_products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_products` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal product identifier; exposed to the frontend as Product.id (string) and used as the media_attachments entity_id.',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that owns the product.',
  `category_id` bigint(20) unsigned NOT NULL COMMENT 'Category containing the product (Product.categoryId).',
  `sku` varchar(80) DEFAULT NULL COMMENT 'Optional stock keeping unit unique within the site; shown on the product screen and searchable.',
  `name` varchar(200) NOT NULL COMMENT 'Customer-facing product name.',
  `slug` varchar(220) NOT NULL COMMENT 'URL-safe product identifier unique within the site; used by the /product/{slug} route.',
  `short_description` varchar(500) DEFAULT NULL COMMENT 'Short summary for catalogue cards or search results; not displayed by the current screens.',
  `description` longtext DEFAULT NULL COMMENT 'Full product description shown on the product detail screen.',
  `brand` varchar(150) DEFAULT NULL COMMENT 'Product manufacturer or brand name; shown and searchable.',
  `selling_unit` varchar(50) NOT NULL COMMENT 'Wholesale selling unit such as karton or guni (Product.unit).',
  `pack_quantity` int(10) unsigned NOT NULL DEFAULT 1 COMMENT 'Number of retail packs contained in one selling unit (Product.packQty).',
  `pack_size` varchar(50) NOT NULL COMMENT 'Display size of one retail pack, for example 1kg or 650ml (Product.size).',
  `selling_price_minor` bigint(20) unsigned NOT NULL COMMENT 'Current price for one selling unit in currency minor units (Product.price).',
  `compare_at_price_minor` bigint(20) unsigned DEFAULT NULL COMMENT 'Previous price in minor units used to display a promotion (Product.oldPrice); NULL means no promotion.',
  `minimum_order_quantity` int(10) unsigned NOT NULL DEFAULT 1 COMMENT 'Smallest whole number of selling units allowed per order line (Product.minimumQuantity).',
  `stock_quantity` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Current available stock in whole selling units (Product.stock); ignored when unlimited_stock is 1.',
  `unlimited_stock` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Per-product switch: 1 means the product can always be ordered in any quantity, the API returns stock null and no inventory movements are recorded.',
  `low_stock_threshold` int(10) unsigned NOT NULL DEFAULT 10 COMMENT 'Stock level below which the API reports stockStatus low.',
  `sort_order` int(10) unsigned NOT NULL DEFAULT 0 COMMENT 'Ascending catalogue position used by the default "popular" sort.',
  `is_featured` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Whether the product appears in the home hero artwork and featured sections (Product.featured).',
  `status` varchar(20) NOT NULL DEFAULT 'draft' COMMENT 'Publication state: draft, active, or archived. Only active products are returned to customers.',
  `placeholder_art_json` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Optional packshot configuration {shape,color,motif,label} (Product.art) used only when no product image is attached.' CHECK (json_valid(`placeholder_art_json`)),
  `published_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the product was first made publicly available.',
  `created_by_user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Owner or staff user who created the product.',
  `updated_by_user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Owner or staff user who most recently updated the product.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the product was created.',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the product was last updated (Product.updatedAt).',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT 'Soft-deletion time; NULL means the product has not been deleted. Order lines keep pointing at deleted products.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_products_site_slug_unique` (`site_id`,`slug`),
  UNIQUE KEY `shop_products_site_id_unique` (`site_id`,`id`),
  UNIQUE KEY `shop_products_site_sku_unique` (`site_id`,`sku`),
  KEY `shop_products_catalogue_index` (`site_id`,`status`,`category_id`,`sort_order`),
  KEY `shop_products_price_index` (`site_id`,`status`,`selling_price_minor`),
  KEY `shop_products_category_fk` (`site_id`,`category_id`),
  KEY `shop_products_created_by_fk` (`site_id`,`created_by_user_id`),
  KEY `shop_products_updated_by_fk` (`site_id`,`updated_by_user_id`),
  CONSTRAINT `shop_products_category_fk` FOREIGN KEY (`site_id`, `category_id`) REFERENCES `shop_categories` (`site_id`, `id`),
  CONSTRAINT `shop_products_created_by_fk` FOREIGN KEY (`site_id`, `created_by_user_id`) REFERENCES `users` (`site_id`, `id`),
  CONSTRAINT `shop_products_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shop_products_updated_by_fk` FOREIGN KEY (`site_id`, `updated_by_user_id`) REFERENCES `users` (`site_id`, `id`),
  CONSTRAINT `shop_products_status_check` CHECK (`status` in ('draft','active','archived')),
  CONSTRAINT `shop_products_pack_quantity_check` CHECK (`pack_quantity` > 0),
  CONSTRAINT `shop_products_price_check` CHECK (`selling_price_minor` >= 0),
  CONSTRAINT `shop_products_compare_price_check` CHECK (`compare_at_price_minor` is null or `compare_at_price_minor` > `selling_price_minor`),
  CONSTRAINT `shop_products_minimum_quantity_check` CHECK (`minimum_order_quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Products and current catalogue, pricing, pack, ranking, and stock information for a site.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `shop_settings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `shop_settings` (
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that owns these shop settings.',
  `currency` char(3) NOT NULL DEFAULT 'MYR' COMMENT 'ISO 4217 currency code used by the shop.',
  `minimum_order_minor` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Minimum discounted subtotal in currency minor units, such as sen, before an order is accepted.',
  `delivery_fee_minor` bigint(20) unsigned NOT NULL DEFAULT 0 COMMENT 'Default delivery fee in currency minor units.',
  `free_delivery_from_minor` bigint(20) unsigned DEFAULT NULL COMMENT 'Subtotal in minor units from which delivery becomes free; NULL disables the rule.',
  `allow_whatsapp_order` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Whether checkout may open a prepared WhatsApp order message.',
  `deduct_stock_on_confirm` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Owner switch: 1 deducts tracked product stock when an order is confirmed and restores it on cancellation; 0 leaves stock untouched by orders.',
  `reference_prefix` varchar(12) NOT NULL COMMENT 'Short prefix used when generating human-readable order references, for example LZ.',
  `next_order_number` bigint(20) unsigned NOT NULL DEFAULT 1 COMMENT 'Next sequence number reserved transactionally for an order reference.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the settings row was created.',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the settings row was last updated.',
  PRIMARY KEY (`site_id`),
  CONSTRAINT `shop_settings_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shop_settings_minimum_check` CHECK (`minimum_order_minor` >= 0),
  CONSTRAINT `shop_settings_delivery_check` CHECK (`delivery_fee_minor` >= 0),
  CONSTRAINT `shop_settings_free_delivery_check` CHECK (`free_delivery_from_minor` is null or `free_delivery_from_minor` >= 0),
  CONSTRAINT `shop_settings_next_order_check` CHECK (`next_order_number` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Site-level commercial and checkout settings for the shop domain.';
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `sites`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
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
  CONSTRAINT `sites_client_id_foreign` FOREIGN KEY (`client_id`) REFERENCES `clients` (`id`),
  CONSTRAINT `sites_domain_type_check` CHECK (`domain_type` in ('subdomain','custom')),
  CONSTRAINT `sites_site_type_check` CHECK (`site_type` in ('website','web_application')),
  CONSTRAINT `sites_status_check` CHECK (`status` in ('draft','active','expired','suspended')),
  CONSTRAINT `sites_billing_months_check` CHECK (`billing_months` > 0),
  CONSTRAINT `sites_prices_check` CHECK (`first_year_price` >= 0 and `renewal_price` >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `site_id` bigint(20) unsigned NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(30) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `last_login_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` varchar(20) NOT NULL DEFAULT 'customer',
  `status` varchar(20) NOT NULL DEFAULT 'active',
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `users_site_id_email_unique` (`site_id`,`email`),
  UNIQUE KEY `users_site_id_id_unique` (`site_id`,`id`),
  KEY `users_site_id_role_index` (`site_id`,`role`),
  CONSTRAINT `users_site_id_foreign` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`),
  CONSTRAINT `users_role_check` CHECK (`role` in ('owner','staff','customer')),
  CONSTRAINT `users_status_check` CHECK (`status` in ('active','disabled'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

/*M!999999\- enable the sandbox mode */ 
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (1,'0001_01_01_000000_create_users_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (2,'0001_01_01_000001_create_cache_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (3,'0001_01_01_000002_create_jobs_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (4,'2026_10_30_000000_create_media_attachments_table',1);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (5,'2026_10_30_000100_create_sample_table',2);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (6,'2026_10_31_000000_create_clients_table',3);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (7,'2026_10_31_000100_create_sites_table',3);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (8,'2026_10_31_000200_add_site_scope_to_users_table',3);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (9,'2026_10_31_000300_recreate_password_reset_tokens_table',3);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (10,'2026_10_31_000400_create_payments_table',3);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (11,'2026_10_31_022105_create_personal_access_tokens_table',3);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (12,'2026_10_31_100000_add_site_id_id_unique_to_users_table',4);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (13,'2026_10_31_100100_create_shop_settings_table',4);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (14,'2026_10_31_100200_create_shop_categories_table',4);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (15,'2026_10_31_100300_create_shop_products_table',4);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (16,'2026_10_31_100400_create_shop_discount_tiers_table',4);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (17,'2026_10_31_100500_create_shop_payment_methods_table',4);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (18,'2026_10_31_100600_create_shop_customer_profiles_table',4);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (19,'2026_10_31_100700_create_shop_orders_table',4);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (20,'2026_10_31_100800_create_shop_order_items_table',4);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (21,'2026_10_31_100900_create_shop_order_status_history_table',4);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (22,'2026_10_31_101000_create_shop_inventory_movements_table',4);
INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES (23,'2026_10_31_101100_create_shop_favourites_table',4);
