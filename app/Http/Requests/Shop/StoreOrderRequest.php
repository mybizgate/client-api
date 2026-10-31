<?php

namespace App\Http\Requests\Shop;

use App\Enums\FulfilmentMethod;
use App\Services\Shop\OrderReferenceService;
use Illuminate\Contracts\Validation\Validator;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Carbon;
use Illuminate\Validation\Rule;

/**
 * POST /orders body = frontend OrderDraft (API_CONTRACT §4). Field rules
 * mirror validateCustomer()/validateDraft() in order.service.ts and the
 * screen limits (SHOP_DESIGN.md §5.4); catalogue rules run in OrderService.
 */
class StoreOrderRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, array<int, mixed>>
     */
    public function rules(): array
    {
        return [
            'customer' => ['required', 'array'],
            'customer.storeName' => ['required', 'string', 'min:2', 'max:200'],
            'customer.contactName' => ['required', 'string', 'min:2', 'max:150'],
            'customer.phone' => ['required', 'string', 'max:30', 'regex:/^(?:\D*\d){9,15}\D*$/'],
            'customer.address' => ['nullable', 'string', 'max:1000', Rule::requiredIf(fn () => $this->input('fulfilment') === FulfilmentMethod::Delivery->value)],
            'fulfilment' => ['required', Rule::in(FulfilmentMethod::values())],
            'requestedDate' => ['required', 'date_format:Y-m-d'],
            'paymentMethod' => ['required', 'string', 'max:150'],
            'notes' => ['nullable', 'string', 'max:500'],
            'items' => ['required', 'array', 'min:1'],
            'items.*.productId' => ['required', 'integer', 'min:1'],
            'items.*.qty' => ['required', 'integer', 'min:1', 'max:100000'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'customer.storeName.*' => 'Sila isi nama kedai dan penerima yang sah.',
            'customer.contactName.*' => 'Sila isi nama kedai dan penerima yang sah.',
            'customer.phone.*' => 'Sila masukkan nombor telefon yang sah.',
            'customer.address.*' => 'Sila isi alamat lengkap untuk penghantaran.',
            'requestedDate.*' => 'Pilih tarikh esok atau selepasnya.',
            'items.required' => 'Troli kosong.',
            'items.min' => 'Troli kosong.',
            'paymentMethod.*' => 'Kaedah pembayaran tidak sah.',
        ];
    }

    public function after(): array
    {
        return [
            function (Validator $validator): void {
                if ($validator->errors()->isNotEmpty()) {
                    return;
                }

                if ($this->input('fulfilment') === FulfilmentMethod::Delivery->value
                    && mb_strlen(trim((string) $this->input('customer.address'))) < 10) {
                    $validator->errors()->add('customer.address', 'Sila isi alamat lengkap untuk penghantaran.');
                }

                $tomorrow = Carbon::now(OrderReferenceService::TIMEZONE)->addDay()->toDateString();

                if ((string) $this->input('requestedDate') < $tomorrow) {
                    $validator->errors()->add('requestedDate', 'Pilih tarikh esok atau selepasnya.');
                }
            },
        ];
    }
}
