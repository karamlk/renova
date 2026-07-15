<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ComplaintImage extends Model
{
    use HasFactory;

    protected $fillable = [
        'complaint_id',
        'image',
    ];

     protected $appends = [
        'image_url', 
        'full_image_url'
    ];

    public function complaint()
    {
        return $this->belongsTo(Complaint::class);
    }

    public function getImageUrlAttribute(): string
    {
        return '/storage/' . $this->image;
    }

    public function getFullImageUrlAttribute(): string
    {
        return asset('storage/' . $this->image);
    }
}
