class ShowContractorProfileModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String location;
  String companyName;
  String commercialRecord;
  String image;
  String role;

  ShowContractorProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.location,
    required this.companyName,
    required this.commercialRecord,
    required this.image,
    required this.role,
  });

  factory ShowContractorProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return ShowContractorProfileModel(
      firstName: data['original']['profile']['first_name'] ?? '',
      lastName: data['original']['profile']['last_name'] ?? '',
      email: data['original']['user']['email'] ?? '',
      phone: data['original']['profile']['phone'] ?? '',
      location: data['original']['profile']['location'] ?? '',
      companyName: data['original']['profile']['company_name'] ?? '',
      commercialRecord: data['original']['profile']['commercial_record_url'] ?? '',
      image: data['original']['profile']['image_url'] ?? '',
      role: data['original']['user']['role']['name'],
    );
  }
}
