<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Complaint extends Model
{
    use SoftDeletes,HasFactory;

    protected $fillable = [
        'complainant_id',
        'complained_on_id',
        'construction_form_id',
        'complainant_role_id',
        'complained_on_role_id',
        'type',
        'reason',
        'description',
        'status',
        'admin_processing_note',
        'penalty_percentage',
        'penalty_amount',
        'compensation_amount',
        'resolved_at',
        'is_archived',
        'archived_at',
    ];

    protected $casts = [
        'penalty_percentage'   => 'float',
        'penalty_amount'       => 'float',
        'compensation_amount'  => 'float',
        'resolved_at'          => 'datetime',
        'is_archived' => 'boolean',
        'archived_at' => 'datetime',
    ];

    public function complainant()
    {
        return $this->belongsTo(User::class, 'complainant_id');
    }

    public function complainedOn()
    {
        return $this->belongsTo(User::class, 'complained_on_id');
    }

    public function constructionForm()
    {
        return $this->belongsTo(ConstructionForm::class);
    }

    public function complainantRole()
    {
        return $this->belongsTo(Role::class, 'complainant_role_id');
    }

    public function complainedOnRole()
    {
        return $this->belongsTo(Role::class, 'complained_on_role_id');
    }

    public function images()
    {
        return $this->hasMany(ComplaintImage::class);
    }
}
