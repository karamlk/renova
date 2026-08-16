<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Payment extends Model
{
    use HasFactory;

    protected $fillable = [

        'construction_form_id',

        'user_id',

        'amount',

        'type',

        'status',

        'paid_at'
    ];

    public function form()
    {
        return $this->belongsTo(
            ConstructionForm::class,
            'construction_form_id'
        );
    }

    public function user()
    {
        return $this->belongsTo(
            User::class
        );

    }
    public function invoice()
    {
        return $this->hasOne(Invoice::class);
    }

    public function audits()
    {
        return $this->hasMany(PaymentAudit::class);
    }
}
