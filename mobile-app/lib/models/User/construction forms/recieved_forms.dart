import 'dart:convert';

class RecievedForms {
  int id;
  int reconstructionRequestId;
  int contractorId;
  int engineerId;
  String? buildingDescription;
  String warrantyPeriod;
  String excutionDuration;
  String materialsCost;
  String laborCost;
  String profit;
  String totalCost;
  String? engineerNotes;
  String? userNotes;
  String status;
  String? pdfFile;
  String? pdfFileUrl;
  String contactorName;

  RecievedForms({
    required this.id,
    required this.reconstructionRequestId,
    required this.contractorId,
    required this.engineerId,
    this.buildingDescription,
    required this.warrantyPeriod,
    required this.excutionDuration,
    required this.materialsCost,
    required this.laborCost,
    required this.profit,
    required this.totalCost,
    this.engineerNotes,
    this.userNotes,
    required this.status,
    this.pdfFile,
    this.pdfFileUrl,
    required this.contactorName,
  });

  factory RecievedForms.fromJson(Map<String, dynamic> json) {
    return RecievedForms(
      id: json['id'],
      reconstructionRequestId: json['reconstruction_request_id'],
      contractorId: json['contractor_id'],
      engineerId: json['engineer_id'],
      buildingDescription: json['building_description'],
      warrantyPeriod: json['warranty_period'],
      excutionDuration: json['execution_duration'],
      materialsCost: json['materials_cost'],
      laborCost: json['labor_cost'],
      profit: json['profit'],
      totalCost: json['total_cost'],
      engineerNotes: json['engineer_notes'],
      userNotes: json['user_notes'],
      status: json['status'],
      pdfFile: json['pdf_file'],
      pdfFileUrl: json['pdf_file_url'],
      contactorName: json['contractor']['name'],
    );
  }
}
