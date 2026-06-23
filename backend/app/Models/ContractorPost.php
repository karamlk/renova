<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ContractorPost extends Model
{
    use HasFactory;

    protected $fillable = [

        'user_id',

        'title',

        'description',

        'status',

        'progress',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function images()
    {
        return $this->hasMany(
            ContractorPostImage::class
        );
    }
    public function likes()
    {
        return $this->hasMany(
            Like::class
        );
    }
}
