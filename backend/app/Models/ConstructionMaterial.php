<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class ConstructionMaterial extends Model
{
    use HasFactory;
    protected $fillable = [
        'construction_form_id',
        'material_name',
        'material_type',
        'quantity',
        'unit',
        'unit_price',
        'total_price'
    ];

    public function constructionForm(): BelongsTo
    {
        return $this->belongsTo(ConstructionForm::class);
    }
}
