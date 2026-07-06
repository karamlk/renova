<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class NoShowWarning extends Model
{
    protected $fillable = [
        'site_visit_id',
        'reporter_id',
        'reported_id',
        'reported_role',
        'penalty_applied',
        'penalty_amount',
    ];

    protected $casts = [
        'penalty_applied' => 'boolean',
        'penalty_amount'  => 'float',
    ];

    public function siteVisit()
    {
        return $this->belongsTo(SiteVisit::class);
    }
    //من ابلغ
    public function reporter()
    {
        return $this->belongsTo(User::class, 'reporter_id');
    }
    //من لم يحضر للزيارة الميدانية 
    public function reported()
    {
        return $this->belongsTo(User::class, 'reported_id');
    }
}
