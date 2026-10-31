<?php

namespace Tests\Feature\Shop;

use App\Mail\PasswordResetMail;
use App\Models\PasswordResetToken;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Mail;
use Tests\TestCase;

class PasswordResetTest extends TestCase
{
    use InteractsWithShop;
    use RefreshDatabase;

    private const string FORGOT_MESSAGE = 'Jika e-mel ini berdaftar sebagai pemilik atau staf, pautan tetapan semula telah dihantar. Semak peti masuk dan folder spam anda.';

    protected function setUp(): void
    {
        parent::setUp();
        $this->setUpShop();
        Mail::fake();
        config(['shop.frontend_url' => 'http://localhost:5173']);
    }

    /** Requests a link for the e-mail and returns the raw token taken from the mailed URL. */
    private function requestToken(string $email, string $code = 'lzhub'): string
    {
        $this->postJson('/api/v1/auth/forgot-password', ['email' => $email], $this->headers(code: $code))->assertOk()->assertJsonPath('message', self::FORGOT_MESSAGE);

        $token = '';
        Mail::assertSent(PasswordResetMail::class, function (PasswordResetMail $mail) use ($email, &$token): bool {
            parse_str((string) parse_url($mail->url, PHP_URL_QUERY), $query);
            $token = (string) ($query['token'] ?? '');

            return $mail->hasTo($email) && $query['email'] === $email;
        });

        return $token;
    }

    public function test_owner_receives_a_link_and_can_set_a_new_password(): void
    {
        $owner = User::factory()->for($this->site)->owner()->create(['email' => 'owner@lzhub.test', 'password' => 'old-secret-1', 'name' => 'Pemilik']);
        $oldToken = $owner->createToken('shop-manage')->plainTextToken;

        $token = $this->requestToken('owner@lzhub.test');

        $this->assertSame(64, strlen($token));
        Mail::assertSent(PasswordResetMail::class, fn (PasswordResetMail $mail) => str_starts_with($mail->url, 'http://localhost:5173/reset-password?token=')
            && $mail->site->is($this->site)
            && $mail->envelope()->subject === "Tetapan semula kata laluan – {$this->site->site_name}");
        $row = PasswordResetToken::query()->findOrFail($owner->id);
        $this->assertSame(hash('sha256', $token), $row->token);
        $this->assertNotSame($token, $row->token);
        $this->assertTrue($row->expires_at->between(now()->addMinutes(59), now()->addMinutes(61)));

        $this->postJson('/api/v1/auth/reset-password', ['email' => 'owner@lzhub.test', 'token' => $token, 'password' => 'new-secret-9', 'password_confirmation' => 'new-secret-9'], $this->headers())
            ->assertOk()->assertJsonPath('message', 'Kata laluan telah ditetapkan semula. Sila log masuk dengan kata laluan baharu anda.');

        $this->assertTrue(Hash::check('new-secret-9', $owner->refresh()->password));
        $this->assertDatabaseCount('password_reset_tokens', 0);
        $this->getJson('/api/v1/auth/me', $this->headers($oldToken))->assertStatus(401);
        $this->postJson('/api/v1/auth/login', ['email' => 'owner@lzhub.test', 'password' => 'new-secret-9'], $this->headers())->assertOk();

        // A token is single-use.
        $this->postJson('/api/v1/auth/reset-password', ['email' => 'owner@lzhub.test', 'token' => $token, 'password' => 'another-10', 'password_confirmation' => 'another-10'], $this->headers())
            ->assertStatus(422)->assertJsonValidationErrors(['token']);
    }

    public function test_unknown_customer_disabled_and_other_site_emails_get_the_same_answer_without_mail(): void
    {
        User::factory()->for($this->site)->create(['email' => 'customer@lzhub.test']);
        User::factory()->for($this->site)->staff()->disabled()->create(['email' => 'gone@lzhub.test']);
        User::factory()->for($this->otherSite())->owner()->create(['email' => 'owner@other.test']);

        foreach (['nobody@lzhub.test', 'customer@lzhub.test', 'gone@lzhub.test', 'owner@other.test'] as $email) {
            $this->postJson('/api/v1/auth/forgot-password', ['email' => $email], $this->headers())->assertOk()->assertJsonPath('message', self::FORGOT_MESSAGE);
        }

        Mail::assertNothingSent();
        $this->assertDatabaseCount('password_reset_tokens', 0);
        $this->postJson('/api/v1/auth/forgot-password', ['email' => 'not-an-email'], $this->headers())->assertStatus(422)->assertJsonPath('errors.email.0', 'Sila masukkan e-mel yang sah.');
    }

    public function test_reset_rejects_wrong_expired_or_foreign_tokens_and_weak_passwords(): void
    {
        User::factory()->for($this->site)->owner()->create(['email' => 'owner@lzhub.test', 'password' => 'old-secret-1']);
        $other = $this->otherSite();
        User::factory()->for($other)->owner()->create(['email' => 'owner@lzhub.test', 'password' => 'old-secret-1']);

        $token = $this->requestToken('owner@lzhub.test');
        $reset = fn (array $overrides, string $code = 'lzhub') => $this->postJson('/api/v1/auth/reset-password', array_replace(['email' => 'owner@lzhub.test', 'token' => $token, 'password' => 'new-secret-9', 'password_confirmation' => 'new-secret-9'], $overrides), $this->headers(code: $code));

        $reset(['token' => str_repeat('a', 64)])->assertStatus(422)->assertJsonPath('errors.token.0', 'Pautan tetapan semula tidak sah atau telah tamat tempoh. Sila minta pautan baharu.');
        $reset(['token' => 'short'])->assertStatus(422)->assertJsonValidationErrors(['token']);
        $reset(['password' => 'short', 'password_confirmation' => 'short'])->assertStatus(422)->assertJsonPath('errors.password.0', 'Kata laluan mesti sekurang-kurangnya 8 aksara.');
        $reset(['password_confirmation' => 'different-9'])->assertStatus(422)->assertJsonPath('errors.password.0', 'Pengesahan kata laluan tidak sepadan.');
        // Same e-mail on another site: the token belongs to the lzhub user only.
        $reset([], $other->client->client_code)->assertStatus(422)->assertJsonValidationErrors(['token']);

        $this->travel(61)->minutes();
        $reset([])->assertStatus(422)->assertJsonValidationErrors(['token']);
        $this->assertTrue(Hash::check('old-secret-1', User::query()->where('site_id', $this->site->id)->firstOrFail()->password));
    }

    public function test_a_new_request_replaces_the_previous_token_and_links_use_the_site_domain_by_default(): void
    {
        config(['shop.frontend_url' => null]);
        User::factory()->for($this->site)->owner()->create(['email' => 'owner@lzhub.test']);

        $first = $this->requestToken('owner@lzhub.test');
        $second = $this->requestToken('owner@lzhub.test');

        $this->assertNotSame($first, $second);
        $this->assertDatabaseCount('password_reset_tokens', 1);
        Mail::assertSent(PasswordResetMail::class, 2);
        Mail::assertSent(PasswordResetMail::class, fn (PasswordResetMail $mail) => str_starts_with($mail->url, "https://{$this->site->domain}/reset-password?token="));

        $this->postJson('/api/v1/auth/reset-password', ['email' => 'owner@lzhub.test', 'token' => $first, 'password' => 'new-secret-9', 'password_confirmation' => 'new-secret-9'], $this->headers())->assertStatus(422);
        $this->postJson('/api/v1/auth/reset-password', ['email' => 'owner@lzhub.test', 'token' => $second, 'password' => 'new-secret-9', 'password_confirmation' => 'new-secret-9'], $this->headers())->assertOk();
    }

    public function test_mail_renders_the_link_in_malay(): void
    {
        $owner = User::factory()->for($this->site)->owner()->create(['name' => 'Pemilik', 'email' => 'owner@lzhub.test']);
        $mail = new PasswordResetMail($owner, $this->site, 'http://localhost:5173/reset-password?token=abc&email=owner%40lzhub.test', 60);

        $mail->assertSeeInHtml('Hai Pemilik,')
            ->assertSeeInHtml('http://localhost:5173/reset-password?token=abc&email=owner%40lzhub.test')
            ->assertSeeInHtml('sah selama 60 minit')
            ->assertSeeInText('http://localhost:5173/reset-password?token=abc&email=owner%40lzhub.test');
    }
}
