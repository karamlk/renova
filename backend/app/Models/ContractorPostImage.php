<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class ContractorPostImage extends Model
{
    use HasFactory;

    protected $fillable = [

        'contractor_post_id',

        'image',
    ];

    public function contractorPost()
    {
        return $this->belongsTo(
            ContractorPost::class
        );
    }
}
