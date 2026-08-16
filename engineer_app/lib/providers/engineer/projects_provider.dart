import 'package:engineer_app/models/project_model.dart';
import 'dart:convert';
import 'package:engineer_app/extras/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// بيانات مؤقتة مطابقة لعقد /api/projects و /api/projects/{project}.
class ProjectsProvider extends ChangeNotifier {
  final List<ProjectModel> projects = [
    ProjectModel(
      id: 1,
      beneficiary: 'محمد الأحمد',
      contractor: 'شركة الروضة للمقاولات',
      status: 'نشط',
      progress: 35,
      totalCost: 28500000,
      tasks: [
        TaskModel(
          id: 11,
          title: 'مراجعة المخططات الإنشائية',
          description: 'مراجعة المخططات قبل التنفيذ',
          percentage: 35,
        ),
        TaskModel(
          id: 12,
          title: 'أعمال الهيكل',
          description: 'متابعة أعمال الصب',
          percentage: 40,
        ),
      ],
    ),
    ProjectModel(
      id: 2,
      beneficiary: 'سارة الحسن',
      contractor: 'مؤسسة النور',
      status: 'نشط',
      progress: 68,
      totalCost: 18000000,
      tasks: [
        TaskModel(
          id: 21,
          title: 'أعمال العزل',
          description: 'فحص طبقات العزل',
          percentage: 30,
          isCompleted: true,
        ),
        TaskModel(
          id: 22,
          title: 'الدفعة الثانية',
          description: 'تدقيق إنجاز الدفعة',
          percentage: 38,
          isCompleted: true,
        ),
      ],
    ),
  ];

  int _nextTaskId = 100;
  Future<String?> fetchProjects(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/projects'),
        headers: _headers(token),
      );
      final data = _data(response);
      if (response.statusCode < 200 || response.statusCode >= 300)
        return _message(response);
      projects
        ..clear()
        ..addAll(
          data.map(
            (item) => ProjectModel(
              id: _integer(item['id']),
              beneficiary: item['beneficiary']?.toString() ?? '',
              contractor: item['contractor']?.toString() ?? '',
              status: item['status']?.toString() ?? '',
              progress: _double(item['progress']),
              tasks: [],
            ),
          ),
        );
      notifyListeners();
      return null;
    } catch (_) {
      return 'تعذر الاتصال بالخادم المحلي.';
    }
  }

  Future<String?> fetchTasks(String token, ProjectModel project) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/projects/${project.id}'),
        headers: _headers(token),
      );
      final body = _body(response);
      if (response.statusCode < 200 || response.statusCode >= 300)
        return body['message']?.toString() ?? 'تعذر تحميل المهام.';
      final projectData = Map<String, dynamic>.from(
        (body['data'] as Map?) ?? body,
      );
      final tasks = List<Map<String, dynamic>>.from(
        (projectData['tasks'] as List? ?? []).map(
          (item) => Map<String, dynamic>.from(item as Map),
        ),
      );
      project.tasks
        ..clear()
        ..addAll(
          tasks.map(
            (item) => TaskModel(
              id: _integer(item['id']),
              title: item['title']?.toString() ?? '',
              description: item['description']?.toString(),
              percentage: _double(item['percentage']),
              isCompleted:
                  item['is_completed'] == true || item['is_completed'] == 1,
            ),
          ),
        );
      project.progress = _double(projectData['progress']);
      project.status = projectData['status']?.toString() ?? project.status;
      notifyListeners();
      return null;
    } catch (_) {
      return 'تعذر الاتصال بالخادم المحلي.';
    }
  }

  Future<String?> createRemoteTask(
    String token,
    ProjectModel project,
    String title,
    String? description,
    double percentage,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/tasks'),
        headers: _jsonHeaders(token),
        body: jsonEncode({
          'project_id': project.id,
          'title': title,
          'description': description,
          'percentage': percentage,
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300)
        return fetchTasks(token, project);
      return _message(response);
    } catch (_) {
      return 'تعذر الاتصال بالخادم المحلي.';
    }
  }

  Future<String?> updateRemoteTask(
    String token,
    ProjectModel project,
    TaskModel task,
    String title,
    String? description,
    double percentage,
  ) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/tasks/${task.id}'),
        headers: _jsonHeaders(token),
        body: jsonEncode({
          'title': title,
          'description': description,
          'percentage': percentage,
        }),
      );
      if (response.statusCode >= 200 && response.statusCode < 300)
        return fetchTasks(token, project);
      return _message(response);
    } catch (_) {
      return 'تعذر الاتصال بالخادم المحلي.';
    }
  }

  Future<String?> toggleRemoteTask(
    String token,
    ProjectModel project,
    TaskModel task,
  ) async {
    try {
      final response = await http.patch(
        Uri.parse('${ApiConfig.baseUrl}/tasks/${task.id}/complete'),
        headers: _headers(token),
      );
      if (response.statusCode >= 200 && response.statusCode < 300)
        return fetchTasks(token, project);
      return _message(response);
    } catch (_) {
      return 'تعذر الاتصال بالخادم المحلي.';
    }
  }

  Future<String?> deleteRemoteTask(
    String token,
    ProjectModel project,
    TaskModel task,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/tasks/${task.id}'),
        headers: _headers(token),
      );
      if (response.statusCode >= 200 && response.statusCode < 300)
        return fetchTasks(token, project);
      return _message(response);
    } catch (_) {
      return 'تعذر الاتصال بالخادم المحلي.';
    }
  }

  void addTask(ProjectModel project, TaskModel task) {
    project.tasks.add(task);
    _refreshProject(project);
    notifyListeners();
  }

  void updateTask(
    TaskModel task,
    String title,
    String? description,
    double percentage,
  ) {
    task.title = title;
    task.description = description;
    task.percentage = percentage;
    notifyListeners();
  }

  void deleteTask(ProjectModel project, TaskModel task) {
    project.tasks.remove(task);
    _refreshProject(project);
    notifyListeners();
  }

  void toggleTask(ProjectModel project, TaskModel task, bool value) {
    task.isCompleted = value;
    _refreshProject(project);
    notifyListeners();
  }

  TaskModel newTask({
    required String title,
    String? description,
    required double percentage,
  }) => TaskModel(
    id: _nextTaskId++,
    title: title,
    description: description,
    percentage: percentage,
  );
  double remainingPercentage(ProjectModel project, {TaskModel? excluding}) =>
      100 -
      project.tasks
          .where((task) => task != excluding)
          .fold<double>(0, (sum, task) => sum + task.percentage);
  void _refreshProject(ProjectModel project) {
    project.progress = project.tasks
        .where((task) => task.isCompleted)
        .fold<double>(0, (sum, task) => sum + task.percentage);
    project.status = project.progress >= 100 ? 'مكتمل' : 'نشط';
  }

  Map<String, String> _headers(String token) => {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };
  Map<String, String> _jsonHeaders(String token) => {
    ..._headers(token),
    'Content-Type': 'application/json',
  };
  Map<String, dynamic> _body(http.Response response) {
    try {
      return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
    } catch (_) {
      return {};
    }
  }

  List<Map<String, dynamic>> _data(http.Response response) {
    final data = _body(response)['data'];
    return List<Map<String, dynamic>>.from(
      (data as List? ?? []).map(
        (item) => Map<String, dynamic>.from(item as Map),
      ),
    );
  }

  String _message(http.Response response) =>
      _body(response)['message']?.toString() ?? 'تعذر تنفيذ العملية.';
  int _integer(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;
  double _double(dynamic value) =>
      double.tryParse(value?.toString() ?? '') ?? 0;
}
