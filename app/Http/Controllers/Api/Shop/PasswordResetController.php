<?php

namespace App\Http\Controllers\Api\Shop;

use App\Http\Requests\Shop\ForgotPasswordRequest;
use App\Http\Requests\Shop\ResetPasswordRequest;
use App\Services\Shop\PasswordResetService;
use Illuminate\Http\JsonResponse;

/** Owner/staff password reset by e-mailed link (API_CONTRACT §2). */
class PasswordResetController extends ShopController
{
    public function __construct(private readonly PasswordResetService $service) {}

    /** Always 200 with the same message, whether or not the e-mail is known. */
    public function forgot(ForgotPasswordRequest $request): JsonResponse
    {
        $this->service->request($this->site($request), $request->validated('email'));

        return response()->json(['message' => 'Jika e-mel ini berdaftar sebagai pemilik atau staf, pautan tetapan semula telah dihantar. Semak peti masuk dan folder spam anda.']);
    }

    public function reset(ResetPasswordRequest $request): JsonResponse
    {
        $this->service->reset(
            $this->site($request),
            $request->validated('email'),
            $request->validated('token'),
            $request->validated('password'),
        );

        return response()->json(['message' => 'Kata laluan telah ditetapkan semula. Sila log masuk dengan kata laluan baharu anda.']);
    }
}
