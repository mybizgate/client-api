<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

/**
 * Row of the demo "sample" table (see SampleController).
 *
 * @property int $id
 * @property string $title
 * @property string|null $description
 * @property bool $is_active
 */
class Sample extends Model
{
    protected $table = 'sample';

    /** Mirrors the column default so a freshly created row serialises completely. */
    protected $attributes = [
        'is_active' => true,
    ];

    protected $fillable = [
        'title',
        'description',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'is_active' => 'boolean',
        ];
    }
}
