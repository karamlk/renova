import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/construction_request_index.dart';

class ConstructionIndexProvider extends ChangeNotifier {
  bool isLoading = false;
  List<ConstructionRequestIndex> requestsIndex = [];

  Future<http.Response?> fetchRequestIndex() async {
    isLoading = true;
    notifyListeners();
    try {
      final token = await getPrefs('token');
      final response = await http.get(
        Uri.parse('$link/api/reconstruction-requests'),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print(data);

        final List list = data['data'];

        requestsIndex = list.map((e) => ConstructionRequestIndex.fromJson(e)).toList();
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
