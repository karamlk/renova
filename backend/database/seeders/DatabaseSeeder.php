<?php

namespace Database\Seeders;

use App\Models\User;
// use Database\Seeders\PaymentsSeeder ;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
// use PaymentsSeeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        User::factory()->create([
            'name' => 'Test User',
            'email' => 'test@example.com',
        ]);
    }

}
$this->call([
    UserSeeder::class,
    ContractorProfileSeeder::class,
]);
$this->call([
    UserSeeder::class,
    ContractorProfileSeeder::class,
    ReconstructionRequestSeeder::class,
]);
$this->call([
    ContractorScheduleSeeder::class,
]);
$this->call([
    PaymentsSeeder::class,
    PaymentAuditSeeder::class,
]);

//   $this->call([
//             RoleSeeder::class,
//             AdminSeeder::class,
//             ComplaintSeeder::class,
//             NoShowWarningSeeder::class,
//             ProjectSeeder::class,
//             ProjectTaskSeeder::class,
//             PaymentsSeeder::class,
//             PaymentAuditSeeder::class,
//             WalletTransactionSeeder::class,
//             ContractorPostSeeder::class,
//             ProjectReviewSeeder::class
//         ]);