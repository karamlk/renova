import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/Inspection/inspection_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/User/Inspection/inspection_details.dart';
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
      context.read<InspectionProvider>().fetchInspectionIndex();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<InspectionProvider>().fetchInspectionIndex(),
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
          builder: (context, value, child) {
            if (value.isLoading) {
              return InspectionIndexSkeleton();
            }
            if (value.inspectionindex.isEmpty) {
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
                itemCount: value.inspectionindex.length,
                itemBuilder: (context, index) {
                  final inspectingIndex = value.inspectionindex[index];
                  String date = inspectingIndex.requestDate;
                  DateTime parse = DateTime.parse(date).toLocal();
                  String formattedDate = DateFormat('yyyy-MM-dd').format(parse);
                  return Padding(
                    padding: const EdgeInsets.all(5),
                    child: Card(
                      color: context.watch<ThemeProvider>().isDark
                          ? primarycolor2
                          : Colors.grey.shade300,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Column(
                          spacing: 12,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  formattedDate,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      inspectingIndex.requestTitle,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: primarycolor1,
                                      ),
                                    ),
                                    Text(
                                      'طلبك: ',
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              spacing: 4,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  spacing: 4,
                                  children: [
                                    Text(
                                      inspectingIndex.contractorName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primarycolor1,
                                      ),
                                    ),
                                    Text(
                                      'المتعهد:',
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,

                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Icon(Icons.person_2_outlined),
                              ],
                            ),
                            Row(
                              spacing: 4,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  spacing: 4,
                                  children: [
                                    Text(
                                      inspectingIndex.contractorEmail,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: primarycolor1,
                                      ),
                                    ),
                                    Text(
                                      'البريد الإلكتروني:',
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,

                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                Icon(Icons.email_outlined),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(
                                      context,
                                    ).push(MaterialPageRoute(builder: (_) => InspectionDetails()));
                                  },

                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.white30,
                                    foregroundColor: Color(0xFFF59B4A),
                                  ),
                                  child: Text(
                                    'عرض التفاصيل',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Row(
                                  spacing: 4,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      spacing: 4,
                                      children: [
                                        Text(
                                          inspectingIndex.requestLocation,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: primarycolor1,
                                          ),
                                        ),
                                        Text(
                                          'الموقع:',
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Icon(Icons.location_on_outlined),
                                  ],
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
