import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/state_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';
import 'package:renova/Extras/link.dart';
import 'package:renova/Extras/sharedpreferences.dart';
import 'package:renova/Login&Resgister/Login/loginClass.dart';

class Logincontroller extends GetxController {
  var isLoading = false.obs;
  final TextEditingController emailnamecontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();

  Future<http.Response?> login() async {
    final login = loginClass(email: emailnamecontroller.text, password: passwordcontroller.text);
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('$link/api/login'),
        body: {'email': emailnamecontroller.text, 'password': passwordcontroller.text},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        String token = data['token'];
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
