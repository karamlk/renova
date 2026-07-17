<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ConstructionForm extends Model
{
    use HasFactory;

    // تحديد اسم الجدول في قاعدة البيانات
    protected $table = 'construction_forms';

    // الحقول المسموح بتعبئتها تلقائياً (Mass Assignable)
    protected $fillable = [
        'reconstruction_request_id',
        'contractor_id',
        'engineer_id',
        'building_description',
        'warranty_period',
        'execution_duration',
        'materials_cost',
        'labor_cost',
        'profit',
        'total_cost',
        'engineer_notes',
        'user_notes',
        'status',
        'pdf_file'
    ];

    // الحقول التي يجب تحويل نوعها تلقائياً عند جلبها
    protected $casts = [
        'materials_cost' => 'decimal:2',
        'labor_cost' => 'decimal:2',
        'profit' => 'decimal:2',
        'total_cost' => 'decimal:2',
    ];

    /**
     * علاقة الاستمارة مع المتعهد (المقاول)
     */
    public function contractor()
    {
        // تأكد من تغيير اسم الموديل 'Contractor' حسب ما سميته في مشروعك
        return $this->belongsTo(User::class, 'contractor_id');
    }

    /**
     * علاقة الاستمارة مع المهندس
     */
    public function engineer()
    {
        // تأكد من تغيير اسم الموديل 'Engineer' حسب ما سميته في مشروعك
        return $this->belongsTo(User::class, 'engineer_id');
    }

    /**
     * علاقة الاستمارة مع طلب إعادة الإعمار الأصلي
     */
    public function reconstructionRequest()
    {
        return $this->belongsTo(ReconstructionRequest::class, 'reconstruction_request_id');
    }
    public function materials()
    {
        return $this->hasMany(ConstructionMaterial::class, 'construction_form_id');
    }
    public function payments()
    {
        return $this->hasMany(Payment::class);
    }
    public function notifications()
    {
        return $this->hasMany(
            Notification::class
        );
    }
}
