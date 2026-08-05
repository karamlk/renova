import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/link.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/Contractor/construction%20forms/rejected_forms.dart';
import 'package:renove_provider/providers/Contractor/construction%20forms/construction_form_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class RejectedFormDetails extends StatefulWidget {
  final RejectedForms rejectedForms;
  const RejectedFormDetails({super.key, required this.rejectedForms});

  @override
  State<RejectedFormDetails> createState() => _RejectedFormDetailsState();
}

class _RejectedFormDetailsState extends State<RejectedFormDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("تفاصيل الطلب المرفوض", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),

          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("عنوان الطلب", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.reconstructionRequsetTitle,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("الوصف", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.buildingDescription,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("المهندس", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.engineerName,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("المتضرر", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.userName,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("فترة الضمان", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.warrantyPeriod,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("مدةالتنفيذ", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.excutionDuration,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("كلفة المواد", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.materialCost,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("كلفة العمالة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.laborCost,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("الأرباح", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.profit,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("التكلفة كاملة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.totalCost,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("ملاحظات المهندس", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.engineerNotes ?? "لا يوجد ملاحظات",
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("ملاحظات المتضرر", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.userNotes ?? "لا يوجد ملاحظات",
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("الحالة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  widget.rejectedForms.status,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              Text("ملفات ملحقة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              widget.rejectedForms.pdfFile == null
                  ? Container(
                      width: double.infinity,

                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: context.watch<ThemeProvider>().isDark
                            ? primarycolor2
                            : Color(0xFFe4e6f2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "لا يوجد ملحقات",
                        textDirection: TextDirection.rtl,

                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : Consumer<InspectionFormProvider>(
                      builder: (context, value, child) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: context.watch<ThemeProvider>().isDark
                              ? Colors.white30
                              : primarycolor2,
                          foregroundColor: primarycolor1,
                        ),
                        onPressed: widget.rejectedForms.pdfFile == null
                            ? null
                            : () async {
                                await value.openPdf(
                                  "$link/storage/${widget.rejectedForms.pdfFile}",
                                );
                              },
                        child: Row(
                          spacing: 10,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_download_rounded),
                            Text("اضغط لفتح الملف", style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
