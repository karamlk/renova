<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ContractorSchedule extends Model
{
    //
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
    public function siteVisits()
    {
        return $this->hasMany(
            iteisit::class,
            'schedule_id'
        );
    }
}
