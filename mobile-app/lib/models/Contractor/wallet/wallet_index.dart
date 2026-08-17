class WalletModel {
  final String balance;
  final String cardNumber;
  final List<TransactionModel> transactions;

  WalletModel({required this.balance, required this.cardNumber, required this.transactions});

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      balance: json['balance']?.toString() ?? '0.00',
      cardNumber: json['card_number']?.toString() ?? '',
      transactions:
          (json['transactions'] as List<dynamic>?)
              ?.map((e) => TransactionModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class TransactionModel {
  final int id;
  final int? paymentId;
  final int fromUserId;
  final int toUserId;
  final String amount;
  final String action;
  final String description;
  final String createdAt;
  final String updatedAt;

  final UserModel fromUser;
  final UserModel toUser;

  final PaymentModel? payment;

  TransactionModel({
    required this.id,
    this.paymentId,
    required this.fromUserId,
    required this.toUserId,
    required this.amount,
    required this.action,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.fromUser,
    required this.toUser,
    this.payment,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      paymentId: json['payment_id'],
      fromUserId: json['from_user_id'],
      toUserId: json['to_user_id'],
      amount: json['amount']?.toString() ?? '0.00',
      action: json['action'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      fromUser: UserModel.fromJson(json['from_user'] ?? {}),
      toUser: UserModel.fromJson(json['to_user'] ?? {}),
      payment: json['payment'] != null ? PaymentModel.fromJson(json['payment']) : null,
    );
  }
}

class UserModel {
  final int id;
  final String name;
  final String? imageUrl;

  UserModel({required this.id, required this.name, this.imageUrl});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(id: json['id'], name: json['name'] ?? '', imageUrl: json['image_url']);
  }
}

class PaymentModel {
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
  final InvoiceModel? invoice;

  PaymentModel({
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
    this.invoice,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
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
      invoice: json['invoice'] != null ? InvoiceModel.fromJson(json['invoice']) : null,
    );
  }
}

class InvoiceModel {
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

  InvoiceModel({
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

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
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
