import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/User/verification/verify_model.dart';
import 'package:renove_provider/providers/User/foundation_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final TextEditingController foundationNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController registerationNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("توثيق الحساب", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              spacing: 30,
              children: [
                SizedBox(height: 10),
                TextField(
                  controller: foundationNameController,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: context.read<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                    ),
                    labelText: "اسم الجمعية",
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),

                TextField(
                  controller: registerationNumberController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: context.read<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                    ),
                    labelText: "رقم الجمعية",

                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,

                    labelStyle: TextStyle(
                      color: context.read<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                    ),
                    labelText: "الوصف",
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                Consumer<FoundationProvider>(
                  builder: (context, value, child) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: context.watch<ThemeProvider>().isDark
                          ? Colors.white30
                          : primarycolor2,
                      foregroundColor: primarycolor1,
                    ),
                    onPressed: () async {
                      value.pickFiles();
                    },
                    child: value.selectedFiles.isEmpty
                        ? Row(
                            spacing: 5,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add),
                              Text("إدراج ملحقات", style: TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          )
                        : Text("${value.selectedFiles.length} Documents Selected"),
                  ),
                ),
                Consumer<FoundationProvider>(
                  builder: (context, value, child) => ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.selectedFiles.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    value.selectedFiles[index].path
                                        .split(Platform.pathSeparator)
                                        .last,

                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    value.removeFile(index);
                                  },
                                  icon: Icon(Icons.close, color: Colors.redAccent),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
          child: Consumer<FoundationProvider>(
            builder: (context, value, child) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: context.watch<ThemeProvider>().isDark
                    ? Colors.white30
                    : primarycolor2,
                foregroundColor: primarycolor1,
              ),
              onPressed: () async {
                final verifyData = Verify(
                  foundationName: foundationNameController.text.trim(),
                  registrationNumber: registerationNumberController.text.trim(),
                  description: descriptionController.text.trim(),
                  documents: value.selectedFiles,
                );
                final response = await value.verifyFoundation(verify: verifyData);
                final result = jsonDecode(response!.body);
                final message = result['message'] ?? result['error'];

                if (!context.mounted) return;
                if (response.statusCode == 200 || response.statusCode == 422) {
                  Navigator.of(context).pop();
                  value.clearFiles();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        message,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                } else {
                  print(response.statusCode);
                  print(jsonDecode(response.body));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        message,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },

              child: value.isLoading
                  ? CircularProgressIndicator(color: primarycolor1)
                  : Text('موافق', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
