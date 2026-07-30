class InspectionFormModel {
  final int reconstructionRequestId;
  final int contractorId;
  final int engineerId;

  final String buildingDescription;
  final String warrantyPeriod;
  final String executionDuration;

  final double materialsCost;
  final double laborCost;
  final double profit;

  final List<MaterialModel> materials;

  InspectionFormModel({
    required this.reconstructionRequestId,
    required this.contractorId,
    required this.engineerId,
    required this.buildingDescription,
    required this.warrantyPeriod,
    required this.executionDuration,
    required this.materialsCost,
    required this.laborCost,
    required this.profit,
    required this.materials,
  });

  Map<String, dynamic> toJson() {
    return {
      "reconstruction_request_id": reconstructionRequestId,
      "contractor_id": contractorId,
      "engineer_id": engineerId,
      "building_description": buildingDescription,
      "warranty_period": warrantyPeriod,
      "execution_duration": executionDuration,
      "materials_cost": materialsCost,
      "labor_cost": laborCost,
      "profit": profit,
      "materials": materials.map((e) => e.toJson()).toList(),
    };
  }
}

class MaterialModel {
  final String materialName;
  final String materialType;
  final int quantity;
  final String unit;
  final double unitPrice;

  MaterialModel({
    required this.materialName,
    required this.materialType,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      "material_name": materialName,
      "material_type": materialType,
      "quantity": quantity,
      "unit": unit,
      "unit_price": unitPrice,
    };
  }
}
