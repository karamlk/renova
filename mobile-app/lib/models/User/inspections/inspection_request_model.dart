import 'package:renove_provider/models/User/inspections/inspection_model_offer.dart';

class InspectionRequestModel {
  final int id;
  final String title;
  final String description;
  final String location;
  final String type;
  final String status;

  final List<InspectionOfferModel> offers;

  InspectionRequestModel({
    required this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.type,
    required this.status,
    required this.offers,
  });

  factory InspectionRequestModel.fromJson(Map<String, dynamic> json) {
    return InspectionRequestModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      location: json['location'],
      type: json['type'],
      status: json['status'],
      offers: (json['inspection_requests'] as List)
          .map((e) => InspectionOfferModel.fromJson(e))
          .toList(),
    );
  }
}
