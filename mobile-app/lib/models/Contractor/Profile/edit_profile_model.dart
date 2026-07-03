class EditContractorProfileModel {
  final String firstName;
  final String lastName;
  final String location;
  final String phone;
  final String companyName;

  EditContractorProfileModel({
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.phone,
    required this.companyName,
  });

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'location': location,
      'phone': phone,
      'company_name': companyName,
    };
  }
}
