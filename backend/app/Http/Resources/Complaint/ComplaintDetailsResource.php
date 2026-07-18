<?php

namespace App\Http\Resources\Complaint;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ComplaintDetailsResource extends JsonResource
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

            'complainant_id' => $this->complainant_id,
            'complained_on_id' => $this->complained_on_id,

            'construction_form_id' => $this->construction_form_id,

            'complainant_role_id' => $this->complainant_role_id,
            'complained_on_role_id' => $this->complained_on_role_id,

            'type' => $this->type,
            'reason' => $this->reason,
            'description' => $this->description,

            'status' => $this->status,

            'admin_processing_note' => $this->admin_processing_note,

            'penalty_percentage' => $this->penalty_percentage,
            'penalty_amount' => $this->penalty_amount,
            'compensation_amount' => $this->compensation_amount,

            'is_archived' => $this->is_archived,
            'archived_at' => $this->archived_at,
            'resolved_at' => $this->resolved_at,

            // 1. Full Complainant Mapping
            'complainant' => $this->whenLoaded('complainant', function () {
                return [
                    'id' => $this->complainant->id,
                    'name' => $this->complainant->name,
                    'email' => $this->complainant->email,
                    'email_verified_at' => $this->complainant->email_verified_at,
                    'created_at' => $this->complainant->created_at,
                    'updated_at' => $this->complainant->updated_at,
                    'otp_verified' => $this->complainant->otp_verified,
                    'pending_delete' => $this->complainant->pending_delete,
                    'delete_at' => $this->complainant->delete_at,
                    'role_id' => $this->complainant->role_id,
                    'status' => $this->complainant->status,
                    'is_active' => $this->complainant->is_active,
                    'image_url' => $this->complainant->image_url,
                    'profile' => $this->complainant->active_profile,
                ];
            }),

            // 2. Full Complained On Mapping
            'complained_on' => $this->whenLoaded('complainedOn', function () {
                return [
                    'id' => $this->complainedOn->id,
                    'name' => $this->complainedOn->name,
                    'email' => $this->complainedOn->email,
                    'email_verified_at' => $this->complainedOn->email_verified_at,
                    'created_at' => $this->complainedOn->created_at,
                    'updated_at' => $this->complainedOn->updated_at,
                    'otp_verified' => $this->complainedOn->otp_verified,
                    'pending_delete' => $this->complainedOn->pending_delete,
                    'delete_at' => $this->complainedOn->delete_at,
                    'role_id' => $this->complainedOn->role_id,
                    'status' => $this->complainedOn->status,
                    'is_active' => $this->complainedOn->is_active,
                    'complaints_count' => $this->complainedOn->complaints_count ?? 0,
                    'image_url' => $this->complainedOn->image_url,
                    'profile' => $this->complainedOn->active_profile,
                ];
            }),

            'construction_form' => $this->whenLoaded('constructionForm'),
            'images' => $this->whenLoaded('images'),

            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
