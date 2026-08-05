class RejectedForms {
  int id;
  int reconstructionRequestId;
  int contructorId;
  int engineerId;
  String buildingDescription;
  String warrantyPeriod;
  String excutionDuration;
  String materialCost;
  String laborCost;
  String profit;
  String totalCost;
  String? engineerNotes;
  String? userNotes;
  String status;
  String? pdfFile;
  String? fullPdf;
  String engineerName;
  String reconstructionRequsetTitle;
  String reconstructionRequsetDescription;
  String reconstructionRequsetLocation;
  String reconstructionRequsetType;
  String userName;

  RejectedForms({
    required this.buildingDescription,
    required this.contructorId,
    required this.engineerId,
    required this.engineerName,
    this.engineerNotes,
    required this.excutionDuration,
    required this.id,
    required this.laborCost,
    required this.materialCost,
    this.pdfFile,
    required this.profit,
    required this.reconstructionRequestId,
    required this.reconstructionRequsetDescription,
    required this.reconstructionRequsetLocation,
    required this.reconstructionRequsetTitle,
    required this.reconstructionRequsetType,
    required this.status,
    required this.totalCost,
    required this.userName,
    this.userNotes,
    required this.warrantyPeriod,
    this.fullPdf,
  });

  factory RejectedForms.fromJson(Map<String, dynamic> json) {
    return RejectedForms(
      id: json['id'],
      reconstructionRequestId: json['reconstruction_request_id'],
      contructorId: json["contractor_id"],
      engineerId: json['engineer_id'],
      buildingDescription: json['building_description'],
      warrantyPeriod: json['warranty_period'],
      excutionDuration: json['execution_duration'],
      materialCost: json['materials_cost'],
      laborCost: json['labor_cost'],
      profit: json['profit'],
      totalCost: json['total_cost'],
      engineerNotes: json['engineer_notes'],
      userNotes: json['user_notes'],
      status: json['status'],
      pdfFile: json['pdf_file'],
      fullPdf: json['pdf_file_url'],
      engineerName: json['engineer']['name'],
      reconstructionRequsetTitle: json['reconstruction_request']['title'],
      reconstructionRequsetDescription: json['reconstruction_request']['description'],
      reconstructionRequsetLocation: json['reconstruction_request']['location'],
      reconstructionRequsetType: json['reconstruction_request']['type'],
      userName: json['reconstruction_request']['user']['name'],
    );
  }
}
