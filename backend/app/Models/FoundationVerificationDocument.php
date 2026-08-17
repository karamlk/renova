<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FoundationVerificationDocument extends Model
{
    protected $fillable = [
        'foundation_verification_request_id',
        'document',
        'type',
    ];

    public function request()
    {
        return $this->belongsTo(
            FoundationVerificationRequest::class,
            'foundation_verification_request_id'
        );
    }
    protected $appends = ['full_document'];

    public function getfullDocumentAttribute()
    {
        // تأكد أن الحقل يحتوي على قيمة قبل بناء الرابط
        return $this->document
            ?asset ('/storage/' . $this->document)
            : null;
    }
}
