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
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['user']['email'] ?? '',
      phone: data['phone'] ?? '',
      location: data['location'] ?? '',
      companyName: data['company_name'] ?? '',
      commercialRecord: data['commercial_record_url'] ?? '',
      image: data['image_url'] ?? '',
    );
  }
}
