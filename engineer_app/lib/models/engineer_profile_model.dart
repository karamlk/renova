class EngineerProfileModel {
  EngineerProfileModel({
    required this.name,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.location,
    this.imageUrl,
    required this.specialization,
    required this.syndicateNumber,
    required this.degree,
    required this.yearsOfExperience,
    required this.coveredZones,
    this.bio,
    this.syndicateCardUrl,
    this.certificateUrl,
  });
  final String name,
      email,
      firstName,
      lastName,
      phone,
      location,
      specialization,
      syndicateNumber,
      degree,
      coveredZones;
  final int yearsOfExperience;
  final String? imageUrl, bio, syndicateCardUrl, certificateUrl;
  factory EngineerProfileModel.fromJson(Map<String, dynamic> json) {
    final personal = Map<String, dynamic>.from(json['profile'] as Map? ?? {});
    final engineer = Map<String, dynamic>.from(
      json['engineer_profile'] as Map? ?? {},
    );
    return EngineerProfileModel(
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      firstName:
          personal['first_name']?.toString() ??
          engineer['first_name']?.toString() ??
          '',
      lastName:
          personal['last_name']?.toString() ??
          engineer['last_name']?.toString() ??
          '',
      phone:
          personal['phone']?.toString() ?? engineer['phone']?.toString() ?? '',
      location:
          personal['location']?.toString() ??
          engineer['location']?.toString() ??
          '',
      imageUrl: personal['image']?.toString() ?? engineer['image']?.toString(),
      specialization: engineer['specialization']?.toString() ?? '',
      syndicateNumber: engineer['syndicate_number']?.toString() ?? '',
      degree: engineer['degree']?.toString() ?? '',
      yearsOfExperience:
          int.tryParse(engineer['years_of_experience']?.toString() ?? '') ?? 0,
      coveredZones: engineer['covered_zones']?.toString() ?? '',
      bio: engineer['bio']?.toString(),
      syndicateCardUrl: engineer['syndicate_card_image']?.toString(),
      certificateUrl: engineer['certificate_file']?.toString(),
    );
  }
}
