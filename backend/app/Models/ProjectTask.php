<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProjectTask extends Model
{
    protected $fillable = [

        'project_id',

        'title',

        'description',

        'percentage',

        'is_completed'
    ];

    public function project()
    {
        return $this->belongsTo(
            Project::class
        );
    }
}
