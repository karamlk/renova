class ChangePasswordModel {
  String oldPassword;
  String newPassword;
  String repeatedPassword;

  ChangePasswordModel({
    required this.oldPassword,
    required this.newPassword,
    required this.repeatedPassword,
  });
  Map<String, dynamic> toJson() {
    return {
      'current_password': oldPassword,
      'new_password': newPassword,
      'new_password_confirmation': repeatedPassword,
    };
  }
}
