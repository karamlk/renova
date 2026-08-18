<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class SiteVisit extends Model
{
    use HasFactory;
    //
    protected $fillable = [
        'inspection_request_id',
        'schedule_id',
        'engineer_id',
        'status',
        'visit_date'
    ];

     protected $casts = [
        'visit_date' => 'date',
    ];
    
    public function engineer()
    {
        return $this->belongsTo(User::class, 'engineer_id');
    }
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
