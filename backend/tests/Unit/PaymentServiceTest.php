<?php

namespace Tests\Unit;

use App\Models\Payment;
use App\Models\Wallet;
use App\Services\Auth\OtpService;
use App\Services\InvoiceService;
use App\Services\PaymentService;
use Database\Seeders\RoleSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class PaymentServiceTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->seed(RoleSeeder::class);

        $this->mock(OtpService::class, function ($mock) {
            $mock->shouldReceive('send')->andReturn(true);
            $mock->shouldReceive('verifyPaymentOtp')->andReturn(true);
        });

        $this->mock(InvoiceService::class, function ($mock) {
            $mock->shouldReceive('create')->andReturn(true);
            $mock->shouldReceive('createReleaseInvoice')->andReturn(true);
        });
    }

    // ─────────────────────────────────────────────────
    // pay() business rules
    // ─────────────────────────────────────────────────

    public function test_pay_changes_payment_status_to_paid(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();
        $project['user']->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        $this->actingAs($project['user']);

        app(PaymentService::class)->pay($payment);

        $payment->refresh();
        $this->assertEquals('paid', $payment->status);
    }

    public function test_pay_sets_paid_at_timestamp(): void
    {
        $project = $this->createFullProject();
        $admin   = $this->createAdmin();
        $project['user']->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);
        $this->actingAs($project['user']);

        app(PaymentService::class)->pay($payment);

        $payment->refresh();
        $this->assertNotNull($payment->paid_at);
    }

    public function test_pay_throws_exception_if_payment_already_paid(): void
    {
        $project = $this->createFullProject();

        $payment = Payment::factory()->paid()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
        ]);

        $this->expectException(\Exception::class);
        app(PaymentService::class)->pay($payment);
    }

    public function test_pay_throws_exception_if_wrong_user(): void
    {
        $project      = $this->createFullProject();
        $anotherUser  = $this->createUser();

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        $this->actingAs($anotherUser);

        $this->expectException(\Exception::class);
        app(PaymentService::class)->pay($payment);
    }

    public function test_pay_creates_payment_audit_record(): void
    {
        $project = $this->createFullProject();
        $admin   = $this->createAdmin();
        $project['user']->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
        ]);

        $this->actingAs($project['user']);
        app(PaymentService::class)->pay($payment);

        $this->assertDatabaseHas('payment_audits', [
            'payment_id'   => $payment->id,
            'from_user_id' => $project['user']->id,
            'amount'       => 300000,
        ]);
    }

    // ─────────────────────────────────────────────────
    // release() business rules
    // ─────────────────────────────────────────────────

    public function test_release_throws_exception_if_payment_not_paid(): void
    {
        $project = $this->createFullProject();

        $payment = Payment::factory()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'status'               => 'pending',
            'released_amount'      => 0,
        ]);

        $this->expectException(\Exception::class);
        $this->expectExceptionMessage('هذه الدفعة غير جاهزة للتحويل');

        app(PaymentService::class)->release($payment, 100000);
    }

    public function test_release_throws_exception_if_amount_exceeds_remaining(): void
    {
        $project = $this->createFullProject();
        $admin   = $this->createAdmin();
        $admin->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->paid()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'released_amount'      => 0,
        ]);

        $this->expectException(\Exception::class);
        $this->expectExceptionMessage('المبلغ أكبر من المتبقي');

        app(PaymentService::class)->release($payment, 400000);
    }

    public function test_release_increments_released_amount(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();
        $admin->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->paid()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'released_amount'      => 0,
        ]);

        app(PaymentService::class)->release($payment, 150000);

        $payment->refresh();
        $this->assertEquals(150000, $payment->released_amount);
    }

    public function test_payment_becomes_released_when_fully_released(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();
        $admin->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->paid()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'released_amount'      => 0,
        ]);

        app(PaymentService::class)->release($payment, 300000);

        $payment->refresh();
        $this->assertEquals('released', $payment->status);
    }

    public function test_partial_release_keeps_status_as_paid(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();
        $admin->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->paid()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'released_amount'      => 0,
        ]);

        app(PaymentService::class)->release($payment, 150000);

        $payment->refresh();
        $this->assertEquals('paid', $payment->status);
    }

    public function test_release_creates_audit_record(): void
    {
        $admin   = $this->createAdmin();
        $project = $this->createFullProject();
        $admin->wallet->update(['balance' => 1000000]);

        $payment = Payment::factory()->paid()->create([
            'construction_form_id' => $project['form']->id,
            'user_id'              => $project['user']->id,
            'amount'               => 300000,
            'type'                 => 'first_payment',
            'released_amount'      => 0,
        ]);

        app(PaymentService::class)->release($payment, 150000);

        $this->assertDatabaseHas('payment_audits', [
            'payment_id'   => $payment->id,
            'to_user_id'   => $project['contractor']->id,
            'amount'       => 150000,
            'action'       => 'release',
        ]);
    }
}
