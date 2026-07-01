import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/construction_index_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/User/home_screens/requests_details.dart';
import 'package:renove_provider/skeletons/requests_index_skeleton.dart';

class RequestsIndexList extends StatefulWidget {
  const RequestsIndexList({super.key});

  @override
  State<RequestsIndexList> createState() => _RequestsIndexListState();
}

class _RequestsIndexListState extends State<RequestsIndexList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConstructionIndexProvider>().fetchRequestIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: primarycolor1,
      onRefresh: () async {
        context.read<ConstructionIndexProvider>().fetchRequestIndex();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "طلبات الإعمار",
                  style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                ),
                Divider(color: primarycolor1, height: 5),
              ],
            ),
          ),
        ),
        body: Consumer<ConstructionIndexProvider>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return RequestsIndexSkeleton();
            }
            if (value.requestsIndex.isEmpty) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),

                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        'لا يوجد أي طلبات',
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
            return Padding(
              padding: const EdgeInsets.all(15),
              child: ListView.builder(
                itemCount: value.requestsIndex.length,
                itemBuilder: (context, index) {
                  final req = value.requestsIndex[index];
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      color: context.watch<ThemeProvider>().isDark
                          ? primarycolor2
                          : Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          spacing: 8,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'عنوان الطلب: ${req.title}',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),

                            Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(req.location),
                                Icon(Icons.location_on_outlined, color: primarycolor1),
                              ],
                            ),

                            Row(
                              spacing: 14,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text("الحالة: ${req.status}", textDirection: TextDirection.rtl),
                                Icon(Icons.arrow_upward, color: primarycolor1),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RequestsDetails(id: req.id),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.white30,
                                foregroundColor: primarycolor1,
                              ),

                              child: Text(
                                "عرض التفاصيل",
                                style: TextStyle(fontWeight: FontWeight.bold),
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
