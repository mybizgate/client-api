<?php

namespace App\Services\Shop;

use App\Enums\InventoryMovementType;
use App\Models\ShopInventoryMovement;
use App\Models\ShopOrder;
use App\Models\ShopProduct;
use App\Models\ShopSetting;
use Illuminate\Validation\ValidationException;

/**
 * Stock rules (SHOP_DESIGN.md §5.7). Every balance change writes one ledger
 * row in the caller's transaction. Products flagged `unlimited_stock` never
 * move; the owner switch `deduct_stock_on_confirm` decides whether orders do.
 */
class StockService
{
    /**
     * Applies a signed delta to a product that the caller has locked
     * (`lockForUpdate()`). Returns null for unlimited products.
     */
    public function adjust(
        ShopProduct $product,
        int $delta,
        InventoryMovementType $type,
        ?ShopOrder $order = null,
        ?int $userId = null,
        ?string $note = null,
    ): ?ShopInventoryMovement {
        if ($product->unlimited_stock || $delta === 0) {
            return null;
        }

        $balance = $product->stock_quantity + $delta;

        if ($balance < 0) {
            throw ValidationException::withMessages([
                'quantityDelta' => ["{$product->name}: stok tersedia {$product->stock_quantity} {$product->selling_unit}."],
            ]);
        }

        $product->stock_quantity = $balance;
        $product->save();

        return ShopInventoryMovement::create([
            'site_id' => $product->site_id,
            'product_id' => $product->id,
            'order_id' => $order?->id,
            'movement_type' => $type,
            'quantity_delta' => $delta,
            'balance_after' => $balance,
            'note' => $note,
            'created_by_user_id' => $userId,
            'created_at' => now(),
        ]);
    }

    /** Called when an order becomes `confirmed`. 422 when a tracked line cannot be covered. */
    public function deductForOrder(ShopOrder $order, ShopSetting $settings, ?int $userId = null): void
    {
        if (! $settings->deduct_stock_on_confirm) {
            return;
        }

        foreach ($order->items as $item) {
            $product = ShopProduct::query()->withTrashed()->lockForUpdate()->find($item->product_id);

            if ($product === null || $product->unlimited_stock) {
                continue;
            }

            if ($product->stock_quantity < $item->quantity) {
                throw ValidationException::withMessages([
                    'status' => ["{$product->name}: stok tersedia {$product->stock_quantity} {$product->selling_unit}, pesanan {$item->quantity}."],
                ]);
            }

            $this->adjust($product, -$item->quantity, InventoryMovementType::Sale, $order, $userId, $order->reference_no);
        }
    }

    /** Called when an order becomes `cancelled`: reverses `sale` rows not yet reversed. */
    public function restoreForOrder(ShopOrder $order, ?int $userId = null): void
    {
        $sales = $order->movements()->where('movement_type', InventoryMovementType::Sale->value)->get();

        if ($sales->isEmpty() || $order->movements()->where('movement_type', InventoryMovementType::Cancellation->value)->exists()) {
            return;
        }

        foreach ($sales as $sale) {
            $product = ShopProduct::query()->withTrashed()->lockForUpdate()->find($sale->product_id);

            if ($product === null) {
                continue;
            }

            $this->adjust($product, -$sale->quantity_delta, InventoryMovementType::Cancellation, $order, $userId, $order->reference_no);
        }
    }
}
