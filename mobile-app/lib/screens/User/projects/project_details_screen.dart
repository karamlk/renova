import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/project_provider.dart';
import 'package:renove_provider/providers/User/project_provider_user.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/User/projects/review_dialogue.dart';

class ProjectDetailsUserScreen extends StatefulWidget {
  final int projectId;
  const ProjectDetailsUserScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailsUserScreen> createState() => _ProjectDetailsScreenState();
}

class _ProjectDetailsScreenState extends State<ProjectDetailsUserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectProviderUser>().fetchProjectDetials(widget.projectId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل المشروع', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Consumer<ProjectProviderUser>(
            builder: (context, value, child) => value.selectedProject!.status == 'completed'
                ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(100, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        backgroundColor: context.watch<ThemeProvider>().isDark
                            ? Colors.white30
                            : primarycolor2,
                        foregroundColor: primarycolor1,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return ReviewDialog(assignmentId: widget.projectId);
                          },
                        );
                      },

                      child: Text('تقييم', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
      body: Consumer<ProjectProviderUser>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const SizedBox.shrink();
          }
          if (value.selectedProject == null) {
            return Center(
              child: Text(
                'فشل تحميل التفاصيل',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: primarycolor1),
              ),
            );
          }
          return SafeArea(
            child: ListView(
              padding: EdgeInsets.all(25),
              children: [
                Text("مقدار التقدم", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.progress.toString(),
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("الحالة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.status.toString(),
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("بدء المشروع", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.createdAt.toString(),
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("وصف البناء", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.form.buildingDescription,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("مدة الكفالة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.form.warrantyPeriod,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("مدة التنفيذ", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.form.executionDuration,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("تكلفة المواد", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.form.materialsCost,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("تكلفة العمالة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.form.laborCost,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("الأرباح", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.form.profit,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("التكلفة الكلية", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.form.totalCost,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text("ملاحظات المهندس", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.form.engineerNotes ?? "لا يوجد ملاحظات",
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "ملاحظاتي على المشروع",
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.right,
                ),
                Container(
                  width: double.infinity,

                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Color(0xFFe4e6f2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    value.selectedProject!.form.userNotes ?? "لا يوجد ملاحظات",
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
              ],
            ),
          );
        },
      ),
    );
  }
}
