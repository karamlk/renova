class EngineerFormDetailsModel {
  EngineerFormDetailsModel({
    required this.id,
    required this.status,
    required this.beneficiaryName,
    required this.beneficiaryPhone,
    required this.contractorName,
    required this.requestTitle,
    required this.requestDescription,
    required this.requestLocation,
    required this.requestType,
    required this.buildingDescription,
    required this.executionDuration,
    required this.warrantyPeriod,
    required this.materialsCost,
    required this.laborCost,
    required this.profit,
    required this.totalCost,
    required this.materials,
    this.pdfUrl,
  });

  final int id;
  final String status;
  final String beneficiaryName;
  final String beneficiaryPhone;
  final String contractorName;
  final String requestTitle;
  final String requestDescription;
  final String requestLocation;
  final String requestType;
  final String buildingDescription;
  final String executionDuration;
  final String warrantyPeriod;
  final double materialsCost;
  final double laborCost;
  final double profit;
  final double totalCost;
  final List<ConstructionMaterialModel> materials;
  final String? pdfUrl;

  factory EngineerFormDetailsModel.fromJson(Map<String, dynamic> json) {
    final beneficiary = _map(json['beneficiary']);
    final contractor = _map(json['contractor']);
    final request = _map(json['request']);
    final form = _map(json['form']);
    final materials = List<Map<String, dynamic>>.from(
      (json['materials'] as List? ?? []).map(
        (item) => Map<String, dynamic>.from(item as Map),
      ),
    );

    return EngineerFormDetailsModel(
      id: _int(json['id']),
      status: json['status']?.toString() ?? '',
      beneficiaryName: beneficiary['name']?.toString() ?? '',
      beneficiaryPhone: beneficiary['phone']?.toString() ?? '',
      contractorName: contractor['name']?.toString() ?? '',
      requestTitle: request['title']?.toString() ?? '',
      requestDescription: request['description']?.toString() ?? '',
      requestLocation: request['location']?.toString() ?? '',
      requestType: request['type']?.toString() ?? '',
      buildingDescription: form['building_description']?.toString() ?? '',
      executionDuration: form['execution_duration']?.toString() ?? '',
      warrantyPeriod: form['warranty_period']?.toString() ?? '',
      materialsCost: _number(form['materials_cost']),
      laborCost: _number(form['labor_cost']),
      profit: _number(form['profit']),
      totalCost: _number(form['total_cost']),
      materials: materials.map(ConstructionMaterialModel.fromJson).toList(),
      pdfUrl: json['pdf']?.toString(),
    );
  }

  static Map<String, dynamic> _map(dynamic value) =>
      value is Map ? Map<String, dynamic>.from(value) : {};
  static int _int(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;
  static double _number(dynamic value) =>
      double.tryParse(value?.toString() ?? '') ?? 0;
}

class ConstructionMaterialModel {
  ConstructionMaterialModel({
    required this.name,
    required this.type,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    required this.totalPrice,
  });

  final String name;
  final String type;
  final double quantity;
  final String unit;
  final double unitPrice;
  final double totalPrice;

  factory ConstructionMaterialModel.fromJson(Map<String, dynamic> json) {
    double number(dynamic value) =>
        double.tryParse(value?.toString() ?? '') ?? 0;

    return ConstructionMaterialModel(
      name: json['material_name']?.toString() ?? '',
      type: json['material_type']?.toString() ?? '',
      quantity: number(json['quantity']),
      unit: json['unit']?.toString() ?? '',
      unitPrice: number(json['unit_price']),
      totalPrice: number(json['total_price']),
    );
  }
}
