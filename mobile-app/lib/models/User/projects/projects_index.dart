class ProjectIndex {
  final int id;
  final int constructionFormId;
  final int contractorId;
  final int engineerId;
  final int userId;
  final String progress;
  final String status;
  final String createdAt;
  final String updatedAt;

  final ConstructionForm form;
  final UserInfo contractor;
  final UserInfo engineer;

  ProjectIndex({
    required this.id,
    required this.constructionFormId,
    required this.contractorId,
    required this.engineerId,
    required this.userId,
    required this.progress,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.form,
    required this.contractor,
    required this.engineer,
  });

  factory ProjectIndex.fromJson(Map<String, dynamic> json) {
    return ProjectIndex(
      id: json['id'],
      constructionFormId: json['construction_form_id'],
      contractorId: json['contractor_id'],
      engineerId: json['engineer_id'],
      userId: json['user_id'],
      progress: json['progress'] ?? '0.00',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      form: ConstructionForm.fromJson(json['form']),
      contractor: UserInfo.fromJson(json['contractor']),
      engineer: UserInfo.fromJson(json['engineer']),
    );
  }
}

class ConstructionForm {
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
  final String pdfFile;
  final String createdAt;
  final String updatedAt;
  final String pdfFileUrl;

  final ReconstructionRequest reconstructionRequest;

  ConstructionForm({
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
    required this.pdfFileUrl,
    required this.reconstructionRequest,
  });

  factory ConstructionForm.fromJson(Map<String, dynamic> json) {
    return ConstructionForm(
      id: json['id'],
      reconstructionRequestId: json['reconstruction_request_id'],
      contractorId: json['contractor_id'],
      engineerId: json['engineer_id'],
      buildingDescription: json['building_description'] ?? '',
      warrantyPeriod: json['warranty_period'] ?? '',
      executionDuration: json['execution_duration'] ?? '',
      materialsCost: json['materials_cost'] ?? '0.00',
      laborCost: json['labor_cost'] ?? '0.00',
      profit: json['profit'] ?? '0.00',
      totalCost: json['total_cost'] ?? '0.00',
      engineerNotes: json['engineer_notes'],
      userNotes: json['user_notes'],
      status: json['status'] ?? '',
      pdfFile: json['pdf_file'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      pdfFileUrl: json['pdf_file_url'] ?? '',
      reconstructionRequest: ReconstructionRequest.fromJson(json['reconstruction_request']),
    );
  }
}

class ReconstructionRequest {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String location;
  final String type;
  final String status;
  final String createdAt;
  final String updatedAt;

  ReconstructionRequest({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReconstructionRequest.fromJson(Map<String, dynamic> json) {
    return ReconstructionRequest(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class UserInfo {
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

  final String? fcmToken;
  final String? imageUrl;

  UserInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.otpVerified,
    required this.pendingDelete,
    required this.deleteAt,
    required this.roleId,
    required this.status,
    required this.isActive,
    required this.fcmToken,
    required this.imageUrl,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'],
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      otpVerified: json['otp_verified'] ?? 0,
      pendingDelete: json['pending_delete'] ?? 0,
      deleteAt: json['delete_at'],
      roleId: json['role_id'],
      status: json['status'] ?? '',
      isActive: json['is_active'] ?? 0,
      fcmToken: json['fcm_token'],
      imageUrl: json['image_url'],
    );
  }
}
