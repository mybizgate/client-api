<?php

namespace Database\Seeders;

use App\Enums\InventoryMovementType;
use App\Enums\PublicationStatus;
use App\Models\Client;
use App\Models\ShopCategory;
use App\Models\ShopDiscountTier;
use App\Models\ShopInventoryMovement;
use App\Models\ShopPaymentMethod;
use App\Models\ShopProduct;
use App\Models\ShopSetting;
use App\Models\Site;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

/**
 * Local-development twin of clients/client-lzhub/docs/shop/shop_seed_lzhub.sql
 * (SHOP_DESIGN.md §11): the lzhub client/site, settings, tiers, payment
 * methods, 8 categories and 24 products from the frontend seed. Idempotent.
 * No users are created here; run `php artisan shop:user lzhub` for the owner.
 */
class ShopLzhubSeeder extends Seeder
{
    /** @var list<array{0: string, 1: string, 2: string, 3: int}> name, slug, (unused), sort */
    private const CATEGORIES = [
        ['rempah', 'Rempah & Perencah', 'rempah-perencah', 1],
        ['sos', 'Sos & Kicap', 'sos-kicap', 2],
        ['minyak', 'Minyak Masak', 'minyak-masak', 3],
        ['beras', 'Beras & Tepung', 'beras-tepung', 4],
        ['gula', 'Gula & Garam', 'gula-garam', 5],
        ['santan', 'Santan & Tin', 'santan-tin', 6],
        ['mi', 'Mi & Bihun', 'mi-bihun', 7],
        ['kering', 'Bahan Kering', 'bahan-kering', 8],
    ];

    /** name, label, category key, unit, packs, size, price (sen), stock, min, old price, shape, colour, motif */
    private const PRODUCTS = [
        ['Serbuk Kari Daging', 'KARI DAGING', 'rempah', 'karton', 12, '1kg', 14520, 32, 1, 15900, 'pouch', '#de9731', 'spice'],
        ['Kicap Manis Premium', 'KICAP MANIS', 'sos', 'karton', 12, '650ml', 8800, 46, 2, 0, 'bottle', '#623125', 'soy'],
        ['Minyak Masak Tulen', 'MINYAK MASAK', 'minyak', 'karton', 4, '5kg', 12500, 18, 1, 13900, 'jug', '#efb931', 'leaf'],
        ['Beras Wangi', 'BERAS WANGI', 'beras', 'guni', 1, '10kg', 5590, 60, 2, 0, 'rice', '#519779', 'rice'],
        ['Serbuk Cili', 'SERBUK CILI', 'rempah', 'karton', 10, '1kg', 11900, 55, 1, 0, 'pouch', '#c94332', 'chili'],
        ['Sos Cili Asli', 'SOS CILI', 'sos', 'karton', 12, '1kg', 6720, 25, 1, 7440, 'bottle', '#c34a31', 'chili'],
        ['Santan Kelapa', 'SANTAN', 'santan', 'karton', 24, '200ml', 7200, 14, 1, 0, 'carton', '#347f64', 'coconut'],
        ['Tepung Gandum', 'TEPUNG GANDUM', 'beras', 'karton', 10, '1kg', 3150, 0, 2, 0, 'pouch', '#5080a6', 'wheat'],
        ['Serbuk Kunyit', 'KUNYIT', 'rempah', 'karton', 12, '500g', 7560, 38, 1, 0, 'pouch', '#dfb234', 'spice'],
        ['Gula Pasir Putih', 'GULA PASIR', 'gula', 'karton', 12, '1kg', 4140, 40, 2, 0, 'pouch', '#7097af', 'sugar'],
        ['Sos Tiram', 'SOS TIRAM', 'sos', 'karton', 12, '510g', 7920, 6, 1, 0, 'bottle', '#283d42', 'soy'],
        ['Bihun Beras', 'BIHUN BERAS', 'mi', 'karton', 20, '400g', 6400, 28, 2, 0, 'packet', '#e37840', 'noodle'],
        ['Lada Hitam Kisar', 'LADA HITAM', 'rempah', 'karton', 12, '250g', 10800, 22, 1, 12000, 'jar', '#485543', 'pepper'],
        ['Minyak Jagung', 'MINYAK JAGUNG', 'minyak', 'karton', 6, '1L', 8700, 20, 1, 0, 'bottle', '#d8a82a', 'leaf'],
        ['Tepung Jagung', 'TEPUNG JAGUNG', 'beras', 'karton', 24, '400g', 6960, 24, 1, 0, 'pouch', '#d19d46', 'wheat'],
        ['Garam Halus', 'GARAM HALUS', 'gula', 'karton', 20, '500g', 2400, 45, 3, 0, 'pouch', '#659c9e', 'sugar'],
        ['Sardin Sos Tomato', 'SARDIN', 'santan', 'karton', 24, '425g', 15840, 35, 1, 17280, 'can', '#bc4833', 'fish'],
        ['Mi Kuning Kering', 'MI KERING', 'mi', 'karton', 20, '500g', 7000, 17, 1, 0, 'packet', '#cba23e', 'noodle'],
        ['Kacang Dal', 'KACANG DAL', 'kering', 'guni', 1, '10kg', 7800, 19, 1, 0, 'rice', '#c47d41', 'beans'],
        ['Asam Jawa', 'ASAM JAWA', 'kering', 'karton', 24, '200g', 4800, 30, 2, 0, 'pouch', '#8b593a', 'beans'],
        ['Gula Perang', 'GULA PERANG', 'gula', 'karton', 12, '1kg', 6240, 12, 1, 0, 'pouch', '#b98350', 'sugar'],
        ['Kacang Panggang', 'KACANG PANGGANG', 'santan', 'karton', 24, '425g', 8640, 0, 1, 0, 'can', '#aa4834', 'beans'],
        ['Spageti', 'SPAGETI', 'mi', 'karton', 20, '500g', 7900, 26, 1, 8800, 'packet', '#9a763e', 'noodle'],
        ['Bawang Goreng', 'BAWANG GORENG', 'kering', 'karton', 12, '500g', 9600, 8, 1, 0, 'jar', '#a8743c', 'onion'],
    ];

    public function run(): void
    {
        $client = Client::query()->firstOrCreate(['client_code' => 'lzhub'], [
            'business_name' => 'Lz Success Enterprise',
            'business_nature' => 'Pengedar Produk IKS Tempatan',
            'contact_person' => 'Lz Success Enterprise',
            'email' => 'lzsuccess007@gmail.com',
            'phone_primary' => '+60192857371',
            'phone_secondary' => '+60175050885',
            'address_line1' => '27 Jalan Melati 13',
            'address_line2' => 'Taman Melati',
            'city' => 'Kuala Lumpur',
            'state' => 'Wilayah Persekutuan Kuala Lumpur',
            'postcode' => '53100',
            'country' => 'MY',
        ]);

        $site = Site::query()->firstOrCreate(['client_id' => $client->id], [
            'site_name' => 'Lz Success Enterprise',
            'domain' => 'lzhub.mybizgate.com',
            'domain_type' => 'subdomain',
            'site_type' => 'web_application',
            'package_name' => 'supplier/catalogue-simple',
            'first_year_price' => 0,
            'renewal_price' => 0,
            'billing_months' => 12,
            'start_date' => now()->toDateString(),
            'expiry_date' => now()->addYear()->toDateString(),
            'status' => Site::STATUS_ACTIVE,
        ]);

        ShopSetting::query()->firstOrCreate(['site_id' => $site->id], [
            'currency' => 'MYR',
            'minimum_order_minor' => 15000,
            'delivery_fee_minor' => 1500,
            'free_delivery_from_minor' => 50000,
            'allow_whatsapp_order' => true,
            'deduct_stock_on_confirm' => false,
            'reference_prefix' => 'LZ',
            'next_order_number' => 1,
        ]);

        foreach ([[5, 200], [10, 400]] as [$minQty, $bp]) {
            ShopDiscountTier::query()->firstOrCreate(['site_id' => $site->id, 'minimum_quantity' => $minQty], ['discount_basis_points' => $bp, 'is_active' => true]);
        }

        foreach ([['cod', 'Tunai semasa terima barang', 1], ['bank_transfer', 'Pindahan bank selepas disahkan', 2]] as [$code, $label, $sort]) {
            ShopPaymentMethod::query()->firstOrCreate(['site_id' => $site->id, 'code' => $code], ['label' => $label, 'sort_order' => $sort, 'is_active' => true]);
        }

        $categories = [];
        foreach (self::CATEGORIES as [$key, $name, $slug, $sort]) {
            $categories[$key] = ShopCategory::query()->firstOrCreate(['site_id' => $site->id, 'slug' => $slug], [
                'name' => $name,
                'sort_order' => $sort,
                'status' => PublicationStatus::Active,
            ]);
        }

        foreach (self::PRODUCTS as $i => [$name, $label, $cat, $unit, $packs, $size, $price, $stock, $min, $old, $shape, $color, $motif]) {
            $slug = Str::slug("{$name} {$size}");
            $exists = ShopProduct::query()->withTrashed()->forSite($site)->where('slug', $slug)->exists();

            if ($exists) {
                continue;
            }

            $product = ShopProduct::create([
                'site_id' => $site->id,
                'category_id' => $categories[$cat]->id,
                'sku' => sprintf('LZ-%04d', $i + 1),
                'name' => $name,
                'slug' => $slug,
                'brand' => 'Lz Success Enterprise',
                'selling_unit' => $unit,
                'pack_quantity' => $packs,
                'pack_size' => $size,
                'selling_price_minor' => $price,
                'compare_at_price_minor' => $old > $price ? $old : null,
                'minimum_order_quantity' => $min,
                'stock_quantity' => $stock,
                'unlimited_stock' => false,
                'low_stock_threshold' => 10,
                'sort_order' => $i + 1,
                'is_featured' => $i < 4,
                'status' => PublicationStatus::Active,
                'placeholder_art_json' => ['shape' => $shape, 'color' => $color, 'motif' => $motif, 'label' => $label],
                'published_at' => now(),
            ]);

            if ($stock > 0) {
                ShopInventoryMovement::create([
                    'site_id' => $site->id,
                    'product_id' => $product->id,
                    'movement_type' => InventoryMovementType::Opening,
                    'quantity_delta' => $stock,
                    'balance_after' => $stock,
                    'note' => 'Stok permulaan (seed)',
                    'created_at' => now(),
                ]);
            }
        }
    }
}
