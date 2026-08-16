class EngineerFormModel {
  EngineerFormModel({
    required this.id,
    required this.beneficiary,
    required this.contractor,
    required this.totalCost,
    required this.status,
    required this.createdAt,
  });
  final int id;
  final String beneficiary;
  final String contractor;
  final double totalCost;
  String status;
  final String createdAt;
}
