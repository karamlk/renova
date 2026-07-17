<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Notification extends Model
{
    protected $fillable = [

        'user_id',

        'title',

        'message',

        'is_read',

        'construction_form_id'
    ];

    public function user()
    {
        return $this->belongsTo(
            User::class
        );
    }

    public function form()
    {
        return $this->belongsTo(
            ConstructionForm::class,
            'construction_form_id'
        );
    }
}
