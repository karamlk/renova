import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:renova/Extras/link.dart';
import 'package:renova/Extras/sharedpreferences.dart';

class Verifycontroller extends GetxController {
  var seconds = 90.obs;
  var isexpired = false.obs;
  var isLoading = false.obs;
  var otp = "".obs;
  final TextEditingController otpcontroller = TextEditingController();
  Timer? timer;

  @override
  void onInit() {
    startTimer();
    super.onInit();
  }

  void startTimer() {
    seconds.value = 90;
    isexpired.value = false;
    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      if (seconds.value > 0) {
        seconds--;
      } else {
        isexpired.value = true;
        t.cancel();
      }
    });
  }

  String get formattedTime {
    int min = seconds.value ~/ 60;
    int sec = seconds.value % 60;
    return "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}";
  }

  Future<http.Response?> verify() async {
    isLoading.value = true;
    try {
      String? token = await getToken();
      final response = await http.post(
        Uri.parse("$link/api/otp/verify"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
        body: {"otp": otpcontroller.text},
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

  Future<void> resendOtp() async {
    startTimer();

    //
    @override
    void onClose() {
      timer?.cancel();
      otpcontroller.dispose();
      super.onClose();
    }
  }
}
