import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/Extras/shared_preferneces.dart';
import 'package:renove_provider/extras/link.dart';

class RequestDetailsProvider extends ChangeNotifier {
  bool isLoading = false;
  Map<String, dynamic>? details;

  Future<http.Response?> fetchDetails(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/reconstruction-requests/$id'),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        details = data['data'];
      }
      print(response.body);
      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
