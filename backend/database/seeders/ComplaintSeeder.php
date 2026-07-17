<?php

namespace Database\Seeders;

use App\Models\Complaint;
use App\Models\ComplaintImage;
use App\Models\ConstructionForm;
use App\Models\ContractorProfile;
use App\Models\EngineerProfile;
use App\Models\ReconstructionRequest;
use App\Models\Role;
use App\Models\User;
use App\Models\UserProfile;
use App\Models\Wallet;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class ComplaintSeeder extends Seeder
{
    public function run(): void
    {
        $userRoleId       = Role::where('name', 'user')->firstOrFail()->id;
        $contractorRoleId = Role::where('name', 'contractor')->firstOrFail()->id;
        $engineerRoleId   = Role::where('name', 'engineer')->firstOrFail()->id;

        // users
        $user = User::create([
            'email'        => 'seed_user@renova.com',
            'name'         => 'Seed User',
            'role_id'      => $userRoleId,
            'status'       => 'approved',
            'is_active'    => true,
            'password'     => Hash::make('password'),
            'otp_verified' => true,
        ]);
        UserProfile::create(['user_id' => $user->id, 'first_name' => 'Ahmad', 'last_name' => 'Nasser', 'phone' => '+963912100001', 'location' => 'Damascus']);
        Wallet::create(['user_id' => $user->id, 'balance' => 500000.00, 'card_number' => 'SD-USER-' . rand(1000, 9999)]);

        $contractor = User::create([
            'email'        => 'seed_contractor@renova.com',
            'name'         => 'Seed Contractor',
            'role_id'      => $contractorRoleId,
            'status'       => 'approved',
            'is_active'    => true,
            'password'     => Hash::make('password'),
            'otp_verified' => true,
        ]);
        ContractorProfile::create(['user_id' => $contractor->id, 'first_name' => 'Samer', 'last_name' => 'Ali', 'phone' => '+963912100002', 'location' => 'Aleppo', 'company_name' => 'Seed Contracting Co.', 'commercial_record' => 'CR-SEED-001']);
        Wallet::create(['user_id' => $contractor->id, 'balance' => 300000.00, 'card_number' => 'SD-CONT-' . rand(1000, 9999)]);

        $engineer = User::create([
            'email'        => 'seed_engineer@renova.com',
            'name'         => 'Seed Engineer',
            'role_id'      => $engineerRoleId,
            'status'       => 'approved',
            'is_active'    => true,
            'password'     => Hash::make('password'),
            'otp_verified' => true,
        ]);
        EngineerProfile::create(['user_id' => $engineer->id, 'specialization' => 'Civil Engineering', 'syndicate_number' => 'SYN-SEED-001', 'degree' => 'Bachelor', 'years_of_experience' => 5, 'covered_zones' => 'Damascus', 'is_verified' => true]);
        Wallet::create(['user_id' => $engineer->id, 'balance' => 150000.00, 'card_number' => 'SD-ENG-' . rand(1000, 9999)]);

        $reconstructionRequest = ReconstructionRequest::create([
            'user_id' => $user->id,
            'title' => 'Seed Complaint Project',
            'description' => 'مشروع اختبار الشكاوي',
            'location' => 'Damascus',
            'type' => 'construction',
            'status' => 'open',
        ]);

        $form = ConstructionForm::create([
            'reconstruction_request_id' => $reconstructionRequest->id,
            'contractor_id'       => $contractor->id,
            'engineer_id'         => $engineer->id,
            'building_description' => 'مبنى سكني ثلاثة طوابق',
            'warranty_period'     => '12 months',
            'execution_duration'  => '8 months',
            'materials_cost'      => 600000.00,
            'labor_cost'          => 250000.00,
            'profit'              => 150000.00,
            'total_cost'          => 1000000.00,
            'status'              => 'user_approved',
        ]);

        $base = [
            'construction_form_id' => $form->id,
            'type'                 => 'general',
            'status'               => 'open',
        ];

        $complaints = [
            // 1 - open - no description - user on contractor
            array_merge($base, ['complainant_id' => $user->id, 'complained_on_id' => $contractor->id, 'complainant_role_id' => $userRoleId, 'complained_on_role_id' => $contractorRoleId, 'reason' => 'رداءة جودة العمل', 'description' => null]),
            // 2 - open - with description - user on contractor
            array_merge($base, ['complainant_id' => $user->id, 'complained_on_id' => $contractor->id, 'complainant_role_id' => $userRoleId, 'complained_on_role_id' => $contractorRoleId, 'reason' => 'عدم الالتزام بالجدول الزمني', 'description' => 'تأخر المتعهد أكثر من شهرين']),
            // 3 - open - contractor on user
            array_merge($base, ['complainant_id' => $contractor->id, 'complained_on_id' => $user->id, 'complainant_role_id' => $contractorRoleId, 'complained_on_role_id' => $userRoleId, 'reason' => 'التأخر في الدفع', 'description' => 'لم يدفع الدفعة الثانية في موعدها']),
            // 4 - open - contractor on user - no description
            array_merge($base, ['complainant_id' => $contractor->id, 'complained_on_id' => $user->id, 'complainant_role_id' => $contractorRoleId, 'complained_on_role_id' => $userRoleId, 'reason' => 'عدم التعاون', 'description' => null]),
            // 5 - open - user on contractor - detailed
            array_merge($base, ['complainant_id' => $user->id, 'complained_on_id' => $contractor->id, 'complainant_role_id' => $userRoleId, 'complained_on_role_id' => $contractorRoleId, 'reason' => 'رداءة جودة العمل', 'description' => 'المواد لا تتوافق مع ما تم الاتفاق عليه']),
            // 6 - resolved with penalty 10% = 30,000
            array_merge($base, ['complainant_id' => $user->id, 'complained_on_id' => $contractor->id, 'complainant_role_id' => $userRoleId, 'complained_on_role_id' => $contractorRoleId, 'reason' => 'عدم الالتزام بالجدول الزمني', 'description' => 'تأخر كبير', 'status' => 'resolved', 'admin_processing_note' => 'تم خصم 10% من المبلغ المحجوز', 'penalty_percentage' => 10.00, 'penalty_amount' => 30000.00, 'compensation_amount' => 30000.00, 'resolved_at' => now()->subDays(5)]),
            // 7 - resolved without penalty
            array_merge($base, ['complainant_id' => $contractor->id, 'complained_on_id' => $user->id, 'complainant_role_id' => $contractorRoleId, 'complained_on_role_id' => $userRoleId, 'reason' => 'التأخر في الدفع', 'description' => 'تأخر في الدفعة الأولى', 'status' => 'resolved', 'admin_processing_note' => 'التأخير بسبب مشكلة تقنية', 'resolved_at' => now()->subDays(3)]),
            // 8 - dismissed - user on contractor
            array_merge($base, ['complainant_id' => $user->id, 'complained_on_id' => $contractor->id, 'complainant_role_id' => $userRoleId, 'complained_on_role_id' => $contractorRoleId, 'reason' => 'رداءة جودة العمل', 'description' => 'شكوى مرفوضة', 'status' => 'dismissed', 'admin_processing_note' => 'العمل يطابق المواصفات', 'resolved_at' => now()->subDays(1)]),
            // 9 - dismissed - contractor on user
            array_merge($base, ['complainant_id' => $contractor->id, 'complained_on_id' => $user->id, 'complainant_role_id' => $contractorRoleId, 'complained_on_role_id' => $userRoleId, 'reason' => 'عدم التعاون', 'description' => 'شكوى مرفوضة', 'status' => 'dismissed', 'admin_processing_note' => 'الشكوى غير مبررة', 'resolved_at' => now()->subDays(2)]),
            // 10 - resolved with penalty 20% = 60,000
            array_merge($base, ['complainant_id' => $user->id, 'complained_on_id' => $contractor->id, 'complainant_role_id' => $userRoleId, 'complained_on_role_id' => $contractorRoleId, 'reason' => 'رداءة جودة العمل', 'description' => 'أضرار جسيمة بسبب إهمال المتعهد', 'status' => 'resolved', 'admin_processing_note' => 'تم خصم 20% من المبلغ المحجوز', 'penalty_percentage' => 20.00, 'penalty_amount' => 60000.00, 'compensation_amount' => 60000.00, 'resolved_at' => now()->subDay()]),
        ];

        $createdComplaints = [];
        foreach ($complaints as $data) {
            $createdComplaints[] = Complaint::create($data);
        }

        // صورة واحدة للشكوى الأولى فقط
        $source    = database_path('seeders/images/complaint.png');
        $imagePath = 'complaints/complaint.png';

        Storage::disk('public')->put(
            $imagePath,
            file_get_contents($source)
        );

        ComplaintImage::create([
            'complaint_id' => $createdComplaints[0]->id,
            'image'        => $imagePath,
        ]);

        $this->command->info('');
        $this->command->info('✅ ComplaintSeeder done — 10 complaints created');
        $this->command->info('─────────────────────────────────────────────');
        $this->command->info("👤 User:      seed_user@renova.com / password       (id: {$user->id})");
        $this->command->info("🏗️  Contractor: seed_contractor@renova.com / password (id: {$contractor->id})");
        $this->command->info("👷 Engineer:  seed_engineer@renova.com / password    (id: {$engineer->id})");
        $this->command->info("📝 Form ID:   {$form->id}  (total: 1,000,000 → held 30% = 300,000)");
        $this->command->info('─────────────────────────────────────────────');
        $this->command->info('📊 5 open | 3 resolved | 2 dismissed');
        $this->command->info("🖼️  1 image on complaint id: {$createdComplaints[0]->id}");
        $this->command->info('💰 Complaint #6 → 10% = 30,000 | Complaint #10 → 20% = 60,000');
        $this->command->info('');
    }
}
