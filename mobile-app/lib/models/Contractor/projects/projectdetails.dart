class ProjectDetails {
  final int id;
  final int constructionFormId;
  final int contractorId;
  final int engineerId;
  final int userId;
  final double progress;
  final String status;
  final String createdAt;
  final String updatedAt;

  final ConstructionFormModel? form;
  final UserModel? contractor;
  final UserModel? engineer;
  final UserModel? user;

  ProjectDetails({
    required this.id,
    required this.constructionFormId,
    required this.contractorId,
    required this.engineerId,
    required this.userId,
    required this.progress,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.form,
    this.contractor,
    this.engineer,
    this.user,
  });

  factory ProjectDetails.fromJson(Map<String, dynamic> json) {
    final project = json['project'];
    return ProjectDetails(
      id: project['id'],
      constructionFormId: project['construction_form_id'],
      contractorId: project['contractor_id'],
      engineerId: project['engineer_id'],
      userId: project['user_id'],
      progress: double.tryParse(project['progress'].toString()) ?? 0.0,
      status: project['status'] ?? '',
      createdAt: project['created_at'] ?? '',
      updatedAt: project['updated_at'] ?? '',
      form: project['form'] != null ? ConstructionFormModel.fromJson(project['form']) : null,
      contractor: project['contractor'] != null ? UserModel.fromJson(project['contractor']) : null,
      engineer: project['engineer'] != null ? UserModel.fromJson(project['engineer']) : null,
      user: project['user'] != null ? UserModel.fromJson(project['user']) : null,
    );
  }
}

class ConstructionFormModel {
  final int id;
  final int reconstructionRequestId;
  final int contractorId;
  final int engineerId;

  final String buildingDescription;
  final String warrantyPeriod;
  final String executionDuration;

  final double materialsCost;
  final double laborCost;
  final double profit;
  final double totalCost;

  final String engineerNotes;
  final String userNotes;
  final String status;

  final String pdfFile;
  final String createdAt;
  final String updatedAt;
  final String? pdfFileUrl;

  final List<MaterialModel> materials;

  ConstructionFormModel({
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
    required this.createdAt,
    required this.updatedAt,
    this.pdfFileUrl,
    required this.materials,
  });

  factory ConstructionFormModel.fromJson(Map<String, dynamic> json) {
    return ConstructionFormModel(
      id: json['id'],
      reconstructionRequestId: json['reconstruction_request_id'],
      contractorId: json['contractor_id'],
      engineerId: json['engineer_id'],
      buildingDescription: json['building_description'] ?? '',
      warrantyPeriod: json['warranty_period'] ?? '',
      executionDuration: json['execution_duration'] ?? '',

      materialsCost: double.tryParse(json['materials_cost'].toString()) ?? 0.0,

      laborCost: double.tryParse(json['labor_cost'].toString()) ?? 0.0,

      profit: double.tryParse(json['profit'].toString()) ?? 0.0,

      totalCost: double.tryParse(json['total_cost'].toString()) ?? 0.0,

      engineerNotes: json['engineer_notes'] ?? '',
      userNotes: json['user_notes'] ?? '',
      status: json['status'] ?? '',

      pdfFile: json['pdf_file'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      pdfFileUrl: json['pdf_file_url'],

      materials: json['materials'] != null
          ? List<MaterialModel>.from(json['materials'].map((x) => MaterialModel.fromJson(x)))
          : [],
    );
  }
}

class MaterialModel {
  final int id;
  final int constructionFormId;

  final String materialName;
  final String materialType;

  final int quantity;
  final String unit;

  final double unitPrice;
  final double totalPrice;

  final String createdAt;
  final String updatedAt;

  MaterialModel({
    required this.id,
    required this.constructionFormId,
    required this.materialName,
    required this.materialType,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['id'],
      constructionFormId: json['construction_form_id'],
      materialName: json['material_name'] ?? '',
      materialType: json['material_type'] ?? '',
      quantity: json['quantity'] ?? 0,
      unit: json['unit'] ?? '',

      unitPrice: double.tryParse(json['unit_price'].toString()) ?? 0.0,

      totalPrice: double.tryParse(json['total_price'].toString()) ?? 0.0,

      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String email;

  final String? emailVerifiedAt;

  final String createdAt;
  final String updatedAt;

  final int otpVerified;
  final int pendingDelete;

  final String? deleteAt;

  final int roleId;

  final String status;

  final int isActive;

  final String? imageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.otpVerified,
    required this.pendingDelete,
    this.deleteAt,
    required this.roleId,
    required this.status,
    required this.isActive,
    this.imageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      otpVerified: json['otp_verified'] ?? 0,
      pendingDelete: json['pending_delete'] ?? 0,
      deleteAt: json['delete_at'],
      roleId: json['role_id'] ?? 0,
      status: json['status'] ?? '',
      isActive: json['is_active'] ?? 0,
      imageUrl: json['image_url'],
    );
  }
}
