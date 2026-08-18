<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;

use Illuminate\Database\Eloquent\Casts\Attribute;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasFactory, Notifiable, HasApiTokens;

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    /**
     * @property bool $is_active
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'otp_verified',
        'delete_at',
        'pending_delete',
        'role_id',
        'status',
        'is_active',
        'fcm_token',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }

    public function activeProfile(): Attribute
    {
        return Attribute::make(
            get: function () {
                if ($this->relationLoaded('contractorProfile') && $this->contractorProfile) {
                    return $this->contractorProfile;
                }
                if ($this->relationLoaded('engineerProfile') && $this->engineerProfile) {
                    return $this->engineerProfile;
                }
                if ($this->relationLoaded('profile') && $this->profile) {
                    return $this->profile;
                }

                return match ((int) $this->role_id) {
                    3 => $this->contractorProfile, // Contractor Role ID
                    4 => $this->engineerProfile,   // Engineer Role ID
                    2 => $this->profile,     // Regular User Profile
                };
            }
        );
    }

    public function role()
    {
        return $this->belongsTo(Role::class);
    }
    public function profile()
    {
        return $this->hasOne(UserProfile::class);
    }
    public function reconstructionRequests()
    {
        return $this->hasMany(ReconstructionRequest::class);
    }
    public function contractorProfile()
    {
        return $this->hasOne(
            ContractorProfile::class
        );
    }
    public function contractorPosts()
    {
        return $this->hasMany(
            ContractorPost::class
        );
    }
    protected $appends = ['image_url'];

    public function getImageUrlAttribute()
    {
        return $this->image
            ? asset('storage/' . $this->image)
            : null;
    }
    public function schedules()
    {
        return $this->hasMany(
            ContractorSchedule::class,
            'contractor_id'
        );
    }
    protected $append = ['commercial_record_url'];

    public function getCommercialRecordUrlAttribute()
    {
        // تأكد أن الحقل يحتوي على قيمة قبل بناء الرابط
        return $this->commercial_record
            ? asset('storage/' . $this->commercial_record)
            : null;
    }
    public function likes()
    {
        return $this->hasMany(
            Like::class
        );
    }
    public function engineerProfile()
    {
        return $this->hasOne(EngineerProfile::class, 'user_id');
    }
    public function engineerVisits()
    {
        return $this->hasMany(SiteVisit::class, 'engineer_id');
    }
    public function wallet()
    {
        return $this->hasOne(
            Wallet::class
        );
    }
    public function payments()
    {
        return $this->hasMany(
            Payment::class
        );
    }
    // linking with the complaints
    public function complaintsfiled()
    {
        return $this->hasMany(Complaint::class, 'complainant_id');
    }

    public function complaintsReceived()
    {
        return $this->hasMany(Complaint::class, 'complained_on_id');
    }

    public function noShowWarnings()
    {
        return $this->hasMany(NoShowWarning::class, 'reported_id');
    }
    ///------------------------------
    public function notifications()
    {
        return $this->hasMany(
            Notification::class
        );
    }
    public function invoices()
    {
        return $this->hasMany(Invoice::class);
    }

    public function contractorInvoices()
    {
        return $this->hasMany(
            Invoice::class,
            'contractor_id'
        );
    }
    public function reviews()
    {
        return $this->hasMany(
            ProjectReview::class,
            'contractor_id'
        );
    }
    public function foundationVerificationRequests()
    {
        return $this->hasMany(
            FoundationVerificationRequest::class
        );
    }
    public function latestFoundationVerification()
    {
        return $this->hasOne(
            FoundationVerificationRequest::class
        )->latestOfMany();
    }
}
