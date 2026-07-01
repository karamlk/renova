import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/Contractor/contractor_data_models.dart';

class ContractorProvider extends ChangeNotifier {
  List<ContractorRequest> requests = [];
  List<ContractorPost> posts = [];
  List<ContractorSchedule> schedules = [];
  List<ContractorVisit> visits = [];
  bool isLoadingRequests = false,
      isLoadingPosts = false,
      isLoadingSchedules = false,
      isLoadingVisits = false,
      isSaving = false;
  String? errorMessage;

  Future<Map<String, String>> _headers() async => {
    'Accept': 'application/json',
    'Authorization': 'Bearer ${await getPrefs('token')}',
  };
  String imageUrl(String? path) {
    if (path == null || path.isEmpty) return '';
    if (path.startsWith('http')) return path;
    return '$link${path.startsWith('/') ? path : '/storage/$path'}';
  }

  Future<void> loadDashboard({int? contractorId}) async => Future.wait([
    fetchRequests(),
    fetchSchedules(),
    fetchVisits(),
    if (contractorId != null) fetchPosts(contractorId),
  ]);

  Future<void> fetchRequests() async {
    isLoadingRequests = true;
    errorMessage = null;
    notifyListeners();
    try {
      requests = (await _getList(
        '/api/reconstruction-requests',
        auth: true,
      )).map(ContractorRequest.fromJson).toList();
    } catch (e) {
      errorMessage = _error(e);
    } finally {
      isLoadingRequests = false;
      notifyListeners();
    }
  }

  Future<bool> requestInspection(int requestId) => _save(() async {
    final response = await http.post(
      Uri.parse('$link/api/inspection-requests'),
      headers: await _headers(),
      body: {'reconstruction_request_id': '$requestId'},
    );
    _success(response);
  });

  Future<void> fetchPosts(int contractorId) async {
    isLoadingPosts = true;
    errorMessage = null;
    notifyListeners();
    try {
      posts = (await _getList(
        '/api/contractors/$contractorId/posts',
      )).map(ContractorPost.fromJson).toList();
    } catch (e) {
      errorMessage = _error(e);
    } finally {
      isLoadingPosts = false;
      notifyListeners();
    }
  }

  Future<bool> createPost({
    required String title,
    required String description,
    required String status,
    required int progress,
    required List<XFile> images,
    required int contractorId,
  }) => _save(() async {
    final request =
        http.MultipartRequest('POST', Uri.parse('$link/api/contractor/posts'))
          ..headers.addAll(await _headers())
          ..fields.addAll({
            'title': title,
            'description': description,
            'status': status,
            'progress': '$progress',
          });
    for (final image in images) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'images[]',
          await image.readAsBytes(),
          filename: image.name,
        ),
      );
    }
    _success(await http.Response.fromStream(await request.send()));
    await fetchPosts(contractorId);
  });

  Future<bool> deletePost(int id) => _save(() async {
    _success(
      await http.delete(
        Uri.parse('$link/api/contractor/posts/$id'),
        headers: await _headers(),
      ),
    );
    posts.removeWhere((e) => e.id == id);
  });

  Future<void> fetchSchedules() async {
    isLoadingSchedules = true;
    errorMessage = null;
    notifyListeners();
    try {
      schedules = (await _getList(
        '/api/contractor/schedules',
        auth: true,
      )).map(ContractorSchedule.fromJson).toList();
    } catch (e) {
      errorMessage = _error(e);
    } finally {
      isLoadingSchedules = false;
      notifyListeners();
    }
  }

  Future<bool> saveSchedule({
    int? id,
    required String day,
    required String startTime,
    required String endTime,
  }) => _save(() async {
    final endpoint = id == null
        ? '/api/contractor/schedules'
        : '/api/contractor/schedules/update/$id';
    _success(
      await http.post(
        Uri.parse('$link$endpoint'),
        headers: await _headers(),
        body: {
          'day_of_week': day,
          'start_time': startTime,
          'end_time': endTime,
        },
      ),
    );
    await fetchSchedules();
  });

  Future<bool> deleteSchedule(int id) => _save(() async {
    _success(
      await http.delete(
        Uri.parse('$link/api/contractor/schedules/$id'),
        headers: await _headers(),
      ),
    );
    schedules.removeWhere((e) => e.id == id);
  });

  Future<void> fetchVisits() async {
    isLoadingVisits = true;
    errorMessage = null;
    notifyListeners();
    try {
      visits = (await _getList(
        '/api/contractor/visits',
        auth: true,
      )).map(ContractorVisit.fromJson).toList();
    } catch (e) {
      errorMessage = _error(e);
    } finally {
      isLoadingVisits = false;
      notifyListeners();
    }
  }

  Future<List<Map<String, dynamic>>> _getList(
    String endpoint, {
    bool auth = false,
  }) async {
    final response = await http.get(
      Uri.parse('$link$endpoint'),
      headers: auth ? await _headers() : {'Accept': 'application/json'},
    );
    _success(response);
    final decoded = jsonDecode(response.body);
    final value = decoded is Map ? decoded['data'] : decoded;
    return value is List
        ? value
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : [];
  }

  Future<bool> _save(Future<void> Function() action) async {
    isSaving = true;
    errorMessage = null;
    notifyListeners();
    try {
      await action();
      return true;
    } catch (e) {
      errorMessage = _error(e);
      return false;
    } finally {
      isSaving = false;
      notifyListeners();
    }
  }

  void _success(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) return;
    String message = 'تعذر تنفيذ العملية (${response.statusCode})';
    try {
      final body = jsonDecode(response.body);
      if (body is Map && body['message'] != null)
        message = '${body['message']}';
      if (body is Map && body['errors'] is Map)
        message = (body['errors'] as Map).values
            .expand((e) => e is List ? e : [e])
            .join('\n');
    } catch (_) {}
    throw Exception(message);
  }

  String _error(Object e) => e.toString().replaceFirst('Exception: ', '');
}
