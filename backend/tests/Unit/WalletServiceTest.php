<?php

namespace Tests\Unit;

use App\Models\Wallet;
use App\Models\WalletTransaction;
use App\Services\WalletService;
use Database\Seeders\RoleSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class WalletServiceTest extends TestCase
{
    use RefreshDatabase;

    protected WalletService $service;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleSeeder::class);
        $this->service = app(WalletService::class);
    }

    // ─────────────────────────────────────────────────
    // deposit()
    // ─────────────────────────────────────────────────

    public function test_deposit_increases_wallet_balance(): void
    {
        $user   = $this->createUser();
        $wallet = $user->wallet;

        $balanceBefore = $wallet->balance;
        $this->service->deposit($wallet, 50000, 'test deposit');
        $wallet->refresh();

        $this->assertEquals($balanceBefore + 50000, $wallet->balance);
    }

    public function test_deposit_creates_wallet_transaction(): void
    {
        $user   = $this->createUser();
        $wallet = $user->wallet;

        $this->service->deposit($wallet, 50000, 'test deposit');

        $this->assertDatabaseHas('wallet_transactions', [
            'wallet_id'   => $wallet->id,
            'amount'      => 50000,
            'type'        => 'deposit',
            'description' => 'test deposit',
        ]);
    }

    public function test_deposit_with_zero_amount_still_works(): void
    {
        $user   = $this->createUser();
        $wallet = $user->wallet;

        $balanceBefore = $wallet->balance;
        $this->service->deposit($wallet, 0, 'zero deposit');
        $wallet->refresh();

        $this->assertEquals($balanceBefore, $wallet->balance);
    }

    // ─────────────────────────────────────────────────
    // withdraw()
    // ─────────────────────────────────────────────────

    public function test_withdraw_decreases_wallet_balance(): void
    {
        $user   = $this->createUser();
        $wallet = $user->wallet;
        $wallet->update(['balance' => 100000]);

        $this->service->withdraw($wallet, 30000, 'test withdraw');
        $wallet->refresh();

        $this->assertEquals(70000, $wallet->balance);
    }

    public function test_withdraw_creates_wallet_transaction(): void
    {
        $user   = $this->createUser();
        $wallet = $user->wallet;
        $wallet->update(['balance' => 100000]);

        $this->service->withdraw($wallet, 30000, 'test withdraw');

        $this->assertDatabaseHas('wallet_transactions', [
            'wallet_id'   => $wallet->id,
            'amount'      => 30000,
            'type'        => 'withdraw',
            'description' => 'test withdraw',
        ]);
    }

    public function test_withdraw_throws_exception_when_balance_insufficient(): void
    {
        $user   = $this->createUser();
        $wallet = $user->wallet;
        $wallet->update(['balance' => 1000]);

        $this->expectException(\Exception::class);
        $this->expectExceptionMessage('الرصيد غير كافٍ');

        $this->service->withdraw($wallet, 5000, 'overdraft attempt');
    }

    public function test_withdraw_exact_balance_succeeds(): void
    {
        $user   = $this->createUser();
        $wallet = $user->wallet;
        $wallet->update(['balance' => 50000]);

        $this->service->withdraw($wallet, 50000, 'exact withdrawal');
        $wallet->refresh();

        $this->assertEquals(0, $wallet->balance);
    }

    // ─────────────────────────────────────────────────
    // Transaction integrity
    // ─────────────────────────────────────────────────

    public function test_failed_withdraw_does_not_change_balance(): void
    {
        $user   = $this->createUser();
        $wallet = $user->wallet;
        $wallet->update(['balance' => 1000]);

        $balanceBefore = $wallet->balance;

        try {
            $this->service->withdraw($wallet, 5000, 'overdraft');
        } catch (\Exception $e) {
            // expected
        }

        $wallet->refresh();
        $this->assertEquals($balanceBefore, $wallet->balance);
    }

    public function test_multiple_deposits_accumulate_correctly(): void
    {
        $user   = $this->createUser();
        $wallet = $user->wallet;
        $wallet->update(['balance' => 0]);

        $this->service->deposit($wallet, 100000, 'first');
        $this->service->deposit($wallet, 200000, 'second');
        $this->service->deposit($wallet, 50000,  'third');

        $wallet->refresh();
        $this->assertEquals(350000, $wallet->balance);
    }
}