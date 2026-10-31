<?php

namespace App\Http\Controllers\Api\Shop\Manage;

use App\Http\Controllers\Api\Shop\ShopController;
use App\Http\Requests\Shop\Manage\SettingsRequest;
use App\Http\Resources\Shop\SettingsResource;
use App\Models\ShopSetting;
use Illuminate\Http\Request;

/** GET|PUT /manage/shop/settings (owner only). */
class SettingsController extends ShopController
{
    public function show(Request $request): SettingsResource
    {
        return new SettingsResource($this->settings($request));
    }

    public function update(SettingsRequest $request): SettingsResource
    {
        $settings = $this->settings($request);
        $input = $request->validated();

        $settings->fill([
            'currency' => strtoupper($input['currency']),
            'minimum_order_minor' => (int) $input['minimumOrder'],
            'delivery_fee_minor' => (int) $input['deliveryFee'],
            'free_delivery_from_minor' => isset($input['freeDeliveryFrom']) ? (int) $input['freeDeliveryFrom'] : null,
            'allow_whatsapp_order' => (bool) $input['allowWhatsappOrder'],
            'deduct_stock_on_confirm' => (bool) $input['deductStockOnConfirm'],
            'reference_prefix' => $input['referencePrefix'],
        ])->save();

        return new SettingsResource($settings->refresh());
    }

    private function settings(Request $request): ShopSetting
    {
        $site = $this->site($request);

        return ShopSetting::query()->firstOrCreate(['site_id' => $site->id], ['reference_prefix' => 'ORD']);
    }
}
