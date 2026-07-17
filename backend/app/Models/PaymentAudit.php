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
}
