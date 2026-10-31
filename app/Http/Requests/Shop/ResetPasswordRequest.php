<?php

namespace App\Http\Requests\Shop;

use Illuminate\Foundation\Http\FormRequest;

/** POST /auth/reset-password (API_CONTRACT §2). */
class ResetPasswordRequest extends FormRequest
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
            'email' => ['required', 'string', 'email', 'max:255'],
            'token' => ['required', 'string', 'size:64'],
            'password' => ['required', 'string', 'min:8', 'max:255', 'confirmed'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'email.*' => 'Sila masukkan e-mel yang sah.',
            'token.*' => 'Pautan tetapan semula tidak lengkap. Sila buka pautan daripada e-mel sekali lagi.',
            'password.required' => 'Sila masukkan kata laluan baharu.',
            'password.min' => 'Kata laluan mesti sekurang-kurangnya 8 aksara.',
            'password.max' => 'Kata laluan terlalu panjang.',
            'password.confirmed' => 'Pengesahan kata laluan tidak sepadan.',
        ];
    }
}
