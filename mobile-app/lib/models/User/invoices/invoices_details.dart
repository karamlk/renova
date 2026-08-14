class InvoiceDetails {
  final int id;
  final String invoiceNumber;
  final int paymentId;
  final int projectId;
  final int userId;
  final int contractorId;
  final String amount;
  final String invoiceType;
  final String status;
  final String? pdfFile;
  final String? notes;
  final String issuedAt;
  final String createdAt;
  final String updatedAt;

  final InvoicePayment payment;
  final InvoiceProject project;
  final InvoicePerson user;
  final InvoicePerson contractor;

  InvoiceDetails({
    required this.id,
    required this.invoiceNumber,
    required this.paymentId,
    required this.projectId,
    required this.userId,
    required this.contractorId,
    required this.amount,
    required this.invoiceType,
    required this.status,
    this.pdfFile,
    this.notes,
    required this.issuedAt,
    required this.createdAt,
    required this.updatedAt,
    required this.payment,
    required this.project,
    required this.user,
    required this.contractor,
  });

  factory InvoiceDetails.fromJson(Map<String, dynamic> json) {
    return InvoiceDetails(
      id: json['id'],
      invoiceNumber: json['invoice_number'],
      paymentId: json['payment_id'],
      projectId: json['project_id'],
      userId: json['user_id'],
      contractorId: json['contractor_id'],
      amount: json['amount'],
      invoiceType: json['invoice_type'],
      status: json['status'],
      pdfFile: json['pdf_file'],
      notes: json['notes'],
      issuedAt: json['issued_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],

      payment: InvoicePayment.fromJson(json['payment']),
      project: InvoiceProject.fromJson(json['project']),
      user: InvoicePerson.fromJson(json['user']),
      contractor: InvoicePerson.fromJson(json['contractor']),
    );
  }
}

class InvoicePayment {
  final int id;
  final int constructionFormId;
  final int userId;
  final String amount;
  final String type;
  final String status;
  final String paidAt;
  final String createdAt;
  final String updatedAt;
  final String releasedAmount;

  InvoicePayment({
    required this.id,
    required this.constructionFormId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.status,
    required this.paidAt,
    required this.createdAt,
    required this.updatedAt,
    required this.releasedAmount,
  });

  factory InvoicePayment.fromJson(Map<String, dynamic> json) {
    return InvoicePayment(
      id: json['id'],
      constructionFormId: json['construction_form_id'],
      userId: json['user_id'],
      amount: json['amount'],
      type: json['type'],
      status: json['status'],
      paidAt: json['paid_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      releasedAmount: json['released_amount'],
    );
  }
}

class InvoiceProject {
  final int id;
  final int constructionFormId;
  final int contractorId;
  final int engineerId;
  final int userId;
  final String progress;
  final String status;
  final String createdAt;
  final String updatedAt;

  InvoiceProject({
    required this.id,
    required this.constructionFormId,
    required this.contractorId,
    required this.engineerId,
    required this.userId,
    required this.progress,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory InvoiceProject.fromJson(Map<String, dynamic> json) {
    return InvoiceProject(
      id: json['id'],
      constructionFormId: json['construction_form_id'],
      contractorId: json['contractor_id'],
      engineerId: json['engineer_id'],
      userId: json['user_id'],
      progress: json['progress'],
      status: json['status'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

class InvoicePerson {
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

  InvoicePerson({
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

  factory InvoicePerson.fromJson(Map<String, dynamic> json) {
    return InvoicePerson(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      emailVerifiedAt: json['email_verified_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      otpVerified: json['otp_verified'],
      pendingDelete: json['pending_delete'],
      deleteAt: json['delete_at'],
      roleId: json['role_id'],
      status: json['status'],
      isActive: json['is_active'],
      imageUrl: json['image_url'],
    );
  }
}
