<?php

namespace App\Http\Controllers\Api\Marketing;

use App\Http\Controllers\Api\Shop\ShopController;
use App\Http\Requests\Marketing\CheckProspectRequest;
use App\Http\Requests\Marketing\ImportProspectsRequest;
use App\Http\Requests\Marketing\ProspectIndexRequest;
use App\Http\Requests\Marketing\ProspectRequest;
use App\Http\Resources\Marketing\ProspectResource;
use App\Models\MarketingProspect;
use App\Services\Marketing\ProspectService;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/** /marketing/prospects (../marketing/app-spec/API_CONTRACT.md). */
class ProspectController extends ShopController
{
    public const int PER_PAGE = 50;

    public function __construct(private readonly ProspectService $prospects) {}

    public function index(ProspectIndexRequest $request): JsonResponse
    {
        $filters = $request->validated();
        $q = trim((string) ($filters['q'] ?? ''));
        $qDigits = preg_replace('/\D+/', '', $q) ?? '';

        $query = MarketingProspect::query()
            ->forSite($this->site($request))
            ->withCount('touchHistory as touches_count')
            ->when($q !== '', fn (Builder $query) => $query->where(function (Builder $match) use ($q, $qDigits) {
                $match->whereRaw("name LIKE ? ESCAPE '!'", [$this->contains($q)]);

                if (strlen($qDigits) >= 3) {
                    $match->orWhereRaw("phone LIKE ? ESCAPE '!'", [$this->contains($qDigits)]);
                }
            }))
            ->when(! empty($filters['status']), fn (Builder $query) => $query->where('status', $filters['status']))
            ->when(! empty($filters['priority']), fn (Builder $query) => $query->where('priority', $filters['priority']))
            ->when(! empty($filters['category']), fn (Builder $query) => $query->where('category', $filters['category']))
            ->when(! empty($filters['state']), fn (Builder $query) => $query->where('state', $filters['state']))
            ->when(($filters['has_phone'] ?? null) === '1', fn (Builder $query) => $query->whereNotNull('phone'))
            ->when(($filters['has_phone'] ?? null) === '0', fn (Builder $query) => $query->whereNull('phone'));

        match ($filters['sort'] ?? 'priority') {
            'updated' => $query->orderByDesc('updated_at')->orderByDesc('id'),
            'name' => $query->orderBy('name')->orderBy('id'),
            default => $query->orderBy('priority')->orderBy('name')->orderBy('id'),
        };

        $page = $query->paginate(self::PER_PAGE, ['*'], 'page', (int) ($filters['page'] ?? 1));

        return response()->json([
            'data' => collect($page->items())->map(fn (MarketingProspect $p) => (new ProspectResource($p))->resolve($request))->all(),
            'meta' => [
                'total' => $page->total(),
                'page' => $page->currentPage(),
                'per_page' => $page->perPage(),
                'last_page' => $page->lastPage(),
            ],
        ]);
    }

    public function store(ProspectRequest $request): JsonResponse
    {
        $prospect = $this->prospects->create($this->site($request), $request->validated());
        $prospect->loadCount('touchHistory as touches_count');

        return (new ProspectResource($prospect))->response()->setStatusCode(201);
    }

    public function show(Request $request, int $id): ProspectResource
    {
        return new ProspectResource($this->find($request, $id), true);
    }

    public function update(ProspectRequest $request, int $id): ProspectResource
    {
        $prospect = $this->prospects->update($this->find($request, $id), $request->validated());

        return new ProspectResource($prospect);
    }

    public function destroy(Request $request, int $id): JsonResponse
    {
        $prospect = $this->find($request, $id);

        abort_if($prospect->touches_count > 0, 409, 'This prospect has recorded touches and cannot be deleted; set its status to do_not_contact instead.');

        $prospect->delete();

        return response()->json(null, 204);
    }

    /**
     * Duplicate check before adding: phone matches on normalised digits,
     * name matches case-insensitively on contains. A record matching both is
     * reported once, as a phone match.
     */
    public function check(CheckProspectRequest $request): JsonResponse
    {
        $site = $this->site($request);
        $phone = MarketingProspect::normalisePhone($request->validated('phone'));
        $name = trim((string) $request->validated('name'));
        $matches = [];

        if ($phone !== null) {
            MarketingProspect::query()->forSite($site)->where('phone', $phone)->get()
                ->each(function (MarketingProspect $p) use (&$matches) {
                    $matches[$p->id] = $this->match($p, 'phone');
                });
        }

        if (mb_strlen($name) >= 2) {
            MarketingProspect::query()->forSite($site)
                ->whereRaw("name LIKE ? ESCAPE '!'", [$this->contains($name)])
                ->orderBy('name')
                ->limit(20)
                ->get()
                ->each(function (MarketingProspect $p) use (&$matches) {
                    $matches[$p->id] ??= $this->match($p, 'name');
                });
        }

        return response()->json(['data' => ['matches' => array_values($matches)]]);
    }

    public function import(ImportProspectsRequest $request): JsonResponse
    {
        return response()->json(['data' => $this->prospects->import($this->site($request), $request->rows())]);
    }

    private function find(Request $request, int $id): MarketingProspect
    {
        $prospect = MarketingProspect::query()->forSite($this->site($request))->withCount('touchHistory as touches_count')->find($id);

        abort_unless($prospect !== null, 404, 'Prospect not found.');

        return $prospect;
    }

    /**
     * @return array{id: int, name: string, phone_display: string|null, status: string, last_touch_at: string|null, match: string}
     */
    private function match(MarketingProspect $p, string $match): array
    {
        return [
            'id' => $p->id,
            'name' => $p->name,
            'phone_display' => $p->phone_display,
            'status' => $p->status->value,
            'last_touch_at' => $p->last_touch_at?->toIso8601ZuluString(),
            'match' => $match,
        ];
    }

    /** `%value%` for LIKE with "!" as the escape character (portable across MariaDB and sqlite). */
    private function contains(string $value): string
    {
        return '%'.str_replace(['!', '%', '_'], ['!!', '!%', '!_'], $value).'%';
    }
}
