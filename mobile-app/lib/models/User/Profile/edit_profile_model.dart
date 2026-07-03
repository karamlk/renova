class EditProfileModel {
  final String firstName;
  final String lastName;
  final String location;
  final String phone;

  EditProfileModel({
    required this.firstName,
    required this.lastName,
    required this.location,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {"first_name": firstName, "last_name": lastName, "location": location, "phone": phone};
  }
}
