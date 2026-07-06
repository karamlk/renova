import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/Extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/User/inspections/contractor_schedule.dart';
import 'package:renove_provider/models/User/inspections/inspection_request_model.dart';

class InspectionProvider extends ChangeNotifier {
  bool isLoading = false;
  bool isLoadingSchedules = false;
  bool isAccepting = false;
  List<ContractorSchedule> schedules = [];

  List<InspectionRequestModel> requests = [];

  Future<void> fetchInspections() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse("$link/api/requests/inspection-requests"),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        requests = (body['data'] as List).map((e) => InspectionRequestModel.fromJson(e)).toList();
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> acceptOffer({
    required int inspectionRequestId,

    required int scheduleId,
  }) async {
    isAccepting = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');

      final response = await http.post(
        Uri.parse("$link/api/inspection-requests/accept"),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
        body: {
          "inspection_request_id": inspectionRequestId.toString(),
          "schedule_id": scheduleId.toString(),
        },
      );

      return response;
    } catch (e) {
      print(e);
      return null;
    } finally {
      isAccepting = false;
      notifyListeners();
    }
  }

  Future<http.Response?> rejectOffer(int offerId) async {
    try {
      final token = await getPrefs('token');

      final response = await http.post(
        Uri.parse("$link/api/inspection-requests/$offerId/reject"),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );

      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> fetchSchedules(int inspectionRequestId) async {
    isLoadingSchedules = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");

      final response = await http.get(
        Uri.parse("$link/api/inspection-requests/$inspectionRequestId/schedules"),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );

      final data = jsonDecode(response.body);

      schedules = (data["data"] as List).map((e) => ContractorSchedule.fromJson(e)).toList();
    } finally {
      isLoadingSchedules = false;
      notifyListeners();
    }
  }
}
