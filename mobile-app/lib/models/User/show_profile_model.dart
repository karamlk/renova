class ShowProfileModel {
  String firstName;
  String lastName;
  String email;
  String phone;
  String location;
  String image;

  ShowProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.location,
    required this.image,
  });

  factory ShowProfileModel.fromJson(Map<String, dynamic> json) {
    return ShowProfileModel(
      firstName: json['data']['profile']['first_name'],
      lastName: json['data']['profile']['last_name'],
      email: json['data']['email'],
      phone: json['data']['profile']['phone'],
      location: json['data']['profile']['location'],
      image: json['data']['profile']['image_url'],
    );
  }
}
