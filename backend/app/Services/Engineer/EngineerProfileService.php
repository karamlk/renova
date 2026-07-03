<?php
namespace App\Services\Engineer;

use App\Models\User;
use App\Models\UserProfile;
use App\Models\EngineerProfile;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Storage;

class EngineerProfileService {


    public function updateEngineerProfile(User $user, array $data): void {
        // 1. تحديث البروفايل العادي المتوافق مع حقولك
        $userProfile = $user->userProfile;
        if (isset($data['image'])) {
            $this->deleteOldFile($userProfile->image);
            $userProfile->image = $data['image']->store('profiles', 'public');
        }
        $userProfile->update([
            'first_name' => $data['first_name'],
            'last_name'  => $data['last_name'],
            'phone'      => $data['phone'],
            'location'   => $data['location'],
        ]);

        // 2. تحديث جدول الهندسيات المخصص
        $engProfile = $user->engineerProfile;
        if (isset($data['syndicate_card_image'])) {
            $this->deleteOldFile($engProfile->syndicate_card_image);
            $engProfile->syndicate_card_image = $data['syndicate_card_image']
                ->store('engineer_docs', 'public');
        }
        if (isset($data['certificate_file'])) {
            $this->deleteOldFile($engProfile->certificate_file);
            $engProfile->certificate_file = $data['certificate_file']
                ->store('engineer_docs', 'public');
        }

        $engProfile->update([
            'specialization'      => $data['specialization'],
            'syndicate_number'    => $data['syndicate_number'],
            'degree'              => $data['degree'],
            'years_of_experience' => $data['years_of_experience'],
            'covered_zones'       => $data['covered_zones'],
            'bio'                 => $data['bio'] ?? $engProfile->bio,
        ]);
    }

    public function getFormattedProfile(User $user): array {
        $user->load(['userProfile', 'engineerProfile']);

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

            'profile' => $user->userProfile ? [
                'id'         => $user->userProfile->id,
                'user_id'    => $user->userProfile->user_id,
                'first_name' => $user->userProfile->first_name,
                'last_name'  => $user->userProfile->last_name,
                'phone'      => $user->userProfile->phone,
                'image'      => $user->userProfile->image ? asset('storage/' . $user->userProfile->image) : null,
                'location'   => $user->userProfile->location,
                'created_at' => $user->userProfile->created_at,
                'updated_at' => $user->userProfile->updated_at,
            ] : null,

            'engineer_profile' => $user->engineerProfile ? [
                'id'                  => $user->engineerProfile->id,
                'user_id'             => $user->engineerProfile->user_id,
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
