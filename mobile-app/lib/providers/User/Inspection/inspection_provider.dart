import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/Extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/inspections/inspection_inedx_model.dart';

class InspectionProvider extends ChangeNotifier {
  bool isLoading = false;
  List<InspectionInedxModel> inspectionindex = [];

  Future<http.Response?> fetchInspectionIndex() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/user/offers'),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final List list = data["data"];
        inspectionindex = list.map((e) => InspectionInedxModel.fromJson(e)).toList();
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
