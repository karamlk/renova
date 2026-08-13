<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Project extends Model
{
    protected $fillable = [

        'construction_form_id',

        'contractor_id',

        'engineer_id',

        'user_id',

        'progress',

        'status'
    ];

    public function form()
    {
        return $this->belongsTo(
            ConstructionForm::class,
            'construction_form_id'
        );
    }

    public function tasks()
    {
        return $this->hasMany(
            ProjectTask::class
        );
    }
    public function invoices()
    {
        return $this->hasMany(Invoice::class);
    }
    public function review()
    {
        return $this->hasOne(
            ProjectReview::class
        );
    }
}
