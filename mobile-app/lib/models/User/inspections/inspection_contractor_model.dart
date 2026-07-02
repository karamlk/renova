class InspectionContractorModel {
  final int id;
  final String name;
  final String email;

  InspectionContractorModel({required this.id, required this.name, required this.email});

  factory InspectionContractorModel.fromJson(Map<String, dynamic> json) {
    return InspectionContractorModel(id: json['id'], name: json['name'], email: json['email']);
  }
}
