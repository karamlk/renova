import 'dart:io';

class DonationCampaign {
  final String title;
  final String description;
  final String targetAmount;
  final String startsAt;
  final String endsAt;
  final String location;
  final List<File> images;

  DonationCampaign({
    required this.title,
    required this.description,
    required this.targetAmount,
    required this.startsAt,
    required this.endsAt,
    required this.location,
    required this.images,
  });

  // Converts the text fields to a Map for MultipartRequest fields
  Map<String, String> toMap() {
    return {
      'title': title,
      'description': description,
      'target_amount': targetAmount,
      'starts_at': startsAt,
      'ends_at': endsAt,
      'location': location,
    };
  }
}
