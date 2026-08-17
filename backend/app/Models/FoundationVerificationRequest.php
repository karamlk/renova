<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FoundationVerificationRequest extends Model
{
    protected $fillable = [
        'user_id',
        'foundation_name',
        'description',
        'registration_number',
        'status',
        'rejection_reason',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function documents()
    {
        return $this->hasMany(
            FoundationVerificationDocument::class
        );
    }
}
