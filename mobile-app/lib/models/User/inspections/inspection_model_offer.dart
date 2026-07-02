import 'package:renove_provider/models/User/inspections/inspection_contractor_model.dart';

class InspectionOfferModel {
  final int id;
  final int reconstructionRequestId;
  final int contractorId;
  final String status;
  final InspectionContractorModel contractor;

  InspectionOfferModel({
    required this.id,
    required this.reconstructionRequestId,
    required this.contractorId,
    required this.status,
    required this.contractor,
  });

  factory InspectionOfferModel.fromJson(Map<String, dynamic> json) {
    return InspectionOfferModel(
      id: json['id'],
      reconstructionRequestId: json['reconstruction_request_id'],
      contractorId: json['contractor_id'],
      status: json['status'],
      contractor: InspectionContractorModel.fromJson(json['contractor']),
    );
  }
}
