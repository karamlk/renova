class ConstructionFormDetails {
  final int id;
  final int reconstructionRequestId;
  final int contractorId;
  final int engineerId;

  final String buildingDescription;
  final String warrantyPeriod;
  final String executionDuration;

  final String materialsCost;
  final String laborCost;
  final String profit;
  final String totalCost;

  final String? engineerNotes;
  final String? userNotes;

  final String status;
  final String? pdfFile;

  final Person? contractor;
  final Person engineer;
  final ReconstructionRequest reconstructionRequest;

  final List<ConstructionMaterial> materials;

  ConstructionFormDetails({
    required this.id,
    required this.reconstructionRequestId,
    required this.contractorId,
    required this.engineerId,
    required this.buildingDescription,
    required this.warrantyPeriod,
    required this.executionDuration,
    required this.materialsCost,
    required this.laborCost,
    required this.profit,
    required this.totalCost,
    required this.engineerNotes,
    required this.userNotes,
    required this.status,
    required this.pdfFile,
    required this.contractor,
    required this.engineer,
    required this.reconstructionRequest,
    required this.materials,
  });

  factory ConstructionFormDetails.fromJson(Map<String, dynamic> json) {
    return ConstructionFormDetails(
      id: json["id"],
      reconstructionRequestId: json["reconstruction_request_id"],
      contractorId: json["contractor_id"],
      engineerId: json["engineer_id"],
      buildingDescription: json["building_description"],
      warrantyPeriod: json["warranty_period"],
      executionDuration: json["execution_duration"],
      materialsCost: json["materials_cost"],
      laborCost: json["labor_cost"],
      profit: json["profit"],
      totalCost: json["total_cost"],
      engineerNotes: json["engineer_notes"],
      userNotes: json["user_notes"],
      status: json["status"],
      pdfFile: json["pdf_file"],
      contractor: json['contractor'] == null ? null : Person.fromJson(json["contractor"]),
      engineer: Person.fromJson(json["engineer"]),
      reconstructionRequest: ReconstructionRequest.fromJson(json["reconstruction_request"]),
      materials: json["materials"] == null
          ? []
          : (json["materials"] as List).map((e) => ConstructionMaterial.fromJson(e)).toList(),
    );
  }
}

class Person {
  final int id;
  final String name;
  final String email;
  final String? imageUrl;

  Person({required this.id, required this.name, required this.email, this.imageUrl});

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      imageUrl: json["image_url"],
    );
  }
}

class ReconstructionRequest {
  final int id;
  final String title;
  final String description;
  final String location;
  final String type;
  final String status;

  final Person user;

  ReconstructionRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.status,
    required this.user,
  });

  factory ReconstructionRequest.fromJson(Map<String, dynamic> json) {
    return ReconstructionRequest(
      id: json["id"],
      title: json["title"],
      description: json["description"],
      location: json["location"],
      type: json["type"],
      status: json["status"],
      user: Person.fromJson(json["user"]),
    );
  }
}

class ConstructionMaterial {
  final int id;
  final String materialName;
  final String materialType;
  final num quantity;
  final String unit;
  final num unitPrice;
  final num totalPrice;

  ConstructionMaterial({
    required this.id,
    required this.materialName,
    required this.materialType,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory ConstructionMaterial.fromJson(Map<String, dynamic> json) {
    return ConstructionMaterial(
      id: json["id"],
      materialName: json["material_name"],
      materialType: json["material_type"],
      quantity: json["quantity"],
      unit: json["unit"],
      unitPrice: json["unit_price"],
      totalPrice: json["total_price"],
    );
  }
}
