<?php
namespace App\Services\Engineer;

use App\Models\User;
use App\Models\EngineerProfile;
use Illuminate\Support\Facades\Storage;

class EngineerProfileService {

    /**
     * تحديث أو إنشاء الملف الشخصي للمهندس مباشرة
     */
    public function updateEngineerProfile(User $user, array $data): void
    {
        // تحديث أو إنشاء البيانات في جدول المهندس مباشرة دون الحاجة للجدول العادي
        $engProfile = EngineerProfile::updateOrCreate(
            ['user_id' => $user->id],
            [
                // البيانات الشخصية الأساسية التي تم نقلها
                'first_name'          => $data['first_name'] ?? null,
                'last_name'           => $data['last_name'] ?? null,
                'phone'               => $data['phone'] ?? null,
                'location'            => $data['location'] ?? null,

                // البيانات المهنية
                'specialization'      => $data['specialization'],
                'syndicate_number'    => $data['syndicate_number'],
                'degree'              => $data['degree'],
                'years_of_experience' => $data['years_of_experience'],
                'covered_zones'       => $data['covered_zones'],
                'bio'                 => $data['bio'] ?? null,
            ]
        );

        // 1. التعامل مع الصورة الشخصية (تم ربطها بملف المهندس مباشرة)
        if (isset($data['image'])) {
            if ($engProfile->image) {
                $this->deleteOldFile($engProfile->image);
            }
            $engProfile->image = $data['image']->store('profiles', 'public');
            $engProfile->save();
        }

        // 2. التعامل مع صورة بطاقة النقابة
        if (isset($data['syndicate_card_image'])) {
            if ($engProfile->syndicate_card_image) {
                $this->deleteOldFile($engProfile->syndicate_card_image);
            }
            $engProfile->syndicate_card_image = $data['syndicate_card_image']->store('engineer_docs', 'public');
            $engProfile->save();
        }

        // 3. التعامل مع ملف الشهادة
        if (isset($data['certificate_file'])) {
            if ($engProfile->certificate_file) {
                $this->deleteOldFile($engProfile->certificate_file);
            }
            $engProfile->certificate_file = $data['certificate_file']->store('engineer_docs', 'public');
            $engProfile->save();
        }
    }

    /**
     * جلب البيانات بتنسيق موحد يحتوي على بروفايل المهندس فقط
     */
    public function getFormattedProfile(User $user): array
    {
        // تحميل علاقة المهندس فقط
        $user->load(['engineerProfile']);

        return [
            'id'                => $user->id,
            'name'              => $user->name,
            'email'             => $user->email,
            'email_verified_at' => $user->email_verified_at,
            'created_at'        => $user->created_at,
            'updated_at'        => $user->updated_at,
            'otp_verified'      => $user->otp_verified,
            'pending_delete'    => $user->pending_delete,
            'delete_at'         => $user->delete_at,
            'role_id'           => $user->role_id,
            'status'            => $user->status,

            // تم إرجاع بروفايل المهندس فقط محملاً بكل البيانات الشخصية والمهنية
            'engineer_profile' => $user->engineerProfile ? [
                'id'                  => $user->engineerProfile->id,
                'user_id'             => $user->engineerProfile->user_id,
                'first_name'          => $user->engineerProfile->first_name, // مضاف حديثاً للجدول
                'last_name'           => $user->engineerProfile->last_name,  // مضاف حديثاً للجدول
                'phone'               => $user->engineerProfile->phone,      // مضاف حديثاً للجدول
                'location'            => $user->engineerProfile->location,   // مضاف حديثاً للجدول
                'image'               => $user->engineerProfile->image ? asset('storage/' . $user->engineerProfile->image) : null, // مضاف حديثاً للجدول
                'specialization'      => $user->engineerProfile->specialization,
                'syndicate_number'    => $user->engineerProfile->syndicate_number,
                'degree'              => $user->engineerProfile->degree,
                'years_of_experience' => $user->engineerProfile->years_of_experience,
                'covered_zones'       => $user->engineerProfile->covered_zones,
                'bio'                 => $user->engineerProfile->bio,
                'syndicate_card_image'=> $user->engineerProfile->syndicate_card_image ? asset('storage/' . $user->engineerProfile->syndicate_card_image) : null,
                'certificate_file'    => $user->engineerProfile->certificate_file ? asset('storage/' . $user->engineerProfile->certificate_file) : null,
                'is_verified'         => $user->engineerProfile->is_verified,
                'created_at'          => $user->engineerProfile->created_at,
                'updated_at'          => $user->engineerProfile->updated_at,
            ] : null,
        ];
    }

    private function deleteOldFile(?string $path): void {
        if ($path && Storage::disk('public')->exists($path)) {
            Storage::disk('public')->delete($path);
        }
    }
}
