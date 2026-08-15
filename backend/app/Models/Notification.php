<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class Notification extends Model
{
    use SoftDeletes;
    
    protected $fillable = [

        'user_id',

        'title',

        'message',

        'type',

        'related_id',

        'is_read',

        'target_path'
    ];
    public function form()
    {
        return $this->belongsTo(
            ConstructionForm::class,
            'construction_form_id'
        );
    }
}
