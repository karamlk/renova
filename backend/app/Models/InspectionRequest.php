<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class InspectionRequest extends Model
{
    use HasFactory;

    protected $fillable = [

        'reconstruction_request_id',

        'contractor_id',

        'status',
    ];

    public function request()
    {
        return $this->belongsTo(
            ReconstructionRequest::class,
            'reconstruction_request_id'
        );
    }

    public function contractor()
    {
        return $this->belongsTo(
            User::class,
            'contractor_id'
        );
    }
    public function getImageUrlAttribute()
    {
        return $this->image
            ? '/storage/' . $this->image
            : null;
    }
}
