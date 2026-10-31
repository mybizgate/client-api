<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Registration and renewal payment ledger (database/table structure.md §3.5).
 *
 * Rows keep the amount and period that were actually charged, so later edits
 * to `sites.renewal_price` never rewrite history. Confirming a payment must
 * mark it `paid`, set `verified_at` and advance `sites.expiry_date` in one
 * transaction that locks the `sites` row (`lockForUpdate()`) and requires
 * `status = pending` in its WHERE clause, so the same row is never applied
 * twice. `period_end` is inclusive.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('payments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('site_id')->constrained()->restrictOnDelete();
            $table->string('payment_type', 20);            // registration | renewal
            $table->decimal('amount', 10, 2);
            $table->char('currency', 3)->default('MYR');
            $table->string('payment_method', 30)->nullable(); // bank_transfer | cash | other
            $table->string('reference_no', 100)->nullable();  // bank reference, not unique
            $table->string('status', 20)->default('pending'); // pending | paid | rejected
            $table->date('period_start');
            $table->date('period_end');                    // inclusive
            $table->timestamp('paid_at')->nullable();
            $table->timestamp('verified_at')->nullable();  // manual verification time
            $table->text('remarks')->nullable();
            $table->timestamps();

            $table->index(['site_id', 'status', 'period_end']);
        });

        if (in_array(DB::getDriverName(), ['mysql', 'mariadb'], true)) {
            DB::statement("ALTER TABLE `payments` ADD CONSTRAINT `payments_payment_type_check` CHECK (`payment_type` IN ('registration', 'renewal'))");
            DB::statement("ALTER TABLE `payments` ADD CONSTRAINT `payments_status_check` CHECK (`status` IN ('pending', 'paid', 'rejected'))");
            DB::statement('ALTER TABLE `payments` ADD CONSTRAINT `payments_amount_check` CHECK (`amount` >= 0)');
            DB::statement('ALTER TABLE `payments` ADD CONSTRAINT `payments_period_check` CHECK (`period_end` >= `period_start`)');
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('payments');
    }
};
