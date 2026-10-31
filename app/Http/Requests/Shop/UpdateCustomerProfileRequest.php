<?php

namespace App\Http\Requests\Shop;

use Illuminate\Foundation\Http\FormRequest;

/** PUT /customer/profile body = frontend Customer (API_CONTRACT §4). */
class UpdateCustomerProfileRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, array<int, string>>
     */
    public function rules(): array
    {
        return [
            'storeName' => ['required', 'string', 'min:2', 'max:200'],
            'contactName' => ['required', 'string', 'min:2', 'max:150'],
            'phone' => ['required', 'string', 'max:30', 'regex:/^(?:\D*\d){9,15}\D*$/'],
            'address' => ['nullable', 'string', 'max:1000'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'storeName.*' => 'Sila isi nama kedai dan penerima yang sah.',
            'contactName.*' => 'Sila isi nama kedai dan penerima yang sah.',
            'phone.*' => 'Sila masukkan nombor telefon yang sah.',
        ];
    }
}
