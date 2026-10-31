<?php

namespace Tests\Feature\Shop;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class ManageCategoryTest extends TestCase
{
    use InteractsWithShop;
    use RefreshDatabase;

    private string $token;

    protected function setUp(): void
    {
        parent::setUp();
        $this->setUpShop();
        [, $this->token] = $this->staff('staff');
    }

    public function test_create_update_and_list_categories(): void
    {
        $id = $this->postJson('/api/v1/manage/categories', ['name' => 'Sos & Kicap'], $this->headers($this->token))
            ->assertCreated()
            ->assertJsonPath('data.slug', 'sos-kicap')
            ->assertJsonPath('data.status', 'active')
            ->assertJsonPath('data.parentId', null)
            ->json('data.id');

        $this->postJson('/api/v1/manage/categories', ['name' => 'Sos & Kicap'], $this->headers($this->token))->assertCreated()->assertJsonPath('data.slug', 'sos-kicap-2');

        $this->putJson("/api/v1/manage/categories/{$id}", ['name' => 'Sos', 'status' => 'draft', 'sortOrder' => 9], $this->headers($this->token))
            ->assertOk()->assertJsonPath('data.name', 'Sos')->assertJsonPath('data.active', false)->assertJsonPath('data.sortOrder', 9);

        $this->getJson('/api/v1/manage/categories', $this->headers($this->token))->assertOk()->assertJsonCount(3, 'data');
        $this->getJson('/api/v1/categories', $this->headers())->assertOk()->assertJsonCount(2, 'data');
    }

    public function test_parent_cycles_are_rejected(): void
    {
        $a = $this->postJson('/api/v1/manage/categories', ['name' => 'Aa'], $this->headers($this->token))->assertCreated()->json('data.id');
        $b = $this->postJson('/api/v1/manage/categories', ['name' => 'Bb', 'parentId' => $a], $this->headers($this->token))->assertCreated()->json('data.id');

        $this->putJson("/api/v1/manage/categories/{$a}", ['name' => 'Aa', 'parentId' => $a], $this->headers($this->token))->assertStatus(422)->assertJsonValidationErrors(['parentId']);
        $this->putJson("/api/v1/manage/categories/{$a}", ['name' => 'Aa', 'parentId' => $b], $this->headers($this->token))->assertStatus(422)->assertJsonValidationErrors(['parentId']);
        $this->putJson("/api/v1/manage/categories/{$a}", ['name' => 'Aa', 'parentId' => 999999], $this->headers($this->token))->assertStatus(422)->assertJsonValidationErrors(['parentId']);
    }

    public function test_delete_is_refused_while_products_use_the_category(): void
    {
        $this->product();

        $this->deleteJson("/api/v1/manage/categories/{$this->category->id}", [], $this->headers($this->token))->assertStatus(422);

        $empty = $this->postJson('/api/v1/manage/categories', ['name' => 'Kosong'], $this->headers($this->token))->json('data.id');
        $this->deleteJson("/api/v1/manage/categories/{$empty}", [], $this->headers($this->token))->assertNoContent();
        $this->assertSoftDeleted('shop_categories', ['id' => $empty]);
    }
}
