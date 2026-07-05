<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ContractorSchedule extends Model
{
    //
    use HasFactory;
    protected $fillable = [
        'contractor_id',
        'day_of_week',
        'start_time',
        'end_time',

    ];

    public function contractor()
    {
        return $this->belongsTo(
            User::class,
            'contractor_id'
        );
    }
    public function siteVisit()
    {
        return $this->hasOne(
            SiteVisit::class,
            'schedule_id'
        );
    }
}
