<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ContractorPost extends Model
{
    use HasFactory;



    protected $fillable = [
        'project_id',
        'user_id',
        'title',
        'description',
        'status',
        'progress',
    ];

    public function project()
    {
        return $this->belongsTo(Project::class);
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
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
