<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class EngineerProfile extends Model {
    use HasFactory;

    protected $fillable = [
        'user_id',
        'first_name',
        'last_name',
        'phone',
        'location',
        'image',
        'specialization',
        'syndicate_number',
        'degree',
        'years_of_experience',
        'covered_zones',
        'bio',
        'syndicate_card_image',
        'certificate_file',
    ];

    public function user() {
        return $this->belongsTo(User::class, 'user_id');
    }

    protected $appends = [
        'image_url',
        'full_image_url',
        'syndicate_card_image_url',
        'full_syndicate_card_image_url',
        'certificate_file_url',
        'full_certificate_file_url'
    ];

    // --- 1. الصورة الشخصية ---
    public function getImageUrlAttribute()
    {
        return $this->image
            ? ('storage/' . $this->image) : null;
    }

    public function getFullImageUrlAttribute()
    {
        return $this->image
            ? asset('storage/' . $this->image) : null;
    }

    // --- 2. صورة بطاقة النقابة (تم تصحيح الحقل إلى syndicate_card_image) ---
    public function getSyndicateCardImageUrlAttribute()
    {
        return $this->syndicate_card_image
            ? ('storage/' . $this->syndicate_card_image) : null;
    }

    public function getFullSyndicateCardImageUrlAttribute()
    {
        return $this->syndicate_card_image
            ? asset('storage/' . $this->syndicate_card_image) : null;
    }

    // --- 3. ملف الشهادة (تم تصحيح الحقل إلى certificate_file لتجنب الـ Loop) ---
    public function getCertificateFileUrlAttribute()
    {
        return $this->certificate_file
            ? ('storage/' . $this->certificate_file) : null;
    }

    public function getFullCertificateFileUrlAttribute()
    {
        return $this->certificate_file
            ? asset('storage/' . $this->certificate_file) : null;
    }
}
