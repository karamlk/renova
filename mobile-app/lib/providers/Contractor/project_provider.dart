import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/projects/projectdetails.dart';
import 'package:renove_provider/models/Contractor/projects/projects_index.dart';
import 'package:renove_provider/screens/Contractor/projects/project_details.dart';

class ProjectProvider extends ChangeNotifier {
  bool isLoading = false;

  List<Project> projects = [];
  ProjectDetails? details;
  Future<http.Response?> fetchProjects() async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/contractor/projects'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List data = jsonDecode(response.body);

        projects = data.map((e) => Project.fromJson(e)).toList();
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

  void clearProjects() {
    projects.clear();
    notifyListeners();
  }

  Future<http.Response?> fetchProjectDetails(int id) async {
    isLoading = true;
    notifyListeners();

    try {
      final token = await getPrefs('token');

      final response = await http.get(
        Uri.parse('$link/api/contractor/projects/$id'),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        details = ProjectDetails.fromJson(jsonDecode(response.body));
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
