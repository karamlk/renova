class EngineerModel {
  final int engineerId;
  final String engineerName;
  final String cardNumber;

  EngineerModel({required this.engineerId, required this.engineerName, required this.cardNumber});

  factory EngineerModel.fromJson(Map<String, dynamic> json) {
    return EngineerModel(
      engineerId: json['engineer_id'] as int? ?? 0,
      engineerName: json['engineer_name'] as String? ?? '',
      cardNumber: json['card_number'] as String? ?? '',
    );
  }
}
