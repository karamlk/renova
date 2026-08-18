import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/notifications_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class NotificationsIndexUser extends StatefulWidget {
  const NotificationsIndexUser({super.key});

  @override
  State<NotificationsIndexUser> createState() => _NotificationsPageUserState();
}

class _NotificationsPageUserState extends State<NotificationsIndexUser> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationsProvider>().fetchNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await context.read<NotificationsProvider>().fetchNotifications(),
      color: primarycolor1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('الإشعارات', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: SafeArea(
          child: Consumer<NotificationsProvider>(
            builder: (context, value, child) {
              if (value.isLoadingNotifications) {
                return Center(child: CircularProgressIndicator(color: primarycolor1));
              }
              if (value.notifications.isEmpty) {
                return Center(
                  child: Text(
                    'لا يوجد أي إشعارات',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primarycolor1,
                      fontSize: 20,
                    ),
                  ),
                );
              }
              return Directionality(
                textDirection: TextDirection.rtl,
                child: ListView.builder(
                  padding: EdgeInsets.all(20),
                  itemCount: value.notifications.length,
                  itemBuilder: (context, index) {
                    final notifi = value.notifications[index];
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: Colors.white30,
                      ),
                      onPressed: () {},
                      child: SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                notifi.title,

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: primarycolor1,
                                ),
                              ),
                              Text(
                                notifi.message,
                                style: TextStyle(
                                  color: context.read<ThemeProvider>().isDark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
