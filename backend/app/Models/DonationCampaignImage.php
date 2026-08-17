<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DonationCampaignImage extends Model
{
    protected $fillable = [
        'donation_campaign_id',
        'image',
    ];

    public function campaign()
    {
        return $this->belongsTo(
            DonationCampaign::class,
            'donation_campaign_id'
        );
    }
    protected $appends = ['image_url'];

    public function getImageUrlAttribute()
    {
        return $this->image
            ? '/storage/' . $this->image
            : null;
    }
}
