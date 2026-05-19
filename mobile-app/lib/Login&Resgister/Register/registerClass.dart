class Registerclass {
  String? name;
  String? email;
  String? password;
  String? passwordconfirmation;
  String? role;

  Registerclass({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordconfirmation,
    required this.role,
  });
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
    'password_confirmation': passwordconfirmation,
    'role': role,
  };
}
