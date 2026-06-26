<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Model;

class UserProfile extends Model
{
    //
    protected $fillable = [
        'user_id',
        'first_name',
        'last_name',
        'phone',
        'image',
        'location',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    // UserProfile.php

    protected $appends = ['image_url', 'full_image_url'];

    public function getImageUrlAttribute()
    {
        return $this->image
            ? '/storage/' . $this->image
            : null;
    }
}
