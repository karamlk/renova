<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class DonationCampaign extends Model
{
    use HasFactory;

    protected $fillable = [
        'foundation_verification_request_id',
        'title',
        'description',
        'location',
        'target_amount',
        'collected_amount',
        'starts_at',
        'ends_at',
        'status',
        'reconstruction_request_id',
    ];

    protected $casts = [
        'target_amount' => 'decimal:2',
        'collected_amount' => 'decimal:2',
        'starts_at' => 'date',
        'ends_at' => 'date',
    ];

    public function foundation()
    {
        return $this->belongsTo(
            FoundationVerificationRequest::class,
            'foundation_verification_request_id'
        );
    }

    public function images()
    {
        return $this->hasMany(
            DonationCampaignImage::class,
            'donation_campaign_id'
        );
    }

    public function donations()
    {
        return $this->hasMany(
            Donation::class,
            'donation_campaign_id'
        );
    }

    public function reconstructionRequest()
    {
        return $this->belongsTo(
            ReconstructionRequest::class,
            'reconstruction_request_id'
        );
    }
}
