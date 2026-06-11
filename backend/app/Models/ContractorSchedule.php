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
        'is_booked',
    ];

    public function contractor()
    {
        return $this->belongsTo(
            User::class,
            'contractor_id'
        );
    }
}
