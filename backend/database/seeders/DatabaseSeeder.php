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
        $this->call([
            RoleSeeder::class,
            AdminSeeder::class,
            ComplaintSeeder::class,
            NoShowWarningSeeder::class,
            ProjectSeeder::class,
            ProjectTaskSeeder::class,
            PaymentsSeeder::class,
            PaymentAuditSeeder::class,
            WalletTransactionSeeder::class,
            ContractorPostSeeder::class,
            ProjectReviewSeeder::class
        ]);
    }
}
