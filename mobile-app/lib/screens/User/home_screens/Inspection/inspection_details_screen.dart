import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/User/inspections/inspection_request_model.dart';
import 'package:renove_provider/providers/User/Inspection/inspection_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class InspectionDetailsScreen extends StatefulWidget {
  final InspectionRequestModel request;
  const InspectionDetailsScreen({super.key, required this.request});

  @override
  State<InspectionDetailsScreen> createState() => _InspectionDetailsScreenState();
}

class _InspectionDetailsScreenState extends State<InspectionDetailsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InspectionProvider>().fetchInspections();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("عروض الطلب", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<InspectionProvider>().fetchInspections(),
        color: primarycolor1,
        child: Padding(
          padding: EdgeInsets.all(15),

          child: ListView.builder(
            itemCount: widget.request.offers.length,
            itemBuilder: (context, index) {
              final offer = widget.request.offers[index];
              return Card(
                color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Colors.grey.shade300,
                child: Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    spacing: 10,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            offer.contractor.name,
                            style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                          ),
                          Text(
                            'المتعهد:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            offer.contractor.email,
                            style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                          ),
                          Text(
                            'البريد الإلكتروني:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            offer.status,
                            style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                          ),
                          Text(
                            'الحالة:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        spacing: 10,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Consumer<InspectionProvider>(
                              builder: (context, value, child) => ElevatedButton(
                                onPressed: () async {
                                  await value.fetchSchedules(offer.id);

                                  if (!context.mounted) return;

                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      if (value.isLoadingSchedules) {
                                        return const Center(child: CircularProgressIndicator());
                                      }
                                      if (value.schedules.isEmpty) {
                                        return Center(
                                          child: Text(
                                            "لا يوجد أي أوقات متاحة لدى المتعهد الآن.\n يرجى تفقد هذه النافذة باستمرار",
                                            textAlign: TextAlign.center,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(color: primarycolor1, fontSize: 20),
                                          ),
                                        );
                                      }
                                      return Consumer<InspectionProvider>(
                                        builder: (context, provider, child) {
                                          return Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: ListView.builder(
                                              itemCount: provider.schedules.length,
                                              itemBuilder: (context, index) {
                                                final schedule = provider.schedules[index];

                                                return Padding(
                                                  padding: EdgeInsets.all(10),
                                                  child: Card(
                                                    color: context.watch<ThemeProvider>().isDark
                                                        ? primarycolor2
                                                        : Colors.grey.shade300,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(20),
                                                      child: Column(
                                                        spacing: 10,
                                                        children: [
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                schedule.day,
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: primarycolor1,
                                                                ),
                                                              ),
                                                              Text(
                                                                ':اليوم',
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(
                                                                "${schedule.startTime} - ${schedule.endTime}",
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                  color: primarycolor1,
                                                                ),
                                                              ),
                                                              Text(
                                                                ':الأوقات',
                                                                style: TextStyle(
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          SizedBox(height: 10),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              alignment: Alignment.center,
                                                              minimumSize: Size(
                                                                double.infinity,
                                                                50,
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(
                                                                  12,
                                                                ),
                                                              ),
                                                              backgroundColor: Colors.white30,
                                                              foregroundColor: Color(0xFFF59B4A),
                                                            ),
                                                            onPressed: () async {
                                                              final navigate = Navigator.of(
                                                                context,
                                                              );
                                                              final messenger =
                                                                  ScaffoldMessenger.of(context);
                                                              final response = await provider
                                                                  .acceptOffer(
                                                                    inspectionRequestId: offer.id,
                                                                    scheduleId: schedule.id,
                                                                  );

                                                              if (response == null) return;
                                                              print(response.body);
                                                              final result = jsonDecode(
                                                                response.body,
                                                              );
                                                              if (response.statusCode == 200 ||
                                                                  response.statusCode == 201) {
                                                                messenger.showSnackBar(
                                                                  SnackBar(
                                                                    behavior:
                                                                        SnackBarBehavior.floating,
                                                                    content: Text(
                                                                      result['message'],
                                                                      textDirection:
                                                                          TextDirection.rtl,
                                                                    ),
                                                                  ),
                                                                );
                                                              } else {
                                                                messenger.showSnackBar(
                                                                  SnackBar(
                                                                    behavior:
                                                                        SnackBarBehavior.floating,
                                                                    content: Text(
                                                                      result['message'],
                                                                      textDirection:
                                                                          TextDirection.rtl,
                                                                    ),
                                                                  ),
                                                                );
                                                              }
                                                              navigate.pop();
                                                            },

                                                            child: Text(
                                                              'قبول العرض',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                              ),
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
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  alignment: Alignment.center,
                                  minimumSize: Size(80, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.white30,
                                  foregroundColor: Color(0xFFF59B4A),
                                ),
                                child: Row(
                                  spacing: 6,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.access_time),
                                    Text(
                                      'اختيار الأوقات',
                                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final response = await context.read<InspectionProvider>().rejectOffer(
                                offer.id,
                              );

                              if (!context.mounted || response == null) return;

                              final result = jsonDecode(response.body);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    result['message'],
                                    textDirection: TextDirection.rtl,
                                  ),
                                ),
                              );

                              if (response.statusCode == 200 || response.statusCode == 201) {
                                await context.read<InspectionProvider>().fetchInspections();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(20, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.white30,
                              foregroundColor: context.watch<ThemeProvider>().isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            child: Row(
                              spacing: 6,
                              children: [
                                Icon(Icons.visibility_off),
                                Text(
                                  'تجاهل',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
