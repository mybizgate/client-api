<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database: the lzhub shop catalogue (idempotent).
     * Owner/staff logins are created with `php artisan shop:user lzhub`.
     */
    public function run(): void
    {
        $this->call(ShopLzhubSeeder::class);
    }
}
