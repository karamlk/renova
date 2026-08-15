import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/User/payments/show_payment.dart';

class PaymentProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isVeriying = false;
  bool isSending = false;

  List<Payment> payments = [];

  Future<http.Response?> fetchPayments() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/payments/pending'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = jsonDecode(response.body);

        payments = data.map((e) => Payment.fromJson(e)).toList();
      }

      return response;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void clearPayments() {
    payments.clear();
    notifyListeners();
  }

  String formatDate(String date) {
    String timeStamp = date;
    String dateOnly = timeStamp.split('T')[0];
    return dateOnly;
  }

  Future<http.Response?> pay(int id, String otp) async {
    isVeriying = true;
    notifyListeners();
    try {
      final token = await getPrefs('token');
      final response = await http.post(
        Uri.parse('$link/api/payments/$id/pay?otp='),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"otp": otp}),
      );
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isVeriying = false;
      notifyListeners();
    }
  }

  Future<http.Response?> sendOtp(int id) async {
    isSending = true;
    notifyListeners();
    try {
      final token = await getPrefs('token');
      final response = await http.post(
        Uri.parse('$link/api/payments/$id/send-otp'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      print(response.body);
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isSending = false;
      notifyListeners();
    }
  }
}
