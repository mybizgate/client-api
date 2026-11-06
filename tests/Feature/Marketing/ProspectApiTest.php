<?php

namespace Tests\Feature\Marketing;

use App\Models\Client;
use App\Models\MarketingProspect;
use App\Models\MarketingTouch;
use App\Models\Site;
use Illuminate\Database\UniqueConstraintViolationException;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Tests\Feature\Shop\InteractsWithShop;
use Tests\TestCase;

/** ../marketing/app-spec/API_CONTRACT.md against the `marketing` site. */
class ProspectApiTest extends TestCase
{
    use InteractsWithShop;
    use RefreshDatabase;

    private string $token;

    protected function setUp(): void
    {
        parent::setUp();
        $this->client = Client::factory()->create(['client_code' => 'marketing']);
        $this->site = Site::factory()->create(['client_id' => $this->client->id]);
        [, $this->token] = $this->staff('owner');
    }

    /**
     * @param  array<string, mixed>  $attributes
     */
    private function prospect(array $attributes = []): MarketingProspect
    {
        return MarketingProspect::factory()->create(['site_id' => $this->site->id, ...$attributes]);
    }

    /**
     * @return array<string, string>
     */
    private function auth(?string $token = null): array
    {
        return $this->headers($token ?? $this->token, 'marketing');
    }

    public function test_routes_require_a_staff_token_of_the_same_site(): void
    {
        $this->getJson('/api/v1/marketing/prospects', $this->headers(null, 'marketing'))->assertStatus(401);
        $this->getJson('/api/v1/marketing/summary', $this->headers(null, 'marketing'))->assertStatus(401);

        [, $foreignToken] = $this->staff('owner', $this->otherSite());
        $this->getJson('/api/v1/marketing/prospects', $this->auth($foreignToken))->assertStatus(403);
        $this->postJson('/api/v1/marketing/prospects', ['name' => 'Sneaky'], $this->auth($foreignToken))->assertStatus(403);

        $this->getJson('/api/v1/marketing/prospects', $this->auth())->assertOk();
    }

    public function test_prospects_of_another_site_are_invisible(): void
    {
        $foreign = MarketingProspect::factory()->create(['site_id' => $this->otherSite()->id]);

        $this->getJson("/api/v1/marketing/prospects/{$foreign->id}", $this->auth())->assertNotFound();
        $this->getJson('/api/v1/marketing/prospects', $this->auth())->assertJsonPath('meta.total', 0);
    }

    public function test_create_returns_the_record_and_a_duplicate_phone_is_rejected(): void
    {
        $this->postJson('/api/v1/marketing/prospects', [
            'name' => 'Klang Cat Boarding',
            'phone' => '018-312 2854',
            'category' => 'cat_hotel',
            'area' => 'Klang / Shah Alam',
            'state' => 'Selangor',
            'channel' => 'instagram.com/klangcatboarding',
            'website' => 'none',
            'priority' => 'A',
            'notes' => '249 followers, has SSM',
        ], $this->auth())
            ->assertCreated()
            ->assertJsonPath('data.phone', '60183122854')
            ->assertJsonPath('data.phone_display', '+60 18-312 2854')
            ->assertJsonPath('data.status', 'new')
            ->assertJsonPath('data.demo_slug', 'cathotel')
            ->assertJsonPath('data.last_touch_at', null)
            ->assertJsonPath('data.touches_count', 0)
            ->assertJsonPath('data.priority', 'A');

        $this->postJson('/api/v1/marketing/prospects', ['name' => 'Other Name', 'phone' => '+60 18-312 2854'], $this->auth())
            ->assertStatus(422)
            ->assertJsonStructure(['message', 'errors' => ['phone']])
            ->assertJsonPath('errors.phone.0', 'This number already belongs to Klang Cat Boarding (status new).');

        $this->postJson('/api/v1/marketing/prospects', ['name' => 'X'], $this->auth())->assertStatus(422)->assertJsonValidationErrors(['name']);
        $this->postJson('/api/v1/marketing/prospects', ['name' => 'Bad Phone', 'phone' => 'call me'], $this->auth())->assertStatus(422)->assertJsonValidationErrors(['phone']);
        $this->postJson('/api/v1/marketing/prospects', ['name' => 'Bad Status', 'status' => 'maybe'], $this->auth())->assertStatus(422)->assertJsonValidationErrors(['status']);
    }

    public function test_defaults_when_only_a_name_is_given(): void
    {
        $this->postJson('/api/v1/marketing/prospects', ['name' => 'Just A Name'], $this->auth())
            ->assertCreated()
            ->assertJsonPath('data.phone', null)
            ->assertJsonPath('data.phone_display', null)
            ->assertJsonPath('data.category', 'other')
            ->assertJsonPath('data.website', 'unknown')
            ->assertJsonPath('data.priority', 'B')
            ->assertJsonPath('data.status', 'new')
            ->assertJsonPath('data.demo_slug', null);
    }

    public function test_phone_normalisation(): void
    {
        $this->assertSame('60183122854', MarketingProspect::normalisePhone('0183122854'));
        $this->assertSame('60183122854', MarketingProspect::normalisePhone('+60 18-312 2854'));
        $this->assertSame('60183122854', MarketingProspect::normalisePhone('60183122854'));
        $this->assertNull(MarketingProspect::normalisePhone(''));
        $this->assertNull(MarketingProspect::normalisePhone('  '));
        $this->assertNull(MarketingProspect::normalisePhone(null));

        $this->assertSame('+60 11-3989 7014', MarketingProspect::formatPhone('601139897014'));
        $this->assertSame('+60 3-1234 5678', MarketingProspect::formatPhone('60312345678'));
        $this->assertSame('+65 91234567', MarketingProspect::formatPhone('6591234567'));
        $this->assertSame('+1 4155550100', MarketingProspect::formatPhone('14155550100'));

        foreach (['0183122854', '+60 18-312 2854', '60183122854'] as $i => $typed) {
            MarketingProspect::query()->delete();
            $this->postJson('/api/v1/marketing/prospects', ['name' => "Case {$i}", 'phone' => $typed], $this->auth())
                ->assertCreated()->assertJsonPath('data.phone', '60183122854');
        }

        $this->postJson('/api/v1/marketing/prospects', ['name' => 'Empty Phone', 'phone' => ''], $this->auth())
            ->assertCreated()->assertJsonPath('data.phone', null);
    }

    public function test_update_keeps_the_phone_rule_and_allows_any_status(): void
    {
        $a = $this->prospect(['name' => 'Alpha', 'phone' => '60111111111', 'status' => 'replied']);
        $b = $this->prospect(['name' => 'Beta', 'phone' => '60122222222']);

        $this->patchJson("/api/v1/marketing/prospects/{$b->id}", ['phone' => '011-1111 111'], $this->auth())
            ->assertStatus(422)
            ->assertJsonPath('errors.phone.0', 'This number already belongs to Alpha (status replied).');

        $this->patchJson("/api/v1/marketing/prospects/{$a->id}", ['phone' => '0111111111', 'status' => 'new', 'notes' => 'Corrected'], $this->auth())
            ->assertOk()
            ->assertJsonPath('data.status', 'new')
            ->assertJsonPath('data.notes', 'Corrected')
            ->assertJsonPath('data.name', 'Alpha');

        $this->patchJson("/api/v1/marketing/prospects/{$a->id}", ['name' => null], $this->auth())->assertStatus(422)->assertJsonValidationErrors(['name']);
    }

    public function test_list_filters_search_sort_and_paginate(): void
    {
        $this->prospect(['name' => 'Kitikat Hotel', 'phone' => '601139897014', 'priority' => 'A', 'state' => 'Putrajaya']);
        $this->prospect(['name' => 'Meow Inn', 'phone' => '60122930522', 'priority' => 'C', 'status' => 'contacted']);
        $this->prospect(['name' => 'Paws Den', 'phone' => null, 'priority' => 'B', 'category' => 'other']);

        $names = fn (string $query) => $this->getJson('/api/v1/marketing/prospects'.$query, $this->auth())->assertOk()->json('data.*.name');

        $this->assertSame(['Kitikat Hotel', 'Paws Den', 'Meow Inn'], $names(''));
        $this->assertSame(['Kitikat Hotel', 'Meow Inn', 'Paws Den'], $names('?sort=name'));
        $this->assertSame(['Meow Inn'], $names('?q=meow'));
        $this->assertSame(['Kitikat Hotel'], $names('?q=011-3989'));
        $this->assertSame(['Meow Inn'], $names('?q='.urlencode('+60 12-293')));
        $this->assertSame(['Meow Inn'], $names('?status=contacted'));
        $this->assertSame(['Kitikat Hotel'], $names('?priority=A'));
        $this->assertSame(['Paws Den'], $names('?category=other'));
        $this->assertSame(['Kitikat Hotel'], $names('?state=Putrajaya'));
        $this->assertSame(['Paws Den'], $names('?has_phone=0'));
        $this->assertSame(['Kitikat Hotel', 'Meow Inn'], $names('?has_phone=1'));

        $this->getJson('/api/v1/marketing/prospects?status=maybe', $this->auth())->assertStatus(422);

        MarketingProspect::factory()->count(50)->create(['site_id' => $this->site->id, 'priority' => 'D']);
        $this->getJson('/api/v1/marketing/prospects', $this->auth())->assertOk()->assertJsonCount(50, 'data')->assertJsonPath('meta.total', 53);
        $this->getJson('/api/v1/marketing/prospects?page=2', $this->auth())->assertOk()->assertJsonCount(3, 'data')->assertJsonPath('meta.total', 53);
    }

    public function test_check_reports_phone_and_name_matches(): void
    {
        $kitikat = $this->prospect(['name' => 'Kitikat Hotel', 'phone' => '601139897014']);
        $meow = $this->prospect(['name' => 'Meow Hotel KL', 'phone' => '60122930522']);

        $this->getJson('/api/v1/marketing/prospects/check?phone='.urlencode('011-3989 7014'), $this->auth())
            ->assertOk()
            ->assertJsonPath('data.matches', [[
                'id' => $kitikat->id, 'name' => 'Kitikat Hotel', 'phone_display' => '+60 11-3989 7014',
                'status' => 'new', 'last_touch_at' => null, 'match' => 'phone',
            ]]);

        $matches = $this->getJson('/api/v1/marketing/prospects/check?name=hotel&phone='.urlencode('0113989 7014'), $this->auth())->assertOk()->json('data.matches');
        $this->assertSame([[$kitikat->id, 'phone'], [$meow->id, 'name']], array_map(fn ($m) => [$m['id'], $m['match']], $matches));

        $this->getJson('/api/v1/marketing/prospects/check?name=Brand+New&phone=0190000000', $this->auth())->assertOk()->assertJsonPath('data.matches', []);
        $this->getJson('/api/v1/marketing/prospects/check', $this->auth())->assertOk()->assertJsonPath('data.matches', []);
    }

    public function test_touch_moves_new_to_contacted_but_never_backwards(): void
    {
        $fresh = $this->prospect(['status' => 'new']);

        $this->postJson("/api/v1/marketing/prospects/{$fresh->id}/touches", ['channel' => 'whatsapp', 'template' => 'first_ms'], $this->auth())
            ->assertCreated()
            ->assertJsonPath('data.status', 'contacted')
            ->assertJsonPath('data.touches_count', 1);
        $this->assertNotNull($fresh->refresh()->last_touch_at);

        $this->travel(1)->minutes();
        $this->postJson("/api/v1/marketing/prospects/{$fresh->id}/touches", ['template' => 'followup', 'note' => 'Second'], $this->auth())
            ->assertCreated()->assertJsonPath('data.touches_count', 2);

        $this->getJson("/api/v1/marketing/prospects/{$fresh->id}", $this->auth())
            ->assertOk()
            ->assertJsonPath('data.touches.0.template', 'followup')
            ->assertJsonPath('data.touches.0.channel', 'whatsapp')
            ->assertJsonPath('data.touches.0.note', 'Second')
            ->assertJsonPath('data.touches.1.template', 'first_ms');

        $replied = $this->prospect(['status' => 'replied']);
        $this->postJson("/api/v1/marketing/prospects/{$replied->id}/touches", ['template' => 'price'], $this->auth())
            ->assertCreated()->assertJsonPath('data.status', 'replied');

        $this->postJson("/api/v1/marketing/prospects/{$replied->id}/touches", ['template' => 'nope'], $this->auth())->assertStatus(422)->assertJsonValidationErrors(['template']);
        $this->postJson('/api/v1/marketing/prospects/999999/touches', ['template' => 'price'], $this->auth())->assertNotFound();
    }

    public function test_destroy_is_refused_once_touches_exist(): void
    {
        $touched = $this->prospect();
        MarketingTouch::create(['site_id' => $this->site->id, 'prospect_id' => $touched->id, 'template' => 'first_en', 'sent_at' => now()]);
        $untouched = $this->prospect();

        $this->deleteJson("/api/v1/marketing/prospects/{$touched->id}", [], $this->auth())->assertStatus(409)->assertJsonStructure(['message']);
        $this->assertDatabaseHas('marketing_prospects', ['id' => $touched->id]);

        $this->deleteJson("/api/v1/marketing/prospects/{$untouched->id}", [], $this->auth())->assertNoContent();
        $this->assertDatabaseMissing('marketing_prospects', ['id' => $untouched->id]);
    }

    public function test_import_skips_duplicate_phones(): void
    {
        $this->prospect(['name' => 'Existing', 'phone' => '60183122854']);

        $this->postJson('/api/v1/marketing/prospects/import', ['rows' => [
            ['name' => 'New One', 'phone' => '0191234567', 'category' => 'dental'],
            ['name' => 'Same As Existing', 'phone' => '018-312 2854'],
            ['name' => 'Same As New One', 'phone' => '+60191234567'],
            ['name' => 'No Phone'],
            ['name' => 'Z'],
        ]], $this->auth())
            ->assertOk()
            ->assertJsonPath('data.created', 2)
            ->assertJsonPath('data.skipped.0', ['name' => 'Same As Existing', 'reason' => 'This number already belongs to Existing (status new).'])
            ->assertJsonPath('data.skipped.1.name', 'Same As New One')
            ->assertJsonPath('data.skipped.2.name', 'Z')
            ->assertJsonCount(3, 'data.skipped');

        $this->assertDatabaseHas('marketing_prospects', ['name' => 'New One', 'phone' => '60191234567', 'demo_slug' => 'dental']);
        $this->postJson('/api/v1/marketing/prospects/import', ['rows' => []], $this->auth())->assertStatus(422);
        $this->postJson('/api/v1/marketing/prospects/import', ['rows' => array_fill(0, 501, ['name' => 'Too Many'])], $this->auth())->assertStatus(422);
    }

    public function test_summary_counts(): void
    {
        $this->prospect(['priority' => 'A', 'status' => 'new']);
        $this->prospect(['priority' => 'A', 'status' => 'contacted']);
        $old = $this->prospect(['priority' => 'C', 'status' => 'replied', 'phone' => null]);
        MarketingProspect::factory()->create(['site_id' => $this->otherSite()->id]);

        $this->travelTo(now()->subDays(10));
        MarketingTouch::create(['site_id' => $this->site->id, 'prospect_id' => $old->id, 'template' => 'first_ms', 'sent_at' => now()]);
        $this->travelBack();
        MarketingTouch::create(['site_id' => $this->site->id, 'prospect_id' => $old->id, 'template' => 'followup', 'sent_at' => now()]);

        $this->getJson('/api/v1/marketing/summary', $this->auth())
            ->assertOk()
            ->assertJsonPath('data.total', 3)
            ->assertJsonPath('data.with_phone', 2)
            ->assertJsonPath('data.by_status', ['new' => 1, 'contacted' => 1, 'replied' => 1, 'demo_viewed' => 0, 'won' => 0, 'lost' => 0, 'do_not_contact' => 0])
            ->assertJsonPath('data.by_priority', ['A' => 2, 'B' => 0, 'C' => 1, 'D' => 0])
            ->assertJsonPath('data.sent_today', 1)
            ->assertJsonPath('data.sent_this_week', 1);
    }

    public function test_phone_is_unique_per_site_but_nulls_may_repeat(): void
    {
        $row = fn (string $name, ?string $phone) => [
            'site_id' => $this->site->id, 'name' => $name, 'phone' => $phone, 'category' => 'other',
            'website' => 'unknown', 'priority' => 'B', 'status' => 'new', 'created_at' => now(), 'updated_at' => now(),
        ];

        DB::table('marketing_prospects')->insert($row('No Phone 1', null));
        DB::table('marketing_prospects')->insert($row('No Phone 2', null));
        DB::table('marketing_prospects')->insert($row('Phone 1', '60183122854'));
        DB::table('marketing_prospects')->insert([...$row('Other Site', '60183122854'), 'site_id' => $this->otherSite()->id]);

        $this->assertSame(2, MarketingProspect::query()->forSite($this->site)->whereNull('phone')->count());

        $this->expectException(UniqueConstraintViolationException::class);
        DB::table('marketing_prospects')->insert($row('Phone 2', '60183122854'));
    }
}
