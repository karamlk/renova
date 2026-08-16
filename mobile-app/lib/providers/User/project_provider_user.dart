import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/User/projects/projects_index.dart';

class ProjectProviderUser extends ChangeNotifier {
  bool isLoading = false;
  List<ProjectIndex> projects = [];
  ProjectIndex? selectedProject;

  Future<http.Response?> fetchProjects() async {
    isLoading = true;

    notifyListeners();

    try {
      final token = await getPrefs("token");

      final response = await http.get(
        Uri.parse("$link/api/user/projects"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);

        projects = data.map((item) => ProjectIndex.fromJson(item as Map<String, dynamic>)).toList();
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

  Future<http.Response?> fetchProjectDetials(int id) async {
    isLoading = true;

    notifyListeners();

    try {
      final token = await getPrefs("token");

      final response = await http.get(
        Uri.parse("$link/api/user/projects/$id"),
        headers: {"Accept": "application/json", "Authorization": "Bearer $token"},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        selectedProject = ProjectIndex.fromJson(data);
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
