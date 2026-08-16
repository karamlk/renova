import 'package:engineer_app/models/engineer_form_model.dart';
import 'package:engineer_app/models/engineer_form_details_model.dart';
import 'dart:convert';
import 'package:engineer_app/extras/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// بيانات مؤقتة مطابقة لـ /api/forms?status=pending_engineer.
class FormsProvider extends ChangeNotifier {
  final List<EngineerFormModel> forms = [
    EngineerFormModel(
      id: 7,
      beneficiary: 'محمد الأحمد',
      contractor: 'شركة الروضة للمقاولات',
      totalCost: 28500000,
      status: 'بانتظار المراجعة',
      createdAt: '2026-07-30',
    ),
    EngineerFormModel(
      id: 8,
      beneficiary: 'سارة الحسن',
      contractor: 'مؤسسة النور',
      totalCost: 18000000,
      status: 'بانتظار المراجعة',
      createdAt: '2026-07-29',
    ),
  ];

  String? detailsError;

  Future<EngineerFormDetailsModel?> fetchDetails(
    String token,
    int formId,
  ) async {
    detailsError = null;
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/forms/$formId'),
        headers: _headers(token),
      );
      final body = _body(response);
      if (response.statusCode < 200 || response.statusCode >= 300) {
        detailsError = body['message']?.toString() ??
            'تعذر تحميل تفاصيل الاستمارة.';
        return null;
      }

      final data = body['data'];
      if (data is! Map) {
        detailsError = 'استجابة تفاصيل الاستمارة غير صالحة.';
        return null;
      }
      return EngineerFormDetailsModel.fromJson(
        Map<String, dynamic>.from(data),
      );
    } catch (_) {
      detailsError = 'تعذر الاتصال بالخادم المحلي.';
      return null;
    }
  }

  Future<String?> fetchForms(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/forms?status=pending_engineer'),
        headers: _headers(token),
      );
      final body = _body(response);
      if (response.statusCode < 200 || response.statusCode >= 300)
        return body['message']?.toString() ?? 'تعذر تحميل الاستمارات.';
      final items = List<Map<String, dynamic>>.from(
        ((body['data'] as List?) ?? []).map(
          (item) => Map<String, dynamic>.from(item as Map),
        ),
      );
      forms
        ..clear()
        ..addAll(
          items.map(
            (item) => EngineerFormModel(
              id: _int(item['id']),
              beneficiary: item['beneficiary']?.toString() ?? '',
              contractor: item['contractor']?.toString() ?? '',
              totalCost: _number(item['total_cost']),
              status: item['status']?.toString() ?? '',
              createdAt: item['created_at']?.toString() ?? '',
            ),
          ),
        );
      notifyListeners();
      return null;
    } catch (_) {
      return 'تعذر الاتصال بالخادم المحلي.';
    }
  }

  Future<String?> review(
    String token,
    EngineerFormModel form,
    bool approved, {
    String? notes,
  }) async {
    try {
      final response = await http.put(
        Uri.parse(
          '${ApiConfig.baseUrl}/construction-forms/${form.id}/engineer-review',
        ),
        headers: {..._headers(token), 'Content-Type': 'application/json'},
        body: jsonEncode({
          'status': approved ? 'engineer_approved' : 'engineer_rejected',
          'engineer_notes': notes,
        }),
      );
      final body = _body(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        forms.remove(form);
        notifyListeners();
        return null;
      }
      return body['message']?.toString() ??
          body['error']?.toString() ??
          'تعذر تدقيق الاستمارة.';
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

  int _int(dynamic value) => int.tryParse(value?.toString() ?? '') ?? 0;
  double _number(dynamic value) =>
      double.tryParse(value?.toString() ?? '') ?? 0;
}
