class ReceivedFormDetails {
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
  final String? pdfFileUrl;

  final Contractor contractor;
  final Engineer engineer;
  final ReconstructionRequest reconstructionRequest;
  final List<FormMaterial> materials;

  ReceivedFormDetails({
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
    this.engineerNotes,
    this.userNotes,
    required this.status,
    this.pdfFile,
    this.pdfFileUrl,
    required this.contractor,
    required this.engineer,
    required this.reconstructionRequest,
    required this.materials,
  });

  factory ReceivedFormDetails.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return ReceivedFormDetails(
      id: data['id'],
      reconstructionRequestId: data['reconstruction_request_id'],
      contractorId: data['contractor_id'],
      engineerId: data['engineer_id'],
      buildingDescription: data['building_description'],
      warrantyPeriod: data['warranty_period'],
      executionDuration: data['execution_duration'],
      materialsCost: data['materials_cost'],
      laborCost: data['labor_cost'],
      profit: data['profit'],
      totalCost: data['total_cost'],
      engineerNotes: data['engineer_notes'],
      userNotes: data['user_notes'],
      status: data['status'],
      pdfFile: data['pdf_file'],
      pdfFileUrl: data['pdf_file_url'],
      contractor: Contractor.fromJson(data['contractor']),
      engineer: Engineer.fromJson(data['engineer']),
      reconstructionRequest: ReconstructionRequest.fromJson(data['reconstruction_request']),
      materials: (data['materials'] as List).map((e) => FormMaterial.fromJson(e)).toList(),
    );
  }
}

class Contractor {
  final int id;
  final String name;
  final String email;
  final String status;

  Contractor({required this.id, required this.name, required this.email, required this.status});

  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      status: json['status'],
    );
  }
}

class Engineer {
  final int id;
  final String name;
  final String email;
  final String status;

  Engineer({required this.id, required this.name, required this.email, required this.status});

  factory Engineer.fromJson(Map<String, dynamic> json) {
    return Engineer(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      status: json['status'],
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
  final String email;

  ReconstructionRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.status,
    required this.email,
  });

  factory ReconstructionRequest.fromJson(Map<String, dynamic> json) {
    return ReconstructionRequest(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      type: json['type'],
      status: json['status'],
      email: json['user']['email'],
    );
  }
}

class FormMaterial {
  final int id;
  final String materialName;
  final String materialType;
  final int quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;

  FormMaterial({
    required this.id,
    required this.materialName,
    required this.materialType,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
  });

  factory FormMaterial.fromJson(Map<String, dynamic> json) {
    return FormMaterial(
      id: json['id'],
      materialName: json['material_name'],
      materialType: json['material_type'],
      quantity: json['quantity'],
      unit: json['unit'],
      unitPrice: (json['unit_price'] as num).toDouble(),
      totalPrice: (json['total_price'] as num).toDouble(),
    );
  }
}
