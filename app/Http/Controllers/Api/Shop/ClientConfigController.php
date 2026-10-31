<?php

namespace App\Http\Controllers\Api\Shop;

use App\Models\ShopDiscountTier;
use App\Models\ShopPaymentMethod;
use App\Models\ShopSetting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * GET /client/config (API_CONTRACT §3): the `ordering` block the frontend
 * merges over its static client config.
 */
class ClientConfigController extends ShopController
{
    public function __invoke(Request $request): JsonResponse
    {
        $site = $this->site($request);
        $settings = ShopSetting::query()->whereKey($site->id)->first();

        if ($settings === null) {
            return response()->json(['data' => (object) []]);
        }

        $tiers = ShopDiscountTier::query()->forSite($site)->where('is_active', true)->orderBy('minimum_quantity')->get();
        $methods = ShopPaymentMethod::query()->forSite($site)->where('is_active', true)->orderBy('sort_order')->orderBy('id')->get();

        $ordering = [
            'currency' => $settings->currency,
            'minimumOrder' => $settings->minimum_order_minor,
            'deliveryFee' => $settings->delivery_fee_minor,
            'allowWhatsappOrder' => $settings->allow_whatsapp_order,
            'referencePrefix' => $settings->reference_prefix,
            'quantityDiscounts' => $tiers->map(fn (ShopDiscountTier $t) => ['minQty' => $t->minimum_quantity, 'rate' => $t->rate()])->values()->all(),
            'paymentOptions' => $methods->pluck('label')->values()->all(),
        ];

        if ($settings->free_delivery_from_minor !== null) {
            $ordering['freeDeliveryFrom'] = $settings->free_delivery_from_minor;
        }

        return response()->json(['data' => ['ordering' => $ordering]]);
    }
}
