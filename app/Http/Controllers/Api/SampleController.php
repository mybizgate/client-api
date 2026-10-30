<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Sample;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/**
 * CRUD over the demo "sample" table. Exists to prove the database connection
 * end to end; copy its shape (validation in the controller, {"data": …}
 * envelope, 201 on create, abort() for errors) for real resources.
 */
class SampleController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'active' => ['nullable', 'boolean'],
            'search' => ['nullable', 'string', 'max:150'],
            'per_page' => ['nullable', 'integer', 'min:1', 'max:100'],
        ]);

        $samples = Sample::query()
            ->when(array_key_exists('active', $validated), fn ($q) => $q->where('is_active', (bool) $validated['active']))
            ->when($validated['search'] ?? null, fn ($q, $search) => $q->where('title', 'like', '%'.$search.'%'))
            ->orderByDesc('id')
            ->paginate((int) ($validated['per_page'] ?? 15));

        return response()->json([
            'data' => $samples->items(),
            'meta' => [
                'page' => $samples->currentPage(),
                'per_page' => $samples->perPage(),
                'total' => $samples->total(),
                'total_pages' => $samples->lastPage(),
            ],
        ]);
    }

    public function store(Request $request): JsonResponse
    {
        $sample = Sample::create($this->validated($request));

        return response()->json(['data' => $sample], 201);
    }

    public function show(int $id): JsonResponse
    {
        return response()->json(['data' => $this->find($id)]);
    }

    public function update(Request $request, int $id): JsonResponse
    {
        $sample = $this->find($id);
        $sample->fill($this->validated($request, $sample))->save();

        return response()->json(['data' => $sample->refresh()]);
    }

    public function destroy(int $id): JsonResponse
    {
        $sample = $this->find($id);
        $sample->delete();

        return response()->json(['data' => ['id' => $sample->id, 'deleted' => true]]);
    }

    private function find(int $id): Sample
    {
        return Sample::query()->find($id) ?? abort(404, 'Sample not found.');
    }

    /**
     * @return array<string, mixed>
     */
    private function validated(Request $request, ?Sample $existing = null): array
    {
        return $request->validate([
            'title' => [$existing ? 'sometimes' : 'required', 'string', 'min:1', 'max:150'],
            'description' => ['nullable', 'string', 'max:5000'],
            'is_active' => ['sometimes', 'boolean'],
        ]);
    }
}
