import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:renova/Extras/link.dart';
import 'package:renova/Extras/sharedpreferences.dart';
import 'package:renova/Login&Resgister/Register/registerclass.dart';
import 'package:http/http.dart' as http;

class Registercontroller extends GetxController {
  var isLoading = false.obs;
  var role = "".obs;
  var selectedrole = ''.obs;
  final roles = {"user": "مستخدم", "contractor": "متعهد"};
  final TextEditingController namecontroller = TextEditingController();
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController passwordconfirmcontroller = TextEditingController();
  final TextEditingController rolecontroller = TextEditingController();

  Future<http.Response?> register() async {
    final register = Registerclass(
      name: namecontroller.text,
      email: emailcontroller.text,
      password: passwordcontroller.text,
      passwordconfirmation: passwordconfirmcontroller.text,
      role: rolecontroller.text,
    );
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("$link/api/register"),
        headers: {"Accept": "application/json", "Content-Type": "application/json"},
        body: jsonEncode(register.toJson()),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        String token = data['user']['token'];
        await storeToken(token);
        print(token);
      }
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading.value = false;
    }
  }
}
