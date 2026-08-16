import 'dart:convert';

import 'package:engineer_app/extras/api_config.dart';
import 'package:engineer_app/models/no_show_warning_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class NoShowWarningsProvider extends ChangeNotifier {
  NoShowWarningModel? lastCreatedWarning;
  String? lastMessage;

  Future<String?> report(
    String token, {
    required int siteVisitId,
    required String reportedRole,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/no-show-warnings'),
        headers: {..._headers(token), 'Content-Type': 'application/json'},
        body: jsonEncode({
          'site_visit_id': siteVisitId,
          'reported_role': reportedRole,
        }),
      );
      final body = _body(response);
      if (!_isSuccess(response)) return _message(body);
      lastMessage = body['message']?.toString();
      final data = body['data'];
      if (data is Map) {
        lastCreatedWarning = NoShowWarningModel.fromJson(
          Map<String, dynamic>.from(data),
        );
      }
      notifyListeners();
      return null;
    } catch (_) {
      return 'تعذر الاتصال بالخادم المحلي.';
    }
  }

  Map<String, String> _headers(String token) => {
    'Accept': 'application/json',
    'Authorization': 'Bearer $token',
  };

  Map<String, dynamic> _body(http.Response response) {
    try {
      return Map<String, dynamic>.from(jsonDecode(response.body) as Map);
    } catch (_) {
      return {};
    }
  }

  bool _isSuccess(http.Response response) =>
      response.statusCode >= 200 && response.statusCode < 300;

  String _message(Map<String, dynamic> body) =>
      body['message']?.toString() ??
      body['error']?.toString() ??
      'تعذر تنفيذ العملية.';
}
