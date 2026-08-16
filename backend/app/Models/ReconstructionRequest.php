<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class ReconstructionRequest extends Model
{
    //
    use SoftDeletes,HasFactory;

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
