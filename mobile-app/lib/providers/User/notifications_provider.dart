import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/models/User/notifications/notifications_index.dart';

class NotificationsProvider extends ChangeNotifier {
  List<NotificationItem> notifications = [];
  bool isLoadingNotifications = false;

  Future<http.Response?> fetchNotifications() async {
    isLoadingNotifications = true;
    notifyListeners();

    try {
      final token = await getPrefs("token");
      final uri = Uri.parse("$link/api/notifications"); // Update endpoint if needed

      final response = await http.get(
        uri,
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        notifications = jsonList
            .map((item) => NotificationItem.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return response;
    } catch (e) {
      debugPrint("Error fetching notifications: $e");
      return null;
    } finally {
      isLoadingNotifications = false;
      notifyListeners();
    }
  }
}
