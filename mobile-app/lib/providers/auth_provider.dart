import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/register_model.dart';

class AuthProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isVerifying = false;
  bool isResending = false;

  String? selectedrole;
  int seconds = 90;
  bool isExpired = false;
  String otp = "";
  Timer? timer;

  bool get isValid => (otp.length == 6) && !isExpired;

  void setOtp(String value) {
    otp = value;
    notifyListeners();
  }

  void setExpired(bool value) {
    isExpired = value;
    notifyListeners();
  }

  String get formattedTime {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  Future<http.Response?> login(String email, String password) async {
    isLoading = true;
    notifyListeners();
    try {
      final response = await http.post(
        Uri.parse('$link/api/login'),

        body: {'email': email, 'password': password},
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        String token = data['token'];
        print(token);
      }
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> register(RegisterModel registermodel) async {
    isLoading = true;
    notifyListeners();

    try {
      final respose = await http.post(
        Uri.parse('$link/api/register'),
        headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
        body: jsonEncode(registermodel),
      );
      final data = jsonDecode(respose.body);
      if (respose.statusCode == 200 || respose.statusCode == 201) {
        String token = data['user']['token'];
        await storeToken(token);
        print(token);
      }
      return respose;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setRole(String role) {
    selectedrole = role;
    notifyListeners();
  }

  void startTimer() {
    seconds = 90;
    isExpired = false;
    notifyListeners();
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (seconds > 0) {
        seconds--;
      } else {
        isExpired = true;
        otp = "";
        t.cancel();
      }
      notifyListeners();
    });
  }

  Future<http.Response?> verify(String otp) async {
    isVerifying = true;
    notifyListeners();
    try {
      String? token = await getToken();
      final response = await http.post(
        Uri.parse("$link/api/otp/verify"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
        body: {"otp": otp},
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
      isVerifying = false;
      notifyListeners();
    }
  }

  Future<http.Response?> resendOtp(String email) async {
    if (!isExpired) return null;
    isResending = true;
    notifyListeners();

    String? token = await getToken();
    print(token);

    try {
      final response = await http.post(
        Uri.parse('$link/api/otp/resend'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({'email': email}),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        otp = "";
        startTimer();
      }
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isResending = false;
      notifyListeners();
    }
  }
}
