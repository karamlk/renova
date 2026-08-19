import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/notifications_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class NotificationDetailsRead extends StatefulWidget {
  final int id;
  const NotificationDetailsRead({super.key, required this.id});

  @override
  State<NotificationDetailsRead> createState() => _NotificationDetailsReadState();
}

class _NotificationDetailsReadState extends State<NotificationDetailsRead> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsProvider>().fetchNotificationDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الاشعار", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Consumer<NotificationsProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return Center(child: CircularProgressIndicator(color: primarycolor1));
          }

          if (value.notification == null) {
            return const Center(
              child: Text("لم يتم تحميل بيانات الإشعار", textDirection: TextDirection.rtl),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: ListView(
              children: [
                Text("العنوان", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.notification!.title,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("الرسالة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.notification!.message,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),

                Text("التاريخ", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.notification!.createdAt.toString(),
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
