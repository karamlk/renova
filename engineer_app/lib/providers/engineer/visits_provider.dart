import 'package:engineer_app/models/site_visit_model.dart';
import 'dart:convert';
import 'package:engineer_app/extras/api_config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// بيانات مؤقتة مطابقة لـ /api/visits و /api/site-visits/respond.
class VisitsProvider extends ChangeNotifier {
  final List<SiteVisitModel> visits = [
    SiteVisitModel(
      id: 4,
      user: 'محمد الأحمد',
      title: 'كشف أضرار مبنى سكني',
      location: 'دمشق - المزة',
      contractor: 'شركة الروضة للمقاولات',
      day: 'الأحد',
      startTime: '10:00',
      endTime: '11:00',
      status: 'بانتظار الموافقة',
    ),
    SiteVisitModel(
      id: 5,
      user: 'سارة الحسن',
      title: 'معاينة أعمال ترميم',
      location: 'ريف دمشق - جرمانا',
      contractor: 'مؤسسة النور',
      day: 'الاثنين',
      startTime: '12:00',
      endTime: '13:00',
      status: 'مقبولة',
    ),
  ];
  Future<String?> fetchVisits(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/visits'),
        headers: _headers(token),
      );
      final body = _body(response);
      if (response.statusCode < 200 || response.statusCode >= 300)
        return body['message']?.toString() ?? 'تعذر تحميل الزيارات.';
      final items = List<Map<String, dynamic>>.from(
        ((body['data'] as List?) ?? []).map(
          (item) => Map<String, dynamic>.from(item as Map),
        ),
      );
      visits
        ..clear()
        ..addAll(
          items.map(
            (item) => SiteVisitModel(
              id: _int(item['id']),
              user: item['user']?.toString() ?? '',
              title: item['title']?.toString() ?? '',
              location: item['location']?.toString() ?? '',
              contractor: item['contractor']?.toString() ?? '',
              day: item['day']?.toString() ?? '',
              startTime: item['start_time']?.toString() ?? '',
              endTime: item['end_time']?.toString() ?? '',
              status: item['status']?.toString() ?? '',
            ),
          ),
        );
      notifyListeners();
      return null;
    } catch (_) {
      return 'تعذر الاتصال بالخادم المحلي.';
    }
  }

  Future<String?> respond(
    String token,
    SiteVisitModel visit,
    bool accepted,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/site-visits/respond'),
        headers: {..._headers(token), 'Content-Type': 'application/json'},
        body: jsonEncode({
          'visit_id': visit.id,
          'status': accepted ? 'accepted' : 'rejected',
        }),
      );
      final body = _body(response);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        visit.status = accepted ? 'مقبولة' : 'مرفوضة';
        notifyListeners();
        return null;
      }
      return body['message']?.toString() ?? 'تعذر تحديث الزيارة.';
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
}
