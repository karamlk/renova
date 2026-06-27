class InspectionInedxModel {
  final int id;
  final int reconstructionRequestId;
  final int contractorId;
  final String status;
  final String contractorName;
  final String contractorEmail;
  final int requestId;
  final String requestTitle;
  final String requestDesc;
  final String requestLocation;
  final String requestType;
  final String requestDate;

  InspectionInedxModel({
    required this.id,
    required this.reconstructionRequestId,
    required this.contractorId,
    required this.status,
    required this.contractorName,
    required this.contractorEmail,
    required this.requestId,
    required this.requestTitle,
    required this.requestDesc,
    required this.requestLocation,
    required this.requestType,
    required this.requestDate,
  });

  factory InspectionInedxModel.fromJson(Map<String, dynamic> json) {
    return InspectionInedxModel(
      id: json['id'],
      reconstructionRequestId: json['reconstruction_request_id'],
      contractorId: json['contractor_id'],
      status: json['status'],
      contractorName: json['contractor']['name'],
      contractorEmail: json['contractor']['email'],
      requestId: json['request']['id'],
      requestTitle: json['request']['title'],
      requestDesc: json['request']['description'],
      requestLocation: json['request']['location'],
      requestType: json['request']['type'],
      requestDate: json['request']['created_at'],
    );
  }
}
