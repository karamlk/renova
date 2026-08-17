class ShowAllPostsModel {
  final int id;
  final int projectId;
  final int userId;
  final String title;
  final String description;
  final String status;
  final double progress;
  final String? createdAt;
  final DateTime? updatedAt;
  int likesCount;
  bool isLiked;
  final List<PostImageModel> images;
  final PostUserModel? user;
  final PostProjectModel? project;

  ShowAllPostsModel({
    required this.id,
    required this.projectId,
    required this.userId,
    required this.title,
    required this.description,
    required this.status,
    required this.progress,
    this.createdAt,
    this.updatedAt,
    required this.likesCount,
    required this.images,
    this.user,
    this.project,
    required this.isLiked,
  });

  factory ShowAllPostsModel.fromJson(Map<String, dynamic> json) {
    return ShowAllPostsModel(
      id: json['id'] ?? 0,
      projectId: json['project_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      isLiked: json['is_liked'],
      progress: double.tryParse(json['progress'].toString()) ?? 0.0,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      likesCount: json['likes_count'] ?? 0,
      images: (json['images'] as List<dynamic>? ?? [])
          .map((e) => PostImageModel.fromJson(e))
          .toList(),
      user: json['user'] != null ? PostUserModel.fromJson(json['user']) : null,
      project: json['project'] != null ? PostProjectModel.fromJson(json['project']) : null,
    );
  }
}

class PostImageModel {
  final int id;
  final int contractorPostId;
  final String image;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  PostImageModel({
    required this.id,
    required this.contractorPostId,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  factory PostImageModel.fromJson(Map<String, dynamic> json) {
    return PostImageModel(
      id: json['id'] ?? 0,
      contractorPostId: json['contractor_post_id'] ?? 0,
      image: json['image'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }
}

class PostUserModel {
  final int id;
  final String name;
  final String email;
  final String? emailVerifiedAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int otpVerified;
  final int pendingDelete;
  final DateTime? deleteAt;
  final int roleId;
  final String status;
  final int isActive;
  final String? fcmToken;
  final String? imageUrl;
  final ContractorProfileModel? contractorProfile;

  PostUserModel({
    required this.id,
    required this.name,
    required this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    required this.otpVerified,
    required this.pendingDelete,
    this.deleteAt,
    required this.roleId,
    required this.status,
    required this.isActive,
    this.fcmToken,
    this.imageUrl,
    this.contractorProfile,
  });

  factory PostUserModel.fromJson(Map<String, dynamic> json) {
    return PostUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      otpVerified: json['otp_verified'] ?? 0,
      pendingDelete: json['pending_delete'] ?? 0,
      deleteAt: json['delete_at'] != null ? DateTime.tryParse(json['delete_at']) : null,
      roleId: json['role_id'] ?? 0,
      status: json['status'] ?? '',
      isActive: json['is_active'] ?? 0,
      fcmToken: json['fcm_token'],
      imageUrl: json['image_url'],
      contractorProfile: json['contractor_profile'] != null
          ? ContractorProfileModel.fromJson(json['contractor_profile'])
          : null,
    );
  }
}

class ContractorProfileModel {
  final int id;
  final int userId;
  final String firstName;
  final String lastName;
  final String phone;
  final String? image;
  final String? location;
  final String? companyName;
  final String? commercialRecord;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? imageUrl;
  final String? fullImageUrl;
  final String? commercialRecordUrl;
  final String? fullCommercialRecordUrl;

  ContractorProfileModel({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    this.image,
    this.location,
    this.companyName,
    this.commercialRecord,
    this.createdAt,
    this.updatedAt,
    this.imageUrl,
    this.fullImageUrl,
    this.commercialRecordUrl,
    this.fullCommercialRecordUrl,
  });

  factory ContractorProfileModel.fromJson(Map<String, dynamic> json) {
    return ContractorProfileModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      phone: json['phone'] ?? '',
      image: json['image'],
      location: json['location'],
      companyName: json['company_name'],
      commercialRecord: json['commercial_record'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      imageUrl: json['image_url'],
      fullImageUrl: json['full_image_url'],
      commercialRecordUrl: json['commercial_record_url'],
      fullCommercialRecordUrl: json['full_commercial_record_url'],
    );
  }
}

class PostProjectModel {
  final int id;
  final int constructionFormId;
  final int contractorId;
  final int engineerId;
  final int userId;
  final double progress;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ConstructionFormModel? form;
  final PostUserModel? engineer;

  PostProjectModel({
    required this.id,
    required this.constructionFormId,
    required this.contractorId,
    required this.engineerId,
    required this.userId,
    required this.progress,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.form,
    this.engineer,
  });

  factory PostProjectModel.fromJson(Map<String, dynamic> json) {
    return PostProjectModel(
      id: json['id'] ?? 0,
      constructionFormId: json['construction_form_id'] ?? 0,
      contractorId: json['contractor_id'] ?? 0,
      engineerId: json['engineer_id'] ?? 0,
      userId: json['user_id'] ?? 0,
      progress: double.tryParse(json['progress'].toString()) ?? 0.0,
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      form: json['form'] != null ? ConstructionFormModel.fromJson(json['form']) : null,
      engineer: json['engineer'] != null ? PostUserModel.fromJson(json['engineer']) : null,
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
  final String? pdfFile;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? pdfFileUrl;
  final ReconstructionRequestModel? reconstructionRequest;

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
    this.pdfFile,
    this.createdAt,
    this.updatedAt,
    this.pdfFileUrl,
    this.reconstructionRequest,
  });

  factory ConstructionFormModel.fromJson(Map<String, dynamic> json) {
    return ConstructionFormModel(
      id: json['id'] ?? 0,
      reconstructionRequestId: json['reconstruction_request_id'] ?? 0,
      contractorId: json['contractor_id'] ?? 0,
      engineerId: json['engineer_id'] ?? 0,
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
      pdfFile: json['pdf_file'],
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
      pdfFileUrl: json['pdf_file_url'],
      reconstructionRequest: json['reconstruction_request'] != null
          ? ReconstructionRequestModel.fromJson(json['reconstruction_request'])
          : null,
    );
  }
}

class ReconstructionRequestModel {
  final int id;
  final int userId;
  final String title;
  final String description;
  final String location;
  final String type;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ReconstructionRequestModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ReconstructionRequestModel.fromJson(Map<String, dynamic> json) {
    return ReconstructionRequestModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.tryParse(json['updated_at']) : null,
    );
  }
}
