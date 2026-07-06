<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Complaint extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'complainant_id',
        'complained_on_id',
        'construction_form_id',
        'complainant_role',
        'complained_on_role',
        'reason',
        'description',
        'is_anonymous',
        'status',
        'admin_note',
        'penalty_percentage',
        'penalty_amount',
        'compensation_amount',
        'resolved_at',
    ];

    protected $casts = [
        'is_anonymous'      => 'boolean',
        'penalty_percentage' => 'float',
        'penalty_amount'    => 'float',
        'compensation_amount' => 'float',
        'resolved_at'       => 'datetime',
    ];

    // من رفع الشكوى
    public function complainant()
    {
        return $this->belongsTo(User::class, 'complainant_id');
    }

    // المشكو عليه
    public function complainedOn()
    {
        return $this->belongsTo(User::class, 'complained_on_id');
    }

    // الاستمارة المرتبطة
    public function constructionForm()
    {
        return $this->belongsTo(ConstructionForm::class);
    }
}
