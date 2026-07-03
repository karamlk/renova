<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Model;

class EngineerProfile extends Model {
    protected $fillable = [
        'user_id',
        'specialization',
        'syndicate_number',
        'degree',
        'years_of_experience',
        'covered_zones', 'bio',
        'syndicate_card_image',
        'certificate_file',
        'is_verified'
    ];

    public function user() {
        return $this->belongsTo(User::class, 'user_id');
    }
}
