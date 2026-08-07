import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/construction%20forms/contrsution_forms_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class ComplainBottomsheet extends StatefulWidget {
  ComplainBottomsheet({super.key, required this.formId});
  final reasonController = TextEditingController();
  final descriptionController = TextEditingController();
  final int formId;

  @override
  State<ComplainBottomsheet> createState() => _ComplainWorksheetState();
}

class _ComplainWorksheetState extends State<ComplainBottomsheet> {
  @override
  void dispose() {
    widget.reasonController.dispose();
    widget.descriptionController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 60,
          left: 30,
          right: 30,
          top: 30,
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: widget.reasonController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: context.watch<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                  ),
                  labelText: "سبب الشكوى",
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),

              SizedBox(height: 15),

              TextField(
                controller: widget.descriptionController,
                maxLines: 5,

                decoration: InputDecoration(
                  alignLabelWithHint: true,
                  labelText: "وصف المشكلة",
                  labelStyle: TextStyle(
                    color: context.watch<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
              SizedBox(height: 20),

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: context.watch<ThemeProvider>().isDark
                      ? Colors.white30
                      : primarycolor2,
                  foregroundColor: primarycolor1,
                ),
                onPressed: () {
                  context.read<ContrsutionFormsProvider>().pickComplaintImages();
                },
                icon: Icon(Icons.photo_library),
                label: Text("إضافة صور"),
              ),
              SizedBox(height: 20),
              Consumer<ContrsutionFormsProvider>(
                builder: (_, provider, __) => ListView.separated(
                  shrinkWrap: true,
                  itemCount: provider.complaintImages.length,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  itemBuilder: (_, index) {
                    return Container(
                      decoration: BoxDecoration(
                        color: context.watch<ThemeProvider>().isDark
                            ? Colors.white10
                            : primarycolor2,
                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        spacing: 80,
                        children: [
                          Row(
                            spacing: 20,
                            children: [
                              Icon(Icons.image),
                              Text(path.basename(provider.complaintImages[index].path)),
                            ],
                          ),

                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.redAccent),
                            onPressed: () => provider.removeComplaintImage(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: context.watch<ThemeProvider>().isDark
                      ? Colors.white30
                      : primarycolor2,
                  foregroundColor: primarycolor1,
                ),
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  final nav = Navigator.of(context);
                  final response = await context.read<ContrsutionFormsProvider>().submitComplaint(
                    constructionFormId: widget.formId,
                    reason: widget.reasonController.text,
                    description: widget.descriptionController.text,
                  );
                  if (!context.mounted) return;
                  final result = jsonDecode(response!.body);
                  print(result);
                  nav.pop();

                  messenger.showSnackBar(
                    SnackBar(content: Text(result['message'], textAlign: TextAlign.right)),
                  );
                  if (response.statusCode == 200 || response.statusCode == 201) {
                    context.read<ContrsutionFormsProvider>().clearComplaint();
                  }
                },

                child: Consumer<ContrsutionFormsProvider>(
                  builder: (context, value, child) => value.isComplaining
                      ? CircularProgressIndicator(color: primarycolor1)
                      : Text("إرسال الشكوى", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
