import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/Extras/theme.dart';
import 'package:renove_provider/models/Contractor/construction%20forms/forms_index.dart';
import 'package:renove_provider/providers/Contractor/construction%20forms/construction_form_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Contractor/construction%20forms/rejected_form_details.dart';

class RejectedForms extends StatefulWidget {
  const RejectedForms({super.key});

  @override
  State<RejectedForms> createState() => _RejectedFormsState();
}

class _RejectedFormsState extends State<RejectedForms> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InspectionFormProvider>().fetchRecjectedForms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الاستمارات المرفوضة', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        color: primarycolor1,
        onRefresh: () async => await context.read<InspectionFormProvider>().fetchRecjectedForms(),
        child: Consumer<InspectionFormProvider>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return Center(child: CircularProgressIndicator(color: primarycolor1));
            }

            if (value.rejected.isEmpty) {
              return Center(
                child: Text(
                  "لا يوجد استمارات مرفوضة",
                  style: TextStyle(color: primarycolor1, fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            }
            return ListView.builder(
              itemCount: value.rejected.length,
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                final reject = value.rejected[index];
                return Padding(
                  padding: EdgeInsets.all(10),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Column(
                          spacing: 5,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reject.reconstructionRequsetTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: primarycolor1,
                              ),
                            ),

                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('المهندس:'),
                                Text(reject.engineerName, style: TextStyle(color: primarycolor1)),
                              ],
                            ),
                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('المتضرر:'),
                                Text(reject.userName, style: TextStyle(color: primarycolor1)),
                              ],
                            ),

                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('كلفة المواد:'),
                                Text(reject.materialCost, style: TextStyle(color: primarycolor1)),
                              ],
                            ),

                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('الكلفة الكلية:'),
                                Text(reject.totalCost, style: TextStyle(color: primarycolor1)),
                              ],
                            ),

                            Row(
                              spacing: 10,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('الحالة:'),
                                Text(reject.status, style: TextStyle(color: primarycolor1)),
                              ],
                            ),
                            SizedBox(height: 10),
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
                                        RejectedFormDetails(rejectedForms: reject),
                                  ),
                                );
                              },
                              child: Text("تفاصيل", style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
