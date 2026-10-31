<?php

namespace Database\Factories;

use App\Models\Client;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Client>
 */
class ClientFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'client_code' => fake()->unique()->regexify('[a-z]{3,8}[0-9]{0,2}'),
            'business_name' => fake()->company(),
            'registration_no' => null,
            'business_nature' => 'supplier',
            'contact_person' => fake()->name(),
            'email' => fake()->unique()->safeEmail(),
            'phone_primary' => '+60123456789',
            'phone_secondary' => null,
            'address_line1' => fake()->streetAddress(),
            'address_line2' => null,
            'city' => 'Kuala Lumpur',
            'state' => 'Wilayah Persekutuan Kuala Lumpur',
            'postcode' => '53100',
            'country' => 'MY',
            'remarks' => null,
        ];
    }
}
