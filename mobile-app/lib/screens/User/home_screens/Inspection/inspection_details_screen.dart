import 'dart:convert';

import 'package:flutter/material.dart';
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
                            child: ElevatedButton(
                              onPressed: () async {
                                final response = await context
                                    .read<InspectionProvider>()
                                    .acceptOffer(offer.id);

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
                                  Icon(Icons.check_circle),
                                  Text(
                                    'قبول العرض',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
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
