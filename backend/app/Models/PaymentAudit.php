<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PaymentAudit extends Model
{
    //
    protected $fillable = [
        'payment_id',
        'from_user_id',
        'to_user_id',
        'amount',
        'action',
        'description'
    ];
    public function payment()
    {
        return $this->belongsTo(
            Payment::class
        );
    }

    public function fromUser()
    {
        return $this->belongsTo(
            User::class,
            'from_user_id'
        );
    }

    public function toUser()
    {
        return $this->belongsTo(
            User::class,
            'to_user_id'
        );
    }
}
