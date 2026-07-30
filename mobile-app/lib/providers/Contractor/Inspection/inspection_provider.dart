import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/InspectionRequests/show_inspection_request_model.dart';

class ContractorInspectionRequestsProvider extends ChangeNotifier {
  bool isLoading = false;

  List<ShowInspectionRequestModel> requests = [];

  Future<http.Response?> fetchRequests() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");

      final response = await http.get(
        Uri.parse("$link/api/contractor/visits"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        requests = (data['data'] as List)
            .map((e) => ShowInspectionRequestModel.fromJson(e))
            .toList();
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
}
