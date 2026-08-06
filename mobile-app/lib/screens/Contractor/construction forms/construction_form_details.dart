import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/construction%20forms/construction_form_provider.dart';

import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Contractor/construction%20forms/update_form_screen.dart';

class ConstructionFormDetailsScreen extends StatefulWidget {
  final int formId;

  const ConstructionFormDetailsScreen({super.key, required this.formId});

  @override
  State<ConstructionFormDetailsScreen> createState() => _ConstructionFormDetailsScreenState();
}

class _ConstructionFormDetailsScreenState extends State<ConstructionFormDetailsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InspectionFormProvider>().fetchFormDetails(widget.formId);
    });
  }

  Widget field(BuildContext context, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Card(
        color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Colors.grey.shade300,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
              ),
              const SizedBox(height: 8),
              Text(value, textDirection: TextDirection.rtl),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("تفاصيل الاستمارة", style: TextStyle(fontWeight: FontWeight.bold)),

        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.minPositive, 100),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Color(0xFF3b414c),
                foregroundColor: Color(0xFFF59B4A),
                disabledBackgroundColor: Color(0xFF3b414c),
              ),
              onPressed: () {
                final form = context.read<InspectionFormProvider>().formDetails!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UpdateFormScreen(id: form.id, form: form),
                  ),
                );
              },
              child: Text('تعديل', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => context.read<InspectionFormProvider>().fetchFormDetails(widget.formId),
        color: primarycolor1,
        child: Consumer<InspectionFormProvider>(
          builder: (context, provider, child) {
            if (provider.isDetailsLoading) {
              return Center(child: CircularProgressIndicator(color: primarycolor1));
            }

            if (provider.formDetails == null) {
              return const Center(child: Text("لا توجد بيانات"));
            }

            final form = provider.formDetails!;

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  padding: const EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 50),
                  children: [
                    Text(
                      "عنوان الطلب",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.reconstructionRequest.title,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),

                    Text(
                      "وصف الطلب",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.reconstructionRequest.title,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                    Text(
                      "الوصف",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,
                        height: 100,
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(form.buildingDescription, textDirection: TextDirection.rtl),
                      ),
                    ),
                    Text(
                      "مدة التنفيذ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.executionDuration,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    Text(
                      "مدة الضمان",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.warrantyPeriod,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    Text(
                      "تكلفة المواد",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.materialsCost,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    Text(
                      "تكلفة العمال",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.laborCost,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    Text(
                      "الربح",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.profit,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    Text(
                      "الإجمالي",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.totalCost,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    Text(
                      "المهندس",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.engineer.name,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    Text(
                      "المقاول",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.contractor!.name,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    Text(
                      "ملاحظات المهندس",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.engineerNotes ?? "لا يوجد",
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                    Text(
                      "ملاحظات المستخدم",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.userNotes ?? "لا يوجد",
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                        ),
                      ),
                    ),
                    Text(
                      "الحالة",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 16,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.status,
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.ltr,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    Divider(height: 10, color: primarycolor1),
                    SizedBox(height: 20),
                    Text(
                      'المواد',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 20),

                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          spacing: 40,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الاسم',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                ...form.materials.map((material) {
                                  return Text(material.materialName);
                                }),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'النوع',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                ...form.materials.map((material) {
                                  return Text(material.materialType);
                                }),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الكمية',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                ...form.materials.map((material) {
                                  return Text(material.quantity.toString());
                                }),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'الوحدة',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                ...form.materials.map((material) {
                                  return Text(material.unit);
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'سعر الوحدة',
                      style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          spacing: 40,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'اسم المادة',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                ...form.materials.map((material) {
                                  return Text(material.materialName);
                                }),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'سعر الوحدة',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                ...form.materials.map((material) {
                                  return Text(material.unitPrice.toString());
                                }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'السعر الكلي',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                        fontSize: 18,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,

                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: context.watch<ThemeProvider>().isDark
                              ? primarycolor2
                              : Color(0xFFe4e6f2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          form.totalCost,
                          textAlign: TextAlign.center,
                          textDirection: TextDirection.ltr,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
