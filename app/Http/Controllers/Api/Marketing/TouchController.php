<?php

namespace App\Http\Controllers\Api\Marketing;

use App\Http\Controllers\Api\Shop\ShopController;
use App\Http\Requests\Marketing\TouchRequest;
use App\Http\Resources\Marketing\ProspectResource;
use App\Models\MarketingProspect;
use App\Services\Marketing\ProspectService;
use Illuminate\Http\JsonResponse;

/** POST /marketing/prospects/{id}/touches: record a send, return the updated prospect. */
class TouchController extends ShopController
{
    public function __construct(private readonly ProspectService $prospects) {}

    public function store(TouchRequest $request, int $id): JsonResponse
    {
        $prospect = MarketingProspect::query()->forSite($this->site($request))->find($id);

        abort_unless($prospect !== null, 404, 'Prospect not found.');

        $prospect = $this->prospects->recordTouch($prospect, $request->validated());
        $prospect->loadCount('touchHistory as touches_count');

        return (new ProspectResource($prospect))->response()->setStatusCode(201);
    }
}
