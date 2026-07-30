import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/shared_preferneces.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/user_requests_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Auth/login_screen.dart';
import 'package:renove_provider/screens/Contractor/home_screens/UserRequestsDetails/filter_buttom_sheet.dart';
import 'package:renove_provider/screens/Contractor/home_screens/UserRequestsDetails/user_requests_details.dart';

class UserRequestsIndex extends StatefulWidget {
  const UserRequestsIndex({super.key});

  @override
  State<UserRequestsIndex> createState() => _UserRequestsIndexState();
}

class _UserRequestsIndexState extends State<UserRequestsIndex> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final response = await context.read<ContractorRequestsProvider>().fetchRequests();
      if (!mounted) return;
      if (response!.statusCode == 401) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("انتهت صلاحية جلستك"),
            content: Text("سيتم تسجيل الخروج. اضغط موافق لإعادة تسجيل الدخول"),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.white30,
                  foregroundColor: primarycolor1,
                ),
                onPressed: () async {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                    (Route<dynamic> route) => false,
                  );
                  await clearTPrefs('token');
                },
                child: Text("موافق"),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: primarycolor1,
      onRefresh: () async {
        await context.read<ContractorRequestsProvider>().fetchRequests();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "طلبات المستخدمين",
                    style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                  ),
                ),
                Divider(color: primarycolor1, height: 5),
              ],
            ),
          ),

          leading: IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: primarycolor2),

            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => SafeArea(child: FilterButtomSheet()),
              );
            },
            icon: Icon(Icons.filter_alt_outlined),
          ),
        ),
        body: Consumer<ContractorRequestsProvider>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return Center(child: CircularProgressIndicator(color: primarycolor1));
            }
            if (value.requests.isEmpty) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'لا يوجد أي طلبات من المسخدمين',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: primarycolor1,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                final response = await value.fetchRequests();
                if (!mounted) return;
                if (response!.statusCode == 401) {
                  showDialog(
                    animationStyle: AnimationStyle(curve: Curves.bounceOut),
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("انتهت صلاحية جلستك"),
                      content: Text("سيتم تسجيل الخروج. اضغط موافق لإعادة تسجيل الدخول"),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            backgroundColor: Colors.white30,
                            foregroundColor: primarycolor1,
                          ),
                          onPressed: () async {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                              (Route<dynamic> route) => false,
                            );
                            await clearTPrefs('token');
                          },
                          child: Text("موافق"),
                        ),
                      ],
                    ),
                  );
                }
              },
              color: primarycolor1,
              child: ListView.builder(
                itemCount: value.requests.length,
                itemBuilder: (context, index) {
                  final request = value.requests[index];
                  return Padding(
                    padding: EdgeInsets.all(10),
                    child: Card(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  request.title,
                                  style: TextStyle(
                                    color: primarycolor1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "العنوان:",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  request.description,
                                  style: TextStyle(
                                    color: primarycolor1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "الوصف:",
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  request.location,
                                  style: TextStyle(
                                    color: primarycolor1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  spacing: 5,
                                  children: [
                                    Text(
                                      "الموقع:",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.location_on, color: primarycolor1),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  request.user.name,
                                  style: TextStyle(
                                    color: primarycolor1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  spacing: 5,
                                  children: [
                                    Text(
                                      "المستخدم:",
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    Icon(Icons.location_on, color: primarycolor1),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    final response = await context
                                        .read<ContractorRequestsProvider>()
                                        .makeOffer(request.id);

                                    if (!context.mounted || response == null) return;

                                    final result = jsonDecode(response.body);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          result['message'],
                                          textDirection: TextDirection.rtl,
                                        ),
                                      ),
                                    );
                                  },

                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(170, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: context.watch<ThemeProvider>().isDark
                                        ? Colors.white30
                                        : primarycolor2,
                                    foregroundColor: primarycolor1,
                                  ),
                                  child: Text(
                                    "تقديم عرض",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => UserRequestsDetails(request: request),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(80, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: context.watch<ThemeProvider>().isDark
                                        ? Colors.white30
                                        : primarycolor2,
                                    foregroundColor: primarycolor1,
                                  ),

                                  child: Text(
                                    "عرض التفاصيل",
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
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
    );
  }
}
