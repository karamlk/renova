import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true);

    print(
      "Notification permission: "
      "${settings.authorizationStatus}",
    );

    final token = await _messaging.getToken();
    await storePrefs('fcm_token', token.toString());

    Future<void> sendFcm() async {
      try {
        final token = getPrefs('token');
        final fcm = getPrefs('fcm_token');
        final response = await http.post(
          Uri.parse('$link/api/fcm-token'),
          headers: {'Accept': 'application/json', 'Authorization': 'Bearer YOUR_LOGIN_TOKEN'},
          body: {'fcm_token': fcm},
        );
        print(jsonDecode(response.body));
      } catch (e) {
        print(e);
      }
    }

    print("FCM TOKEN:");
    print(token);
  }
}
