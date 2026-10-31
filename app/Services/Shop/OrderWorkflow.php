<?php

namespace App\Services\Shop;

use App\Enums\ActorType;
use App\Enums\OrderStatus;
use App\Models\ShopOrder;
use App\Models\ShopOrderStatusHistory;
use App\Models\ShopSetting;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Validation\ValidationException;

/**
 * Status transitions (SHOP_DESIGN.md §5.5 table). Customers may mark a draft
 * as sent and cancel open orders; staff drive the fulfilment chain. Every
 * change appends one history row; stock side effects go through StockService.
 */
class OrderWorkflow
{
    public function __construct(private readonly StockService $stock) {}

    /** Customer ("Saya sudah hantar di WhatsApp" / "Batalkan rekod pesanan"). */
    public function customerTransition(ShopOrder $order, OrderStatus $to): ShopOrder
    {
        $allowed = match ($to) {
            OrderStatus::PendingReview => $order->status === OrderStatus::DraftWhatsapp,
            OrderStatus::Cancelled => $order->status->isOpen(),
            default => false,
        };

        if (! $allowed) {
            $this->reject($order->status, $to);
        }

        return $this->apply($order, $to, ActorType::Customer, null, null);
    }

    /** Owner or staff from the management screens. */
    public function staffTransition(ShopOrder $order, OrderStatus $to, User $user, ?string $note = null): ShopOrder
    {
        $from = $order->status;

        $allowed = match ($to) {
            OrderStatus::Confirmed => $from === OrderStatus::PendingReview,
            OrderStatus::Processing => $from === OrderStatus::Confirmed,
            OrderStatus::Delivered => $from === OrderStatus::Processing,
            OrderStatus::Completed => $from === OrderStatus::Delivered,
            OrderStatus::Cancelled => ! $from->isTerminal(),
            default => false,
        };

        if (! $allowed) {
            $this->reject($from, $to);
        }

        return $this->apply($order, $to, ActorType::Staff, $user->id, $note);
    }

    private function apply(ShopOrder $order, OrderStatus $to, ActorType $actor, ?int $userId, ?string $note): ShopOrder
    {
        return DB::transaction(function () use ($order, $to, $actor, $userId, $note): ShopOrder {
            $order = ShopOrder::query()->lockForUpdate()->findOrFail($order->id);
            $now = now();

            switch ($to) {
                case OrderStatus::PendingReview:
                    $order->whatsapp_sent_at = $now;
                    break;
                case OrderStatus::Confirmed:
                    $order->confirmed_at = $now;
                    $settings = ShopSetting::query()->whereKey($order->site_id)->firstOrFail();
                    $this->stock->deductForOrder($order, $settings, $userId);
                    break;
                case OrderStatus::Completed:
                    $order->completed_at = $now;
                    break;
                case OrderStatus::Cancelled:
                    $order->cancelled_at = $now;
                    $this->stock->restoreForOrder($order, $userId);
                    break;
                default:
                    break;
            }

            $order->status = $to;
            $order->save();

            ShopOrderStatusHistory::create([
                'site_id' => $order->site_id,
                'order_id' => $order->id,
                'status' => $to,
                'actor_type' => $actor,
                'changed_by_user_id' => $userId,
                'note' => $note,
                'created_at' => $now,
            ]);

            return $order;
        });
    }

    private function reject(OrderStatus $from, OrderStatus $to): never
    {
        throw ValidationException::withMessages([
            'status' => ["Pesanan berstatus {$from->value} tidak boleh ditukar kepada {$to->value}."],
        ]);
    }
}
