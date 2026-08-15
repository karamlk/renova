class Payment {
  final int id;
  final int constructionFormId;
  final int userId;
  final String amount;
  final String type;
  final String status;
  final String? paidAt;
  final String createdAt;
  final String updatedAt;
  final String releasedAmount;

  Payment({
    required this.id,
    required this.constructionFormId,
    required this.userId,
    required this.amount,
    required this.type,
    required this.status,
    this.paidAt,
    required this.createdAt,
    required this.updatedAt,
    required this.releasedAmount,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
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
