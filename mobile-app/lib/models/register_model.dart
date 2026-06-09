class RegisterModel {
  final String name;
  final String email;
  final String password;
  final String passwordconfirmation;
  final String role;

  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordconfirmation,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordconfirmation,
      'role': role,
    };
  }
}
