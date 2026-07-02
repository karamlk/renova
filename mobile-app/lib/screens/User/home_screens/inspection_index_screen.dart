import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/Inspection/inspection_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/User/home_screens/Inspection/inspection_details_screen.dart';
import 'package:renove_provider/skeletons/inspection_index_skeleton.dart';

class InspectionIndexScreen extends StatefulWidget {
  const InspectionIndexScreen({super.key});

  @override
  State<InspectionIndexScreen> createState() => _InspectionIndexScreenState();
}

class _InspectionIndexScreenState extends State<InspectionIndexScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InspectionProvider>().fetchInspections();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<InspectionProvider>().fetchInspections(),
      color: primarycolor1,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "العروض",
                    style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                  ),
                ),
                Divider(color: primarycolor1, height: 5),
              ],
            ),
          ),
        ),
        body: Consumer<InspectionProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return InspectionIndexSkeleton();
            }
            if (provider.requests.isEmpty) {
              return CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'لا يوجد عروض لك',

                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
                      ),
                    ),
                  ),
                ],
              );
            }
            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: provider.requests.length,
                itemBuilder: (context, index) {
                  final request = provider.requests[index];
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      color: context.watch<ThemeProvider>().isDark
                          ? primarycolor2
                          : Colors.grey.shade300,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  request.title,
                                  style: TextStyle(
                                    color: primarycolor1,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'الطلب:',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  request.location,
                                  style: TextStyle(
                                    color: primarycolor1,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'الموقع:',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  request.status,
                                  style: TextStyle(
                                    color: primarycolor1,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'الحالة:',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => InspectionDetailsScreen(request: request),
                                  ),
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.white30,
                                foregroundColor: Color(0xFFF59B4A),
                              ),
                              child: Text(
                                'عرض التفاصيل',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
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
    );
  }
}
