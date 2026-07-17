<?php

namespace App\Http\Resources\Complaint;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ComplaintResource extends JsonResource
{
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

            'complainant' => $this->whenLoaded('complainant'),
            'complained_on' => $this->whenLoaded('complainedOn'),
            'construction_form' => $this->whenLoaded('constructionForm'),
            'images' => $this->whenLoaded('images'),

            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
