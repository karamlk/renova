<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class NoShowWarning extends Model
{
    protected $fillable = [
        'site_visit_id',
        'reporter_id',
        'reported_id',
        'reporter_role_id',
        'reported_role_id',
        'type',
        'reason',
        'description',
        'penalty_applied',
    ];

    protected $casts = [
        'penalty_applied' => 'boolean',
    ];

    public function siteVisit()
    {
        return $this->belongsTo(SiteVisit::class);
    }

    public function reporter()
    {
        return $this->belongsTo(User::class, 'reporter_id');
    }

    public function reported()
    {
        return $this->belongsTo(User::class, 'reported_id');
    }

    public function reporterRole()
    {
        return $this->belongsTo(Role::class, 'reporter_role_id');
    }

    public function reportedRole()
    {
        return $this->belongsTo(Role::class, 'reported_role_id');
    }
}