<?php

namespace Tests\Feature;

use App\Models\ConstructionForm;
use App\Models\Payment;
use App\Models\Wallet;
use App\Services\Auth\OtpService;
use App\Services\InvoiceService;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PaymentWorkflowTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(\Database\Seeders\RoleSeeder::class);

        // Mock OtpService — we don't want real OTP emails in tests
        $this->mock(OtpService::class, function ($mock) {
            $mock->shouldReceive('send')->andReturn(true);
            $mock->shouldReceive('verifyPaymentOtp')->andReturn(true);
        });

        // Mock InvoiceService — not what we're testing
        $this->mock(InvoiceService::class, function ($mock) {
            $mock->shouldReceive('create')->andReturn(true);
            $mock->shouldReceive('createReleaseInvoice')->andReturn(true);
        });
    }

    // ─────────────────────────────────────────────────
    // Viewing pending payments
    // ─────────────────────────────────────────────────

    public function test_user_can_view_their_pending_payments(): void
    {
        $project = $this->createFullProject();

        Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        $response = $this->withHeaders($this->authHeaders($project['user']))
            ->getJson('/api/payments/pending');

        $response->assertStatus(200);
        $this->assertCount(1, $response->json());
    }

    public function test_user_only_sees_their_own_pending_payments(): void
    {
        $project1 = $this->createFullProject();
        $project2 = $this->createFullProject();

        Payment::factory()->create([
            'construction_form_id' => $project1['form']->id,
            'user_id'              => $project1['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        // project2 user should see empty
        $response = $this->withHeaders($this->authHeaders($project2['user']))
            ->getJson('/api/payments/pending');

        $response->assertStatus(200);
        $this->assertCount(0, $response->json());
    }

    // ─────────────────────────────────────────────────
    // Sending OTP before payment
    // ─────────────────────────────────────────────────

    public function test_user_can_request_otp_for_their_payment(): void
    {
        $project = $this->createFullProject();

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        $response = $this->withHeaders($this->authHeaders($project['user']))
            ->postJson("/api/payments/{$payment->id}/send-otp");

        $response->assertStatus(200);
    }

    public function test_user_cannot_request_otp_for_another_users_payment(): void
    {
        $project1 = $this->createFullProject();
        $project2 = $this->createFullProject();

        $payment = Payment::factory()->create([
            'construction_form_id' => $project1['form']->id,
            'user_id'              => $project1['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        $this->withHeaders($this->authHeaders($project2['user']))
            ->postJson("/api/payments/{$payment->id}/send-otp")
            ->assertStatus(403);
    }

    // ─────────────────────────────────────────────────
    // Paying
    // ─────────────────────────────────────────────────

    public function test_user_can_pay_their_pending_payment(): void
    {
        $admin = $this->createAdmin();
        $project = $this->createFullProject();

        // Set user wallet balance high enough
        $project['user']->wallet->update(['balance' => 1000000]);

        // Admin wallet must exist

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        $response = $this->withHeaders($this->authHeaders($project['user']))
            ->postJson("/api/payments/{$payment->id}/pay", [
                'otp' => '1234',
            ]);

        $response->assertStatus(200);

        $this->assertDatabaseHas('payments', [
            'id'     => $payment->id,
            'status' => 'paid',
        ]);
    }

    public function test_payment_deducts_from_user_wallet(): void
    {
        $admin = $this->createAdmin();
        $project = $this->createFullProject();
        $project['user']->wallet->update(['balance' => 1000000]);


        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        $balanceBefore = $project['user']->wallet->balance;

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson("/api/payments/{$payment->id}/pay", [
                'otp' => '1234',
            ]);

        $project['user']->wallet->refresh();

        $this->assertEquals(
            $balanceBefore - $payment->amount,
            $project['user']->wallet->balance,
            'Wallet balance should have decreased exactly by the payment amount'
        );

        $this->assertDatabaseCount('wallet_transactions', 2);
    }

    public function test_payment_deposits_to_admin_wallet(): void
    {
        $admin = $this->createAdmin();
        $project = $this->createFullProject();
        $project['user']->wallet->update(['balance' => 1000000]);

        $adminWallet = $admin->wallet;
        $adminBalanceBefore = $adminWallet->balance;

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson("/api/payments/{$payment->id}/pay", [
                'otp' => '1234',
            ]);

        $adminWallet->refresh();
        $this->assertGreaterThan($adminBalanceBefore, $adminWallet->balance);
    }

    public function test_cannot_pay_already_paid_payment(): void
    {
        $project = $this->createFullProject();

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'paid',
        ]);

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson("/api/payments/{$payment->id}/pay", [
                'otp' => '1234',
            ])
            ->assertStatus(422);
    }

    public function test_user_cannot_pay_another_users_payment(): void
    {
        $project1 = $this->createFullProject();
        $project2 = $this->createFullProject();

        $payment = Payment::factory()->create([
            'construction_form_id' => $project1['form']->id,
            'user_id'              => $project1['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        $this->withHeaders($this->authHeaders($project2['user']))
            ->postJson("/api/payments/{$payment->id}/pay", [
                'otp' => '1234',
            ])
            ->assertStatus(403);
    }

    public function test_payment_creates_audit_record(): void
    {
        $admin = $this->createAdmin();
        $project = $this->createFullProject();
        $project['user']->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson("/api/payments/{$payment->id}/pay", [
                'otp' => '1234',
            ]);

        $this->assertDatabaseHas('payment_audits', [
            'payment_id'   => $payment->id,
            'from_user_id' => $project['user']->id,
            'to_user_id'   => $admin->id,
        ]);
    }

    // ─────────────────────────────────────────────────
    // Admin releases payment to contractor
    // ─────────────────────────────────────────────────

    public function test_admin_can_release_payment_to_contractor(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $admin->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'paid',
            'released_amount'      => 0,
        ]);

        $contractorBalanceBefore = $project['contractor']->wallet->balance;

        $response = $this->withHeaders($this->authHeaders($admin))
            ->postJson("/api/admin/payments/{$payment->id}/release", [
                'amount' => 150000,
            ]);

        $response->assertStatus(200);

        $project['contractor']->wallet->refresh();
        $this->assertEquals(
            $contractorBalanceBefore + 150000,
            $project['contractor']->wallet->balance
        );
    }

     public function test_admin_cannot_release_final_payment_to_contractor_during_warranty(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $admin->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'final_payment',
            'status'               => 'paid',
            'released_amount'      => 0,
        ]);

        $contractorBalanceBefore = $project['contractor']->wallet->balance;

        $response = $this->withHeaders($this->authHeaders($admin))
            ->postJson("/api/admin/payments/{$payment->id}/release", [
                'amount' => 150000,
            ]);

        $response->assertStatus(422);

        $project['contractor']->wallet->refresh();
        $this->assertEquals(
            $contractorBalanceBefore ,
            $project['contractor']->wallet->balance
        );
    }

    public function test_admin_cannot_release_more_than_payment_amount(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $admin->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'paid',
            'released_amount'      => 0,
        ]);

        $this->withHeaders($this->authHeaders($admin))
            ->postJson("/api/admin/payments/{$payment->id}/release", [
                'amount' => 400000, // more than payment amount
            ])
            ->assertStatus(422);
    }

    public function test_payment_status_becomes_released_when_fully_released(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $admin->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'paid',
            'released_amount'      => 0,
        ]);

        $this->withHeaders($this->authHeaders($admin))
            ->postJson("/api/admin/payments/{$payment->id}/release", [
                'amount' => 300000, // full amount
            ]);

        $this->assertDatabaseHas('payments', [
            'id'     => $payment->id,
            'status' => 'released',
        ]);
    }

    public function test_cannot_release_unpaid_payment(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending', // not paid yet
            'released_amount'      => 0,
        ]);

        $this->withHeaders($this->authHeaders($admin))
            ->postJson("/api/admin/payments/{$payment->id}/release", [
                'amount' => 150000,
            ])
            ->assertStatus(422);
    }

    public function test_non_admin_cannot_release_payment(): void
    {
        $project = $this->createFullProject();

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'paid',
            'released_amount'      => 0,
        ]);

        $this->withHeaders($this->authHeaders($project['user']))
            ->postJson("/api/admin/payments/{$payment->id}/release", [
                'amount' => 150000,
            ])
            ->assertStatus(403);
    }

    public function test_release_creates_audit_record(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();

        $admin->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'paid',
            'released_amount'      => 0,
        ]);

        $this->withHeaders($this->authHeaders($admin))
            ->postJson("/api/admin/payments/{$payment->id}/release", [
                'amount' => 150000,
            ]);

        $this->assertDatabaseHas('payment_audits', [
            'payment_id'   => $payment->id,
            'from_user_id' => $admin->id,
            'to_user_id'   => $project['contractor']->id,
            'action'       => 'release',
        ]);
    }
}
