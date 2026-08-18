import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/User/verification/donation_model.dart';
import 'package:renove_provider/providers/User/foundation_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class AddDonationScreen extends StatefulWidget {
  const AddDonationScreen({super.key});

  @override
  State<AddDonationScreen> createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController targetAmountController = TextEditingController();
  final TextEditingController startsAtController = TextEditingController();
  final TextEditingController endsAtController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("حملة تبرع جديدة", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                spacing: 20,
                children: [
                  SizedBox(height: 10),
                  TextField(
                    controller: titleController,

                    decoration: InputDecoration(
                      alignLabelWithHint: true,

                      labelStyle: TextStyle(
                        color: context.read<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                      ),
                      labelText: "عنوان الحملة",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
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
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  TextField(
                    controller: targetAmountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      alignLabelWithHint: true,

                      labelStyle: TextStyle(
                        color: context.read<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                      ),
                      labelText: "المقدار ",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  TextField(
                    controller: locationController,

                    decoration: InputDecoration(
                      alignLabelWithHint: true,

                      labelStyle: TextStyle(
                        color: context.read<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                      ),
                      labelText: "الموقع",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                  Consumer<FoundationProvider>(
                    builder: (context, value, child) => TextField(
                      controller: value.fromDateController,
                      onTap: () => value.selectFromDate(context),

                      decoration: InputDecoration(
                        alignLabelWithHint: true,

                        labelStyle: TextStyle(
                          color: context.read<ThemeProvider>().isDark
                              ? primarycolor1
                              : primarycolor2,
                        ),
                        labelText: "تبدأ من",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                    ),
                  ),
                  Consumer<FoundationProvider>(
                    builder: (context, value, child) => TextField(
                      controller: value.toDateController,
                      onTap: () => value.selectToDate(context),

                      decoration: InputDecoration(
                        alignLabelWithHint: true,

                        labelStyle: TextStyle(
                          color: context.read<ThemeProvider>().isDark
                              ? primarycolor1
                              : primarycolor2,
                        ),
                        labelText: "تستمر لـ",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
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
                        value.pickImages();
                      },
                      child: value.selectedImages.isEmpty
                          ? Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                Text("إدراج صور", style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            )
                          : Text("${value.selectedImages.length} Images Selected"),
                    ),
                  ),

                  Consumer<FoundationProvider>(
                    builder: (context, value, child) {
                      if (value.selectedImages.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      return SizedBox(
                        height: 100,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: value.selectedImages.length,
                          separatorBuilder: (context, index) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final image = value.selectedImages[index];
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    image,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      value.removeImage(index);
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(2),
                                      decoration: const BoxDecoration(
                                        color: Colors.redAccent,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close, color: Colors.white, size: 16),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Consumer<FoundationProvider>(
        builder: (context, value, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10, left: 30, right: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: context.watch<ThemeProvider>().isDark
                      ? Colors.white30
                      : primarycolor2,
                  foregroundColor: primarycolor1,
                ),
                onPressed: () async {
                  final campaign = DonationCampaign(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                    targetAmount: targetAmountController.text.trim(),
                    startsAt: value.fromDateController.text.trim(),
                    endsAt: value.toDateController.text.trim(),
                    location: locationController.text.trim(),
                    images: value.selectedImages,
                  );
                  final response = await value.createCampaign(campaign);
                  if (!context.mounted) return;
                  if (response == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "تعذر الاتصال بالخادم، يرجى المحاولة لاحقاً",
                          textAlign: TextAlign.right,
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  final result = jsonDecode(response.body);
                  final message = result['message'];
                  final error = result['error'];
                  final messenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);
                  print(message);
                  print(error);
                  if (response.statusCode == 200 || response.statusCode == 201) {
                    navigator.pop();
                    value.clearImages();
                    value.fromDateController.clear();
                    value.toDateController.clear();

                    messenger.showSnackBar(
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
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          error,
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
                    : Text("موافق", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}
