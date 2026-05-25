class loginClass {
  String? email;
  String? password;

  loginClass({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}
