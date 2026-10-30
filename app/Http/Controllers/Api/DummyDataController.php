<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class DummyDataController extends Controller
{
    public function products(): JsonResponse
    {
        return $this->emptyCollectionResponse();
    }

    public function clientConfig(): JsonResponse
    {
        return response()->json([
            'data' => (object) [],
        ]);
    }

    public function categories(): JsonResponse
    {
        return $this->emptyCollectionResponse();
    }

    public function orders(): JsonResponse
    {
        return $this->emptyCollectionResponse();
    }

    private function emptyCollectionResponse(): JsonResponse
    {
        return response()->json([
            'data' => [],
        ]);
    }
}
