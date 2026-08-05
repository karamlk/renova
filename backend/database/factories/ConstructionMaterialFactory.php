<?php

namespace Database\Factories;

use App\Models\ConstructionForm;
use App\Models\ConstructionMaterial;
use Illuminate\Database\Eloquent\Factories\Factory;

class ConstructionMaterialFactory extends Factory
{
    protected $model = ConstructionMaterial::class;

    public function definition(): array
    {
        $quantity  = fake()->numberBetween(10, 200);
        $unitPrice = fake()->numberBetween(1000, 50000);

        return [
            'construction_form_id' => ConstructionForm::factory(),
            'material_name'        => fake()->randomElement(['cement', 'steel', 'wood', 'sand', 'gravel']),
            'material_type'        => fake()->randomElement(['binding', 'structure', 'finishing']),
            'quantity'             => $quantity,
            'unit'                 => fake()->randomElement(['bag', 'ton', 'm²', 'piece']),
            'unit_price'           => $unitPrice,
            'total_price'          => $quantity * $unitPrice,
        ];
    }
}