import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/contractor_schedule_model.dart';

class ContractorScheduleProvider extends ChangeNotifier {
  bool isLoading = false;

  List<ContractorScheduleModel> schedules = [];

  Future<void> fetchSchedules() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/contractor/schedules'),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        schedules = (data['data'] as List).map((e) => ContractorScheduleModel.fromJson(e)).toList();
      }
    } catch (e) {
      print(e);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<http.Response?> addSchedule({
    required String day,

    required String startTime,
    required String endTime,
  }) async {
    isLoading = true;
    notifyListeners();
    try {
      final token = await getPrefs('token');

      final response = await http.post(
        Uri.parse('$link/api/contractor/schedules'),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
        body: {"day_of_week": day, 'start_time': startTime, 'end_time': endTime},
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        await fetchSchedules();
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

  Future<http.Response?> updateSchedule({
    required int id,
    required String day,

    required String startTime,
    required String endTime,
  }) async {
    try {
      final token = await getPrefs('token');

      final response = await http.post(
        Uri.parse('$link/api/contractor/schedules/update/$id'),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
        body: {'day_of_week': day, 'start_time': startTime, 'end_time': endTime},
      );

      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> deleteSchedule(int id) async {
    try {
      final token = await getPrefs('token');

      final response = await http.delete(
        Uri.parse('$link/api/contractor/schedules/$id'),
        headers: {"Authorization": "Bearer $token", "Accept": "application/json"},
      );

      return response.statusCode == 200;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
