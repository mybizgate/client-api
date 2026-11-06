<?php

namespace Tests\Feature\Console;

use App\Models\Client;
use App\Models\MarketingProspect;
use App\Models\Site;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class MarketingImportCommandTest extends TestCase
{
    use RefreshDatabase;

    private Site $site;

    private string $csv;

    protected function setUp(): void
    {
        parent::setUp();
        $this->site = Site::factory()->for(Client::factory()->state(['client_code' => 'marketing']))->create();
        $this->csv = tempnam(sys_get_temp_dir(), 'prospects');
        file_put_contents($this->csv, implode("\n", [
            'name,area,state,phone,channel,website,priority,note,contacted,reply,demo_sent,result',
            'Kitikat Hotel,P15 Putrajaya,Putrajaya,601139897014,instagram.com/kitikat.hotel,none found,A,"2,587 followers",,,,',
            'Catswell,"Subang SS19, Ampang",Selangor,012-412 8300,linktr.ee/Catswell.subang,none found (Linktree only),B,,2026-11-01,,,',
            'Kooceng,Cheras,Kuala Lumpur,,instagram.com/kooceng,kooceng.my (has online booking),C,,,,,',
            'Molly Cat Hotel,Bangsar,Kuala Lumpur,,,mollycathotel.com,D,,,,,',
            'Mystery Cats,,,,,unknown,Z,,,,,',
            'Kitikat Again,,,0113989 7014,,none found,A,,,,,',
        ])."\n");
    }

    protected function tearDown(): void
    {
        @unlink($this->csv);
        parent::tearDown();
    }

    public function test_imports_the_csv_and_skips_duplicates_on_a_second_run(): void
    {
        $this->artisan('marketing:import', ['client_code' => 'marketing', 'csv' => $this->csv])
            ->expectsOutputToContain('Created 5, skipped 1')
            ->assertSuccessful();

        $catswell = MarketingProspect::query()->where('name', 'Catswell')->firstOrFail();
        $this->assertSame('60124128300', $catswell->phone);
        $this->assertSame('none', $catswell->website->value);
        $this->assertSame('contacted', $catswell->status->value);
        $this->assertSame('cat_hotel', $catswell->category);
        $this->assertSame('cathotel', $catswell->demo_slug);
        $this->assertSame('Subang SS19, Ampang', $catswell->area);

        $this->assertSame('has_site', MarketingProspect::query()->where('name', 'Kooceng')->value('website')?->value);
        $this->assertSame('has_site', MarketingProspect::query()->where('name', 'Molly Cat Hotel')->value('website')?->value);
        $mystery = MarketingProspect::query()->where('name', 'Mystery Cats')->firstOrFail();
        $this->assertSame(['unknown', 'B', 'new'], [$mystery->website->value, $mystery->priority->value, $mystery->status->value]);
        $this->assertSame('2,587 followers', MarketingProspect::query()->where('name', 'Kitikat Hotel')->value('notes'));

        $this->artisan('marketing:import', ['client_code' => 'marketing', 'csv' => $this->csv])
            ->expectsOutputToContain('Created 0, skipped 6')
            ->assertSuccessful();

        $this->assertSame(5, MarketingProspect::count());
    }

    public function test_sql_mode_prints_idempotent_inserts_and_writes_nothing(): void
    {
        $this->artisan('marketing:import', ['client_code' => 'marketing', 'csv' => $this->csv, '--sql' => true])
            ->expectsOutputToContain("WHERE `c`.`client_code` = 'marketing'")
            ->expectsOutputToContain("AND NOT EXISTS (SELECT 1 FROM `marketing_prospects` AS `p` WHERE `p`.`site_id` = `s`.`id` AND `p`.`phone` = '60124128300');")
            ->expectsOutputToContain("`p`.`phone` IS NULL AND `p`.`name` = 'Kooceng'")
            ->expectsOutputToContain('-- skipped Kitikat Again')
            ->expectsOutputToContain('-- 5 statement(s)')
            ->assertSuccessful();

        $this->assertSame(0, MarketingProspect::count());
    }

    public function test_fails_for_an_unknown_client_or_missing_file(): void
    {
        $this->artisan('marketing:import', ['client_code' => 'nobody', 'csv' => $this->csv])->assertFailed();
        $this->artisan('marketing:import', ['client_code' => 'marketing', 'csv' => '/nonexistent.csv'])->assertFailed();
    }
}
