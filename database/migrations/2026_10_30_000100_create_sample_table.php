<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

/**
 * Demo table behind App\Http\Controllers\Api\SampleController: a plain CRUD
 * example used to verify that the API can read and write its database.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('sample', function (Blueprint $table) {
            $table->id();
            $table->string('title', 150);
            $table->text('description')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();

            $table->index(['is_active', 'created_at']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sample');
    }
};
