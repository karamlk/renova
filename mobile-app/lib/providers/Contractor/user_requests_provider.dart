import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/user_requests_model.dart';

import '../../extras/link.dart';

class ContractorRequestsProvider extends ChangeNotifier {
  bool isLoading = false;
  String? selectedType;
  String? selectedLocation;

  List<ContractorRequestModel> requests = [];

  Future<http.Response?> fetchRequests({String? location, String? type}) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');
      final query = <String, String>{};

      if (location != null && location.trim().isNotEmpty) {
        query['location'] = location;
      }

      if (type != null && type.isNotEmpty) {
        query['type'] = type;
      }

      final response = await http.get(
        Uri.parse(
          "$link/api/contractor/reconstruction-requests",
        ).replace(queryParameters: query.isEmpty ? null : query),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        requests = (body['data'] as List).map((e) => ContractorRequestModel.fromJson(e)).toList();
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

  Future<http.Response?> makeOffer(int requestId) async {
    try {
      final token = await getPrefs('token');

      final response = await http.post(
        Uri.parse('$link/api/inspection-requests?reconstruction_request_id=$requestId'),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );

      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}
