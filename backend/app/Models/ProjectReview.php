<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ProjectReview extends Model
{
    use HasFactory;

    protected $fillable = [
        'project_id',
        'user_id',
        'contractor_id',
        'rating',
    ];

    public function project()
    {
        return $this->belongsTo(
            Project::class
        );
    }

    public function user()
    {
        return $this->belongsTo(
            User::class
        );
    }

    public function contractor()
    {
        return $this->belongsTo(
            User::class,
            'contractor_id'
        );
    }
}
