<?php

namespace App\Services\Shop;

use App\Enums\ActorType;
use App\Enums\FulfilmentMethod;
use App\Enums\OrderStatus;
use App\Models\ShopCustomerProfile;
use App\Models\ShopDiscountTier;
use App\Models\ShopOrder;
use App\Models\ShopOrderItem;
use App\Models\ShopOrderStatusHistory;
use App\Models\ShopPaymentMethod;
use App\Models\ShopProduct;
use App\Models\ShopSetting;
use App\Models\Site;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * `POST /orders` (SHOP_DESIGN.md §5.3–§5.5): validates every line against the
 * live catalogue, prices it exactly like the prototype, reserves the next
 * reference and writes order, lines and the first history row in one
 * transaction. Messages mirror the frontend's Malay wording.
 */
class OrderService
{
    public function __construct(
        private readonly OrderPricingService $pricing,
        private readonly OrderReferenceService $references,
    ) {}

    /**
     * @param  array{
     *   customer: array{storeName: string, contactName: string, phone: string, address?: string|null},
     *   fulfilment: string, requestedDate: string, paymentMethod: string, notes?: string|null,
     *   items: list<array{productId: string|int, qty: int}>
     * }  $input  already validated by StoreOrderRequest
     */
    public function create(Site $site, ShopCustomerProfile $profile, array $input): ShopOrder
    {
        return DB::transaction(function () use ($site, $profile, $input): ShopOrder {
            $settings = ShopSetting::query()->whereKey($site->id)->lockForUpdate()->first();
            abort_unless($settings !== null, 503, 'Shop settings are not configured for this site.');

            $fulfilment = FulfilmentMethod::from($input['fulfilment']);
            $tiers = ShopDiscountTier::query()->forSite($site)->where('is_active', true)->get();
            $payment = ShopPaymentMethod::query()->forSite($site)->where('is_active', true)->where('label', $input['paymentMethod'])->first();

            if ($payment === null) {
                throw ValidationException::withMessages(['paymentMethod' => ['Kaedah pembayaran tidak sah.']]);
            }

            $quantities = [];
            foreach ($input['items'] as $line) {
                $id = (int) $line['productId'];
                $quantities[$id] = ($quantities[$id] ?? 0) + (int) $line['qty'];
            }

            $products = ShopProduct::query()
                ->forSite($site)
                ->whereIn('id', array_keys($quantities))
                ->with('category')
                ->lockForUpdate()
                ->get()
                ->keyBy('id');

            $lines = [];
            $subtotal = 0;
            $fullPrice = 0;
            $lineNumber = 0;

            foreach ($quantities as $productId => $qty) {
                $product = $products->get($productId);
                $lineNumber++;
                $key = "items.{$lineNumber}";

                if ($product === null || ! $product->isPubliclyVisible()) {
                    throw ValidationException::withMessages([$key => ["Produk {$productId} tidak tersedia."]]);
                }
                if ($qty < $product->minimum_order_quantity) {
                    throw ValidationException::withMessages([$key => ["{$product->name}: minimum {$product->minimum_order_quantity} {$product->selling_unit}."]]);
                }
                if (! $product->hasStockFor($qty)) {
                    throw ValidationException::withMessages([$key => ["{$product->name}: stok tersedia {$product->stock_quantity} {$product->selling_unit}."]]);
                }

                $unitPrice = $this->pricing->unitPrice($product->selling_price_minor, $qty, $tiers);
                $subtotal += $qty * $unitPrice;
                $fullPrice += $qty * $product->selling_price_minor;

                $lines[] = [
                    'line_number' => $lineNumber,
                    'product_id' => $product->id,
                    'sku' => $product->sku,
                    'product_name' => $product->name,
                    'product_slug' => $product->slug,
                    'selling_unit' => $product->selling_unit,
                    'pack_quantity' => $product->pack_quantity,
                    'pack_size' => $product->pack_size,
                    'quantity' => $qty,
                    'base_price_minor' => $product->selling_price_minor,
                    'unit_price_minor' => $unitPrice,
                    'line_total_minor' => $qty * $unitPrice,
                ];
            }

            if ($subtotal < $settings->minimum_order_minor) {
                throw ValidationException::withMessages(['items' => ['Jumlah pesanan belum mencapai minimum.']]);
            }

            $fee = $this->pricing->deliveryFee($subtotal, $fulfilment, $settings);
            $address = trim((string) ($input['customer']['address'] ?? ''));
            $now = now();

            $order = ShopOrder::create([
                'site_id' => $site->id,
                'reference_no' => $this->references->next($settings),
                'customer_profile_id' => $profile->id,
                'status' => OrderStatus::DraftWhatsapp,
                'source' => 'web',
                'store_name' => trim($input['customer']['storeName']),
                'contact_name' => trim($input['customer']['contactName']),
                'contact_phone' => trim($input['customer']['phone']),
                'fulfilment_method' => $fulfilment,
                'delivery_address' => $address === '' ? null : $address,
                'requested_date' => $input['requestedDate'],
                'payment_method_code' => $payment->code,
                'payment_method_label' => $payment->label,
                'currency' => $settings->currency,
                'subtotal_minor' => $subtotal,
                'discount_minor' => max(0, $fullPrice - $subtotal),
                'delivery_fee_minor' => $fee,
                'total_minor' => $subtotal + $fee,
                'notes' => trim((string) ($input['notes'] ?? '')) === '' ? null : trim((string) $input['notes']),
            ]);

            foreach ($lines as $line) {
                ShopOrderItem::create(['site_id' => $site->id, 'order_id' => $order->id] + $line);
            }

            ShopOrderStatusHistory::create([
                'site_id' => $site->id,
                'order_id' => $order->id,
                'status' => OrderStatus::DraftWhatsapp,
                'actor_type' => ActorType::Customer,
                'changed_by_user_id' => null,
                'note' => null,
                'created_at' => $now,
            ]);

            return $order;
        });
    }
}
