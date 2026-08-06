import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/User/construction%20forms/received_forms_details.dart';
import 'package:renove_provider/models/User/construction%20forms/recieved_forms.dart';
import 'package:renove_provider/screens/User/construction%20forms/received_forms_details.dart';

class ContrsutionFormsProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isReviewing = false;
  List<RecievedForms> recievedForms = [];
  ReceivedFormDetails? details;

  Future<http.Response?> fetchReceivedForms() async {
    isLoading = true;
    notifyListeners();
    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/receivedForms'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = jsonDecode(response.body);
        recievedForms = data.map((e) => RecievedForms.fromJson(e)).toList();
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

  Future<http.Response?> fetchRecievedDetails(int id) async {
    isLoading = true;

    notifyListeners();
    try {
      final token = await getPrefs('token');
      final response = await http.get(
        Uri.parse('$link/api/showForm/$id'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        details = ReceivedFormDetails.fromJson(jsonDecode(response.body));
      }
      print(response.statusCode);

      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> reviewForm({
    required int id,
    required String status,
    String? userNotes,
  }) async {
    isReviewing = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");

      final response = await http.put(
        Uri.parse("$link/api/construction-forms/$id/user-review"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"status": status, "user_notes": userNotes}),
      );
      print("${response.statusCode}: ${response.body}");
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isReviewing = false;
      notifyListeners();
    }
  }

  Future<http.Response?> verifyReviewOtp({required int id, required String otp}) async {
    isReviewing = true;
    notifyListeners();
    try {
      final token = await getPrefs("token");

      final response = await http.put(
        Uri.parse("$link/api/construction-forms/$id/confirm-payment"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"otp": otp}),
      );
      print(response.body);
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isReviewing = false;
      notifyListeners();
    }
  }
}
