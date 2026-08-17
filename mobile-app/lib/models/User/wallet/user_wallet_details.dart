class PaymentUserDetailsModel {
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

  final PaymentUserModel user;
  final PaymentInvoiceModel? invoice;
  final List<PaymentAuditModel> audits;

  PaymentUserDetailsModel({
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
    required this.user,
    this.invoice,
    required this.audits,
  });

  factory PaymentUserDetailsModel.fromJson(Map<String, dynamic> json) {
    return PaymentUserDetailsModel(
      id: json['id'],
      constructionFormId: json['construction_form_id'],
      userId: json['user_id'],
      amount: json['amount']?.toString() ?? '0.00',
      type: json['type'] ?? '',
      status: json['status'] ?? '',
      paidAt: json['paid_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      releasedAmount: json['released_amount']?.toString() ?? '0.00',

      user: PaymentUserModel.fromJson(json['user'] ?? {}),

      invoice: json['invoice'] != null ? PaymentInvoiceModel.fromJson(json['invoice']) : null,

      audits:
          (json['audits'] as List<dynamic>?)?.map((e) => PaymentAuditModel.fromJson(e)).toList() ??
          [],
    );
  }
}

class PaymentUserModel {
  final int id;
  final String name;
  final String? imageUrl;

  PaymentUserModel({required this.id, required this.name, this.imageUrl});

  factory PaymentUserModel.fromJson(Map<String, dynamic> json) {
    return PaymentUserModel(id: json['id'], name: json['name'] ?? '', imageUrl: json['image_url']);
  }
}

class PaymentInvoiceModel {
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
  final String notes;
  final String issuedAt;
  final String createdAt;
  final String updatedAt;

  PaymentInvoiceModel({
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
    required this.notes,
    required this.issuedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentInvoiceModel.fromJson(Map<String, dynamic> json) {
    return PaymentInvoiceModel(
      id: json['id'],
      invoiceNumber: json['invoice_number'] ?? '',
      paymentId: json['payment_id'],
      projectId: json['project_id'],
      userId: json['user_id'],
      contractorId: json['contractor_id'],
      amount: json['amount']?.toString() ?? '0.00',
      invoiceType: json['invoice_type'] ?? '',
      status: json['status'] ?? '',
      pdfFile: json['pdf_file'],
      notes: json['notes'] ?? '',
      issuedAt: json['issued_at'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class PaymentAuditModel {
  final int id;
  final int paymentId;
  final int fromUserId;
  final int toUserId;
  final String amount;
  final String action;
  final String description;
  final String createdAt;
  final String updatedAt;

  final PaymentUserModel fromUser;
  final PaymentUserModel toUser;

  PaymentAuditModel({
    required this.id,
    required this.paymentId,
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
    required this.action,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.fromUser,
    required this.toUser,
  });

  factory PaymentAuditModel.fromJson(Map<String, dynamic> json) {
    return PaymentAuditModel(
      id: json['id'],
      paymentId: json['payment_id'],
      fromUserId: json['from_user_id'],
      toUserId: json['to_user_id'],
      amount: json['amount']?.toString() ?? '0.00',
      action: json['action'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',

      fromUser: PaymentUserModel.fromJson(json['from_user'] ?? {}),

      toUser: PaymentUserModel.fromJson(json['to_user'] ?? {}),
    );
  }
}
