<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Project extends Model
{
    use HasFactory;
    protected $fillable = [

        'construction_form_id',

        'contractor_id',

        'engineer_id',

        'user_id',

        'progress',

        'status',
        
        'project_ends_at',

        'warranty_ends_at'
    ];

    protected $casts = [
        'project_ends_at'  => 'date',
        'warranty_ends_at' => 'date',
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
    public function user()
    {
        return $this->belongsTo(User::class);
    }


    public function post()
    {
        return $this->hasMany(ContractorPost::class);
    }

    public function engineer()
    {
        return $this->belongsTo(User::class, 'engineer_id');
    }

    public function contractor()
    {
        return $this->belongsTo(User::class, 'contractor_id');
    }
}
