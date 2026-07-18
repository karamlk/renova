<?php

namespace App\Http\Resources\Complaint;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class NoShowWarningResource extends JsonResource
{
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

            'complainant' => $this->whenLoaded('reporter'),
            'complained_on' => $this->whenLoaded('reported'),

            'site_visit' => $this->whenLoaded('siteVisit'),

            'created_at' => $this->created_at,
            'updated_at' => $this->updated_at,
        ];
    }
}
