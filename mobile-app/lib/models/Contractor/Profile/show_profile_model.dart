class ShowContractorProfileModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String location;
  String companyName;
  String commercialRecord;
  String image;

  ShowContractorProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.location,
    required this.companyName,
    required this.commercialRecord,
    required this.image,
  });

  factory ShowContractorProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return ShowContractorProfileModel(
      firstName: data['profile']['first_name'] ?? '',
      lastName: data['profile']['last_name'] ?? '',
      email: data['email'] ?? '',
      phone: data['profile']['phone'] ?? '',
      location: data['profile']['location'] ?? '',
      companyName: data['company_name'] ?? '',
      commercialRecord: data['profile']['commercial_record_url'] ?? '',
      image: data['profile']['image_url'] ?? '',
    );
  }
}
