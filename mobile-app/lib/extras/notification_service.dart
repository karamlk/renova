import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    final settings = await _messaging.requestPermission(alert: true, badge: true, sound: true);

    print(
      "Notification permission: "
      "${settings.authorizationStatus}",
    );
    final token = await _messaging.getToken();

    print("FCM TOKEN:");
    print(token);
  }
}
