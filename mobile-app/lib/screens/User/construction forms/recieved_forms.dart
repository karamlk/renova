import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/construction%20forms/contrsution_forms_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/User/construction%20forms/received_forms_details.dart';

class RecievedForms extends StatefulWidget {
  const RecievedForms({super.key});

  @override
  State<RecievedForms> createState() => _RecievedFormsState();
}

class _RecievedFormsState extends State<RecievedForms> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContrsutionFormsProvider>().fetchReceivedForms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: primarycolor1,
      onRefresh: () async => await context.read<ContrsutionFormsProvider>().fetchReceivedForms(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('الاستمارات', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Consumer<ContrsutionFormsProvider>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return Center(child: CircularProgressIndicator(color: primarycolor1));
              }
              if (value.recievedForms.isEmpty) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'لا يوجد أي استمارات',
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
              return ListView.builder(
                itemCount: value.recievedForms.length,
                itemBuilder: (context, index) {
                  final receive = value.recievedForms[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                receive.contactorName,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                              ),
                              Text(
                                'المتعهد:',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                receive.warrantyPeriod,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                              ),
                              Text(
                                'مدة الكفالة::',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                receive.excutionDuration,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                              ),
                              Text(
                                'مدة التنفيذ:',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                receive.totalCost,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                              ),
                              Text(
                                'الكلفة النهائية:',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: context.watch<ThemeProvider>().isDark
                                  ? Colors.white30
                                  : primarycolor2,
                              foregroundColor: primarycolor1,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ReceivedFormsDetails(receivedId: receive.id),
                                ),
                              );
                            },
                            child: Text(
                              'التفاصيل',
                              style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
