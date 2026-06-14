<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ReconstructionRequestImage extends Model
{
    //
    use HasFactory;

    protected $fillable = [

        'reconstruction_request_id',

        'image',
    ];
    public function reconstructionRequest()
    {
        return $this->belongsTo(
            ReconstructionRequest::class
        );
    }
    protected $appends = ['image_url'];
    public function getImageUrlAttribute()
    {
        return $this->image
            ? '/storage/' . $this->image
            : null;
    }
}
