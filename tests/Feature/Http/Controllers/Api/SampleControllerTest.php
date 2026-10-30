<?php

namespace Tests\Feature\Http\Controllers\Api;

use App\Models\Sample;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class SampleControllerTest extends TestCase
{
    use RefreshDatabase;

    public function test_create_returns_201_with_the_stored_row(): void
    {
        $response = $this->postJson('/api/v1/sample', [
            'title' => 'First sample',
            'description' => 'Created through the API',
        ]);

        $response->assertCreated()
            ->assertJsonPath('data.title', 'First sample')
            ->assertJsonPath('data.description', 'Created through the API')
            ->assertJsonPath('data.is_active', true);

        $this->assertDatabaseHas('sample', ['title' => 'First sample', 'is_active' => 1]);
    }

    public function test_create_validates_input(): void
    {
        $this->postJson('/api/v1/sample', [])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['title']);

        $this->postJson('/api/v1/sample', ['title' => str_repeat('x', 151), 'is_active' => 'maybe'])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['title', 'is_active']);

        $this->assertDatabaseCount('sample', 0);
    }

    public function test_index_lists_newest_first_with_paging_and_filters(): void
    {
        Sample::create(['title' => 'Alpha', 'is_active' => true]);
        Sample::create(['title' => 'Beta', 'is_active' => false]);
        Sample::create(['title' => 'Gamma alpha', 'is_active' => true]);

        $this->getJson('/api/v1/sample')
            ->assertOk()
            ->assertJsonCount(3, 'data')
            ->assertJsonPath('data.0.title', 'Gamma alpha')
            ->assertJsonPath('meta.total', 3)
            ->assertJsonPath('meta.total_pages', 1);

        $this->getJson('/api/v1/sample?active=1')
            ->assertOk()
            ->assertJsonCount(2, 'data');

        $this->getJson('/api/v1/sample?search=alpha')
            ->assertOk()
            ->assertJsonCount(2, 'data');

        $this->getJson('/api/v1/sample?per_page=2')
            ->assertOk()
            ->assertJsonCount(2, 'data')
            ->assertJsonPath('meta.per_page', 2)
            ->assertJsonPath('meta.total_pages', 2);
    }

    public function test_show_returns_the_row_or_404(): void
    {
        $sample = Sample::create(['title' => 'Shown']);

        $this->getJson("/api/v1/sample/{$sample->id}")
            ->assertOk()
            ->assertJsonPath('data.id', $sample->id)
            ->assertJsonPath('data.title', 'Shown');

        $this->getJson('/api/v1/sample/999')->assertStatus(404);
        $this->getJson('/api/v1/sample/not-a-number')->assertStatus(404);
    }

    public function test_update_changes_only_the_given_fields(): void
    {
        $sample = Sample::create(['title' => 'Before', 'description' => 'keep me']);

        $this->patchJson("/api/v1/sample/{$sample->id}", ['title' => 'After', 'is_active' => false])
            ->assertOk()
            ->assertJsonPath('data.title', 'After')
            ->assertJsonPath('data.description', 'keep me')
            ->assertJsonPath('data.is_active', false);

        $this->putJson("/api/v1/sample/{$sample->id}", ['title' => ''])
            ->assertStatus(422)
            ->assertJsonValidationErrors(['title']);

        $this->patchJson('/api/v1/sample/999', ['title' => 'x'])->assertStatus(404);
    }

    public function test_destroy_deletes_the_row(): void
    {
        $sample = Sample::create(['title' => 'Gone']);

        $this->deleteJson("/api/v1/sample/{$sample->id}")
            ->assertOk()
            ->assertJsonPath('data.deleted', true);

        $this->assertDatabaseMissing('sample', ['id' => $sample->id]);
        $this->deleteJson("/api/v1/sample/{$sample->id}")->assertStatus(404);
    }
}
