<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Invoice extends Model
{
    protected $fillable = [

        'invoice_number',

        'payment_id',

        'project_id',

        'user_id',

        'contractor_id',

        'amount',

        'invoice_type',

        'status',

        'pdf_file',

        'notes',

        'issued_at'

    ];

    protected $casts = [

        'issued_at'=>'datetime'

    ];

    public function payment()
    {
        return $this->belongsTo(Payment::class);
    }

    public function project()
    {
        return $this->belongsTo(Project::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function contractor()
    {
        return $this->belongsTo(User::class,'contractor_id');
    }
}
