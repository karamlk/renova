<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReconstructionRequest extends Model
{
    //
    use HasFactory;

    protected $fillable = [

        'user_id',

        'title',

        'description',

        'location',

        'type',

        'status',
    ];
    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function images()
    {
        return $this->hasMany(
            ReconstructionRequestImage::class
        );
    }
    public function inspectionRequests()
    {
        return $this->hasMany(
            InspectionRequest::class
        );
    }

}
