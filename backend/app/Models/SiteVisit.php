<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class SiteVisit extends Model
{
    //
    protected $fillable = [
        'inspection_request_id',
        'schedule_id',
    ];
    public function inspectionRequest()
    {
        return $this->belongsTo(
            InspectionRequest::class
        );
    }

    public function schedule()
    {
        return $this->belongsTo(
            ContractorSchedule::class,
            'schedule_id'
        );
    }
}
