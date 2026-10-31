-- ---------------------------------------------------------------------------
-- MyBizGate Client API — shop schema (catalogue, pricing, customers, orders,
-- stock ledger) for the supplier frontend (clients/client-lzhub).
--
-- Task      : shop_schema            Date: 2026-10-31
-- Design    : ../../clients/client-lzhub/SHOP_DESIGN.md (revision 3, §6)
-- Migrations: database/migrations/2026_10_31_100000 … 101100 (names listed at
--             the end of this file; the Laravel migrations must use exactly
--             these names so `php artisan migrate` never re-runs them)
--
-- HOW TO APPLY (production, cPanel → phpMyAdmin → database → SQL tab):
--   1. Back up the database (Export) first.
--   2. Paste this whole file and press Go. Run it exactly once.
--   3. Then apply the client seed if this is the lzhub database:
--      ../../clients/client-lzhub/docs/shop/shop_seed_lzhub.sql
--   4. `curl .../api/v1/health` must still report "database": true.
--
-- Prerequisite: 00_main_structure.sql + 00_core_schema_2026-10-31.sql are
-- applied (clients, sites, users, migrations exist). No data is touched.
-- Generated from SHOP_DESIGN.md §6 by the design review; do not edit the
-- statements here without changing the design document first.
-- ---------------------------------------------------------------------------

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 1;

-- ---------------------------------------------------------------------------
-- 1. users — composite (site_id, id) unique key so shop_* tables can reference users tenant-safely
-- ---------------------------------------------------------------------------
ALTER TABLE `users`
  ADD UNIQUE KEY `users_site_id_id_unique` (`site_id`, `id`);

-- ---------------------------------------------------------------------------
-- 2. shop_settings — site-level commercial and checkout settings
-- ---------------------------------------------------------------------------
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
  CONSTRAINT `shop_settings_free_delivery_check` CHECK (`free_delivery_from_minor` IS NULL OR `free_delivery_from_minor` >= 0),
  CONSTRAINT `shop_settings_next_order_check` CHECK (`next_order_number` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Site-level commercial and checkout settings for the shop domain.';

-- ---------------------------------------------------------------------------
-- 3. shop_categories — catalogue categories
-- ---------------------------------------------------------------------------
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
  UNIQUE KEY `shop_categories_site_slug_unique` (`site_id`, `slug`),
  UNIQUE KEY `shop_categories_site_id_unique` (`site_id`, `id`),
  KEY `shop_categories_browse_index` (`site_id`, `status`, `parent_id`, `sort_order`),
  CONSTRAINT `shop_categories_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shop_categories_parent_fk` FOREIGN KEY (`site_id`, `parent_id`) REFERENCES `shop_categories` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_categories_created_by_fk` FOREIGN KEY (`site_id`, `created_by_user_id`) REFERENCES `users` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_categories_updated_by_fk` FOREIGN KEY (`site_id`, `updated_by_user_id`) REFERENCES `users` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_categories_status_check` CHECK (`status` IN ('draft', 'active', 'archived'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Catalogue categories owned by a site; parent_id allows a tree later.';

-- ---------------------------------------------------------------------------
-- 4. shop_products — products, pack, price, ranking and stock
-- ---------------------------------------------------------------------------
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
  `placeholder_art_json` json DEFAULT NULL COMMENT 'Optional packshot configuration {shape,color,motif,label} (Product.art) used only when no product image is attached.',
  `published_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the product was first made publicly available.',
  `created_by_user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Owner or staff user who created the product.',
  `updated_by_user_id` bigint(20) unsigned DEFAULT NULL COMMENT 'Owner or staff user who most recently updated the product.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the product was created.',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the product was last updated (Product.updatedAt).',
  `deleted_at` timestamp NULL DEFAULT NULL COMMENT 'Soft-deletion time; NULL means the product has not been deleted. Order lines keep pointing at deleted products.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_products_site_slug_unique` (`site_id`, `slug`),
  UNIQUE KEY `shop_products_site_sku_unique` (`site_id`, `sku`),
  UNIQUE KEY `shop_products_site_id_unique` (`site_id`, `id`),
  KEY `shop_products_catalogue_index` (`site_id`, `status`, `category_id`, `sort_order`),
  KEY `shop_products_price_index` (`site_id`, `status`, `selling_price_minor`),
  CONSTRAINT `shop_products_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shop_products_category_fk` FOREIGN KEY (`site_id`, `category_id`) REFERENCES `shop_categories` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_products_created_by_fk` FOREIGN KEY (`site_id`, `created_by_user_id`) REFERENCES `users` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_products_updated_by_fk` FOREIGN KEY (`site_id`, `updated_by_user_id`) REFERENCES `users` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_products_status_check` CHECK (`status` IN ('draft', 'active', 'archived')),
  CONSTRAINT `shop_products_pack_quantity_check` CHECK (`pack_quantity` > 0),
  CONSTRAINT `shop_products_price_check` CHECK (`selling_price_minor` >= 0),
  CONSTRAINT `shop_products_compare_price_check` CHECK (`compare_at_price_minor` IS NULL OR `compare_at_price_minor` > `selling_price_minor`),
  CONSTRAINT `shop_products_minimum_quantity_check` CHECK (`minimum_order_quantity` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Products and current catalogue, pricing, pack, ranking, and stock information for a site.';

-- ---------------------------------------------------------------------------
-- 5. shop_discount_tiers — site-wide quantity discounts
-- ---------------------------------------------------------------------------
CREATE TABLE `shop_discount_tiers` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Internal quantity discount tier identifier.',
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant that owns the discount tier.',
  `minimum_quantity` int(10) unsigned NOT NULL COMMENT 'Minimum whole quantity of one order line needed to qualify for this tier (QuantityDiscount.minQty).',
  `discount_basis_points` int(10) unsigned NOT NULL COMMENT 'Discount rate in basis points, where 200 means 2 percent (QuantityDiscount.rate x 10000).',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Whether the pricing engine may apply this tier.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the discount tier was created.',
  `updated_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the discount tier was last updated.',
  PRIMARY KEY (`id`),
  UNIQUE KEY `shop_discount_tiers_site_quantity_unique` (`site_id`, `minimum_quantity`),
  KEY `shop_discount_tiers_active_index` (`site_id`, `is_active`, `minimum_quantity`),
  CONSTRAINT `shop_discount_tiers_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shop_discount_tiers_quantity_check` CHECK (`minimum_quantity` > 1),
  CONSTRAINT `shop_discount_tiers_rate_check` CHECK (`discount_basis_points` > 0 AND `discount_basis_points` <= 10000)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Site-wide per-line quantity thresholds and percentage discounts used during shop pricing.';

-- ---------------------------------------------------------------------------
-- 6. shop_payment_methods — checkout payment choices (label is what checkout sends)
-- ---------------------------------------------------------------------------
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
  UNIQUE KEY `shop_payment_methods_site_code_unique` (`site_id`, `code`),
  UNIQUE KEY `shop_payment_methods_site_label_unique` (`site_id`, `label`),
  KEY `shop_payment_methods_display_index` (`site_id`, `is_active`, `sort_order`),
  CONSTRAINT `shop_payment_methods_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Payment choices offered by a site during shop checkout.';

-- ---------------------------------------------------------------------------
-- 7. shop_customer_profiles — guest-token or user-owned customer identity
-- ---------------------------------------------------------------------------
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
  UNIQUE KEY `shop_customer_profiles_site_user_unique` (`site_id`, `user_id`),
  UNIQUE KEY `shop_customer_profiles_guest_token_unique` (`guest_token_hash`),
  UNIQUE KEY `shop_customer_profiles_site_id_unique` (`site_id`, `id`),
  CONSTRAINT `shop_customer_profiles_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shop_customer_profiles_user_fk` FOREIGN KEY (`site_id`, `user_id`) REFERENCES `users` (`site_id`, `id`) ON DELETE CASCADE,
  CONSTRAINT `shop_customer_profiles_identity_check` CHECK (`user_id` IS NOT NULL OR `guest_token_hash` IS NOT NULL)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Shop customer identity (guest token or site user) with the store details shown on the account screen.';

-- ---------------------------------------------------------------------------
-- 8. shop_orders — order headers (reference_no is Order.id)
-- ---------------------------------------------------------------------------
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
  UNIQUE KEY `shop_orders_site_reference_unique` (`site_id`, `reference_no`),
  UNIQUE KEY `shop_orders_site_id_unique` (`site_id`, `id`),
  KEY `shop_orders_customer_index` (`site_id`, `customer_profile_id`, `created_at`),
  KEY `shop_orders_management_index` (`site_id`, `status`, `created_at`),
  CONSTRAINT `shop_orders_site_fk` FOREIGN KEY (`site_id`) REFERENCES `sites` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_orders_customer_fk` FOREIGN KEY (`site_id`, `customer_profile_id`) REFERENCES `shop_customer_profiles` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_orders_status_check` CHECK (`status` IN ('draft_whatsapp', 'pending_review', 'confirmed', 'processing', 'delivered', 'completed', 'cancelled')),
  CONSTRAINT `shop_orders_source_check` CHECK (`source` IN ('web', 'whatsapp', 'backoffice')),
  CONSTRAINT `shop_orders_fulfilment_check` CHECK (`fulfilment_method` IN ('delivery', 'pickup')),
  CONSTRAINT `shop_orders_address_check` CHECK (`fulfilment_method` = 'pickup' OR `delivery_address` IS NOT NULL),
  CONSTRAINT `shop_orders_amount_check` CHECK (`total_minor` = (`subtotal_minor` + `delivery_fee_minor`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Shop order headers containing customer snapshots, workflow status, and monetary totals.';

-- ---------------------------------------------------------------------------
-- 9. shop_order_items — immutable priced order lines
-- ---------------------------------------------------------------------------
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
  UNIQUE KEY `shop_order_items_order_line_unique` (`site_id`, `order_id`, `line_number`),
  KEY `shop_order_items_product_index` (`site_id`, `product_id`),
  CONSTRAINT `shop_order_items_order_fk` FOREIGN KEY (`site_id`, `order_id`) REFERENCES `shop_orders` (`site_id`, `id`) ON DELETE CASCADE,
  CONSTRAINT `shop_order_items_product_fk` FOREIGN KEY (`site_id`, `product_id`) REFERENCES `shop_products` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_order_items_line_number_check` CHECK (`line_number` > 0),
  CONSTRAINT `shop_order_items_pack_quantity_check` CHECK (`pack_quantity` > 0),
  CONSTRAINT `shop_order_items_quantity_check` CHECK (`quantity` > 0),
  CONSTRAINT `shop_order_items_unit_price_check` CHECK (`unit_price_minor` <= `base_price_minor`),
  CONSTRAINT `shop_order_items_total_check` CHECK (`line_total_minor` = (`quantity` * `unit_price_minor`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Immutable product, pack, quantity, and pricing snapshots for shop order lines.';

-- ---------------------------------------------------------------------------
-- 10. shop_order_status_history — status audit trail
-- ---------------------------------------------------------------------------
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
  KEY `shop_order_status_history_timeline_index` (`site_id`, `order_id`, `created_at`),
  CONSTRAINT `shop_order_status_history_order_fk` FOREIGN KEY (`site_id`, `order_id`) REFERENCES `shop_orders` (`site_id`, `id`) ON DELETE CASCADE,
  CONSTRAINT `shop_order_status_history_user_fk` FOREIGN KEY (`site_id`, `changed_by_user_id`) REFERENCES `users` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_order_status_history_status_check` CHECK (`status` IN ('draft_whatsapp', 'pending_review', 'confirmed', 'processing', 'delivered', 'completed', 'cancelled')),
  CONSTRAINT `shop_order_status_history_actor_check` CHECK (`actor_type` IN ('customer', 'staff', 'system'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Chronological audit trail of shop order status changes.';

-- ---------------------------------------------------------------------------
-- 11. shop_inventory_movements — append-only stock ledger
-- ---------------------------------------------------------------------------
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
  KEY `shop_inventory_movements_product_index` (`site_id`, `product_id`, `created_at`),
  KEY `shop_inventory_movements_order_index` (`site_id`, `order_id`),
  CONSTRAINT `shop_inventory_movements_product_fk` FOREIGN KEY (`site_id`, `product_id`) REFERENCES `shop_products` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_inventory_movements_order_fk` FOREIGN KEY (`site_id`, `order_id`) REFERENCES `shop_orders` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_inventory_movements_user_fk` FOREIGN KEY (`site_id`, `created_by_user_id`) REFERENCES `users` (`site_id`, `id`) ON DELETE RESTRICT,
  CONSTRAINT `shop_inventory_movements_type_check` CHECK (`movement_type` IN ('opening', 'restock', 'sale', 'adjustment', 'return', 'cancellation')),
  CONSTRAINT `shop_inventory_movements_delta_check` CHECK (`quantity_delta` <> 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Append-only audit ledger for product stock changes in the shop domain.';

-- ---------------------------------------------------------------------------
-- 12. shop_favourites — deferred (customer favourites); created now so no second schema change is needed later
-- ---------------------------------------------------------------------------
CREATE TABLE `shop_favourites` (
  `site_id` bigint(20) unsigned NOT NULL COMMENT 'Site and tenant in which the favourite exists.',
  `customer_profile_id` bigint(20) unsigned NOT NULL COMMENT 'Customer profile that saved the product.',
  `product_id` bigint(20) unsigned NOT NULL COMMENT 'Product saved by the customer.',
  `created_at` timestamp NULL DEFAULT NULL COMMENT 'Date and time when the product was saved.',
  PRIMARY KEY (`site_id`, `customer_profile_id`, `product_id`),
  KEY `shop_favourites_product_index` (`site_id`, `product_id`),
  CONSTRAINT `shop_favourites_profile_fk` FOREIGN KEY (`site_id`, `customer_profile_id`) REFERENCES `shop_customer_profiles` (`site_id`, `id`) ON DELETE CASCADE,
  CONSTRAINT `shop_favourites_product_fk` FOREIGN KEY (`site_id`, `product_id`) REFERENCES `shop_products` (`site_id`, `id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Products saved as favourites by shop customers; deferred until favourites are synced to the server.';

-- ---------------------------------------------------------------------------
-- 13. Record the migrations so `php artisan migrate` never re-runs them
-- ---------------------------------------------------------------------------
SET @batch := (SELECT COALESCE(MAX(`batch`), 0) + 1 FROM `migrations`);
INSERT INTO `migrations` (`migration`, `batch`) VALUES
  ('2026_10_31_100000_add_site_id_id_unique_to_users_table', @batch),
  ('2026_10_31_100100_create_shop_settings_table', @batch),
  ('2026_10_31_100200_create_shop_categories_table', @batch),
  ('2026_10_31_100300_create_shop_products_table', @batch),
  ('2026_10_31_100400_create_shop_discount_tiers_table', @batch),
  ('2026_10_31_100500_create_shop_payment_methods_table', @batch),
  ('2026_10_31_100600_create_shop_customer_profiles_table', @batch),
  ('2026_10_31_100700_create_shop_orders_table', @batch),
  ('2026_10_31_100800_create_shop_order_items_table', @batch),
  ('2026_10_31_100900_create_shop_order_status_history_table', @batch),
  ('2026_10_31_101000_create_shop_inventory_movements_table', @batch),
  ('2026_10_31_101100_create_shop_favourites_table', @batch);
