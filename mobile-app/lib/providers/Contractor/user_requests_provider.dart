import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/user_requests_model.dart';

import '../../extras/link.dart';

class ContractorRequestsProvider extends ChangeNotifier {
  bool isLoading = false;

  List<ContractorRequestModel> requests = [];

  Future<http.Response?> fetchRequests() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse("$link/api/contractor/reconstruction-requests"),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        requests = (body['data'] as List).map((e) => ContractorRequestModel.fromJson(e)).toList();
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
}
