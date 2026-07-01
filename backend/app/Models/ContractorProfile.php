<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ContractorProfile extends Model
{
    //
    use HasFactory;

    protected $fillable = [

        'user_id',

        'first_name',

        'last_name',

        'phone',

        'image',

        'location',

        'company_name',

        'commercial_record',
    ];


    public function user()
    {
        return $this->belongsTo(User::class);
    }
    protected $appends = ['image_url','full_image_url','commercial_record_url','full_commercial_record_url'];

    public function getImageUrlAttribute()
    {
        return $this->image
            ? '/storage/' . $this->image
            : null;
    }
    public function getFullImageUrlAttribute()
    {
        return $this->image
            ? asset('storage/' . $this->image)
            : null;
    }


    public function getCommercialRecordUrlAttribute()
    {
        // تأكد أن الحقل يحتوي على قيمة قبل بناء الرابط
        return $this->commercial_record
            ? '/storage/' . $this->commercial_record
            : null;
    }
    public function getfullCommercialRecordUrlAttribute()
    {
        // تأكد أن الحقل يحتوي على قيمة قبل بناء الرابط
        return $this->commercial_record
            ?asset ('/storage/' . $this->commercial_record)
            : null;
    }
}
