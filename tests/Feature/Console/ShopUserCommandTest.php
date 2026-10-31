<?php

namespace Tests\Feature\Console;

use App\Models\Client;
use App\Models\Site;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Tests\TestCase;

class ShopUserCommandTest extends TestCase
{
    use RefreshDatabase;

    private Site $site;

    protected function setUp(): void
    {
        parent::setUp();
        $this->site = Site::factory()->for(Client::factory()->state(['client_code' => 'lzhub']))->create();
    }

    public function test_creates_then_updates_the_login_locally(): void
    {
        $this->artisan('shop:user lzhub --role=owner --email=owner@example.com --name=Pemilik')
            ->expectsQuestion('Password (min 8 characters)', 'rahsia-kuat-1')
            ->expectsQuestion('Confirm password', 'rahsia-kuat-1')
            ->expectsOutputToContain('Created owner user')
            ->assertSuccessful();

        $user = User::query()->where('email', 'owner@example.com')->firstOrFail();
        $this->assertSame($this->site->id, $user->site_id);
        $this->assertSame('owner', $user->role->value);
        $this->assertTrue(Hash::check('rahsia-kuat-1', $user->password));

        $this->artisan('shop:user lzhub --role=staff --email=owner@example.com --name=Staf')
            ->expectsQuestion('Password (min 8 characters)', 'rahsia-baharu-2')
            ->expectsQuestion('Confirm password', 'rahsia-baharu-2')
            ->expectsOutputToContain('Updated staff user')
            ->assertSuccessful();

        $this->assertSame(1, User::count());
        $this->assertTrue(Hash::check('rahsia-baharu-2', $user->fresh()->password));
    }

    public function test_rejects_short_or_mismatched_passwords_and_customer_role(): void
    {
        $this->artisan('shop:user lzhub --email=owner@example.com --name=Pemilik')
            ->expectsQuestion('Password (min 8 characters)', 'short')
            ->expectsQuestion('Confirm password', 'short')
            ->assertFailed();

        $this->artisan('shop:user lzhub --email=owner@example.com --name=Pemilik')
            ->expectsQuestion('Password (min 8 characters)', 'rahsia-kuat-1')
            ->expectsQuestion('Confirm password', 'rahsia-kuat-2')
            ->expectsOutputToContain('The passwords do not match.')
            ->assertFailed();

        $this->artisan('shop:user lzhub --role=customer --email=owner@example.com --name=Pemilik')->assertFailed();
        $this->artisan('shop:user nobody --email=owner@example.com --name=Pemilik')->assertFailed();

        $this->assertSame(0, User::count());
    }

    public function test_sql_option_prints_an_idempotent_statement_without_writing(): void
    {
        $this->artisan("shop:user lzhub --role=owner --email=owner@example.com --name=\"O'Neil\" --sql")
            ->expectsQuestion('Password (min 8 characters)', 'rahsia-kuat-1')
            ->expectsQuestion('Confirm password', 'rahsia-kuat-1')
            ->expectsOutputToContain('-- shop:user lzhub --role=owner')
            ->expectsOutputToContain("WHERE `c`.`client_code` = 'lzhub'")
            ->expectsOutputToContain("'O''Neil', 'owner@example.com', '$2y$")
            ->expectsOutputToContain('ON DUPLICATE KEY UPDATE `name` = VALUES(`name`), `password` = VALUES(`password`)')
            ->doesntExpectOutputToContain('rahsia-kuat-1')
            ->assertSuccessful();

        $this->assertSame(0, User::count());

        // The target site is resolved on the database that runs the statement, so an unknown local client only warns.
        $this->artisan('shop:user other-shop --role=staff --email=staf@example.com --name=Staf --sql')
            ->expectsQuestion('Password (min 8 characters)', 'rahsia-kuat-1')
            ->expectsQuestion('Confirm password', 'rahsia-kuat-1')
            ->expectsOutputToContain('not in the local database')
            ->expectsOutputToContain("`client_code` = 'other-shop'")
            ->assertSuccessful();
    }
}
