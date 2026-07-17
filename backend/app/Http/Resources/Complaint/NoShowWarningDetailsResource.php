<?php

namespace App\Http\Resources\Complaint;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class NoShowWarningDetailsResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,

            'site_visit_id' => $this->site_visit_id,

            'complainant_id' => $this->reporter_id,
            'complained_on_id' => $this->reported_id,

            'complainant_role_id' => $this->reporter_role_id,
            'complained_on_role_id' => $this->reported_role_id,

            'type' => $this->type,
            'reason' => $this->reason,
            'description' => $this->description,
            'penalty_applied' => $this->penalty_applied,

            'is_archived' => $this->is_archived,
            'archived_at' => $this->archived_at,

            'complainant' => $this->whenLoaded('reporter', function () {
                return [
                    'id' => $this->reporter->id,
                    'name' => $this->reporter->name,
                    'email' => $this->reporter->email,
                    'email_verified_at' => $this->reporter->email_verified_at,
                    'created_at' => $this->reporter->created_at,
                    'updated_at' => $this->reporter->updated_at,
                    'otp_verified' => $this->reporter->otp_verified,
                    'pending_delete' => $this->reporter->pending_delete,
                    'delete_at' => $this->reporter->delete_at,
                    'role_id' => $this->reporter->role_id,
                    'status' => $this->reporter->status,
                    'is_active' => $this->reporter->is_active,
                    'image_url' => $this->reporter->image_url,
                    'profile' => $this->reporter->active_profile,
                ];
            }),


            'complained_on' => $this->whenLoaded('reported', function () {
                return [
                    'id' => $this->reported->id,
                    'name' => $this->reported->name,
                    'email' => $this->reported->email,
                    'email_verified_at' => $this->reported->email_verified_at,
                    'created_at' => $this->reported->created_at,
                    'updated_at' => $this->reported->updated_at,
                    'otp_verified' => $this->reported->otp_verified,
                    'pending_delete' => $this->reported->pending_delete,
                    'delete_at' => $this->reported->delete_at,
                    'role_id' => $this->reported->role_id,
                    'status' => $this->reported->status,
                    'is_active' => $this->reported->is_active,
                    'complaints_count' => $this->reported->no_show_warnings_count ?? $this->reported->complaints_count ?? 0,
                    'image_url' => $this->reported->image_url,
                    'profile' => $this->reported->active_profile,
                ];
            }),

            'site_visit' => $this->whenLoaded('siteVisit'),

            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
