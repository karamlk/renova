import 'package:provider/provider.dart';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:renove_provider/Extras/theme.dart';
import 'package:renove_provider/providers/User/construction%20forms/contrsution_forms_provider.dart';
import 'package:renove_provider/providers/auth_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/User/construction%20forms/complain_bottomSheet.dart';

class ReceivedFormsDetails extends StatefulWidget {
  final int receivedId;
  const ReceivedFormsDetails({super.key, required this.receivedId});

  @override
  State<ReceivedFormsDetails> createState() => _ReceivedFormsDetailsState();
}

class _ReceivedFormsDetailsState extends State<ReceivedFormsDetails> {
  final otpController = TextEditingController();
  final notesController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContrsutionFormsProvider>().fetchRecievedDetails(widget.receivedId);
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تفاصيل الاستمارة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Consumer<ContrsutionFormsProvider>(
              builder: (context, value, child) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: context.watch<ThemeProvider>().isDark
                      ? Colors.white30
                      : primarycolor2,
                  foregroundColor: primarycolor1,
                ),

                onPressed: value.details?.status == 'user_approved'
                    ? () {
                        showModalBottomSheet(
                          useSafeArea: true,
                          isScrollControlled: true,
                          context: context,
                          builder: (_) => ComplainBottomsheet(formId: value.details!.id),
                        );
                      }
                    : null,
                child: Text('تقديم شكوى', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<ContrsutionFormsProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const SizedBox.shrink();
          }
          if (value.details == null) {
            return Center(
              child: Text(
                'فشل تحميل التفاصيل',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: primarycolor1),
              ),
            );
          }

          return ListView(
            padding: EdgeInsets.all(25),
            children: [
              Text("وصف البناء", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.buildingDescription,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),

              Text("المقاول", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.contractor.name,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text("المهندس", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.engineer.name,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text("المواد", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 40,
                  children: [
                    Column(
                      children: [
                        Text(
                          'الوحدة',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map((material) => Text(material.unit)),
                      ],
                    ),

                    Column(
                      children: [
                        Text(
                          'الكمية',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map(
                          (material) => Text(material.quantity.toString()),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'النوع',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map((material) => Text(material.materialType)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'الاسم',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map((material) => Text(material.materialName)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text("سعر الوحدة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  spacing: 40,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Column(
                      children: [
                        Text(
                          'السعر الكلي',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map(
                          (material) => Text(material.totalPrice.toString()),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          'سعر الوحدة',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map(
                          (material) => Text(material.unitPrice.toString()),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'اسم المادة ',
                          style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                        ),
                        ...value.details!.materials.map((material) => Text(material.materialName)),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text("السعر الإجمالي", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.totalCost,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,

                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 10),
              Text("عنوان الطلب", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.reconstructionRequest.title,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text("وصف الطلب", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.reconstructionRequest.description,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text("الموقع", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.reconstructionRequest.location,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 10),
              Text("النوع", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
              Container(
                width: double.infinity,

                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor2 : Color(0xFFe4e6f2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  value.details!.reconstructionRequest.type,
                  textDirection: TextDirection.rtl,

                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(height: 40),
            ],
          );
        },
      ),

      bottomNavigationBar: Consumer<ContrsutionFormsProvider>(
        builder: (context, value, child) {
          if (value.isLoading || value.details == null) {
            return const SizedBox.shrink();
          }
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(130, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: context.watch<ThemeProvider>().isDark
                          ? Colors.white30
                          : primarycolor2,
                      foregroundColor: primarycolor1,
                    ),
                    onPressed: () {
                      notesController.clear();

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                              top: 20,
                              bottom: MediaQuery.of(context).viewInsets.bottom + 60,
                            ),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "رفض الاستمارة",
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                                  ),

                                  const SizedBox(height: 20),

                                  TextField(
                                    controller: notesController,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      labelText: "سبب الرفض",
                                      alignLabelWithHint: true,
                                      labelStyle: TextStyle(
                                        color: context.watch<ThemeProvider>().isDark
                                            ? primarycolor1
                                            : primarycolor2,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Consumer<ContrsutionFormsProvider>(
                                    builder: (context, provider, child) {
                                      return SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: const Size(double.infinity, 60),
                                            backgroundColor: Colors.red,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: provider.isReviewing
                                              ? null
                                              : () async {
                                                  final response = await provider.reviewForm(
                                                    id: value.details!.id,
                                                    status: "user_rejected",
                                                    userNotes: notesController.text.trim(),
                                                  );

                                                  if (!context.mounted) return;

                                                  if (response != null &&
                                                      response.statusCode == 200) {
                                                    Navigator.pop(context);

                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(
                                                        content: Text("تم رفض الاستمارة بنجاح"),
                                                      ),
                                                    );

                                                    Navigator.pop(context);
                                                  } else {
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      SnackBar(
                                                        content: Text(response?.body ?? "حدث خطأ"),
                                                      ),
                                                    );
                                                  }
                                                },
                                          child: provider.isReviewing
                                              ? CircularProgressIndicator(color: primarycolor1)
                                              : const Text(
                                                  "تأكيد الرفض",
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Text(
                      "رفض",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.redAccent),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(130, 45),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: context.watch<ThemeProvider>().isDark
                          ? Colors.white30
                          : primarycolor2,
                      foregroundColor: primarycolor1,
                    ),
                    onPressed: () async {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,

                        builder: (context) => Padding(
                          padding: EdgeInsets.only(
                            top: 30,
                            left: 30,
                            right: 30,
                            bottom: MediaQuery.of(context).viewInsets.bottom + 60,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(child: CircularProgressIndicator(color: primarycolor1)),
                            ],
                          ),
                        ),
                      );
                      await context.read<ContrsutionFormsProvider>().fetchRecievedDetails(
                        widget.receivedId,
                      );
                      if (!context.mounted) return;
                      Navigator.of(context).pop();
                      final currentStatus = context
                          .read<ContrsutionFormsProvider>()
                          .details
                          ?.status;
                      switch (currentStatus) {
                        case "pending_user":
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,

                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: 30,
                                  left: 30,
                                  right: 30,
                                  bottom: MediaQuery.of(context).viewInsets.bottom + 80,
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Column(
                                    spacing: 20,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: notesController,
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          labelText: "ملاحظات",

                                          alignLabelWithHint: true,
                                          labelStyle: TextStyle(
                                            color: context.watch<ThemeProvider>().isDark
                                                ? primarycolor1
                                                : primarycolor2,
                                          ),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular(10)),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size(double.infinity, 60),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          backgroundColor: context.watch<ThemeProvider>().isDark
                                              ? Colors.white30
                                              : primarycolor2,
                                          foregroundColor: primarycolor1,
                                        ),
                                        onPressed: () async {
                                          final response = await context
                                              .read<ContrsutionFormsProvider>()
                                              .reviewForm(
                                                id: value.details!.id,
                                                status: "user_approved",
                                                userNotes: notesController.text,
                                              );
                                          final result = jsonDecode(response!.body);
                                          if (!context.mounted) return;
                                          if (response.statusCode == 200) {
                                            Navigator.of(context).pop();
                                            showModalBottomSheet(
                                              context: context,
                                              isScrollControlled: true,

                                              builder: (context) {
                                                return Padding(
                                                  padding: EdgeInsets.only(
                                                    top: 30,
                                                    left: 30,
                                                    right: 30,
                                                    bottom:
                                                        MediaQuery.of(context).viewInsets.bottom +
                                                        10,
                                                  ),
                                                  child: Directionality(
                                                    textDirection: TextDirection.rtl,
                                                    child: SafeArea(
                                                      child: Column(
                                                        spacing: 20,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          TextField(
                                                            controller: otpController,
                                                            decoration: InputDecoration(
                                                              labelText: "رمز التحقق",

                                                              alignLabelWithHint: true,
                                                              labelStyle: TextStyle(
                                                                color:
                                                                    context
                                                                        .watch<ThemeProvider>()
                                                                        .isDark
                                                                    ? primarycolor1
                                                                    : primarycolor2,
                                                              ),
                                                              border: const OutlineInputBorder(
                                                                borderRadius: BorderRadius.all(
                                                                  Radius.circular(10),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                              minimumSize: Size(
                                                                double.infinity,
                                                                50,
                                                              ),
                                                              shape: RoundedRectangleBorder(
                                                                borderRadius: BorderRadius.circular(
                                                                  12,
                                                                ),
                                                              ),
                                                              backgroundColor:
                                                                  context
                                                                      .watch<ThemeProvider>()
                                                                      .isDark
                                                                  ? Colors.white30
                                                                  : primarycolor2,
                                                              foregroundColor: primarycolor1,
                                                            ),
                                                            onPressed: () async {
                                                              final response = await context
                                                                  .read<ContrsutionFormsProvider>()
                                                                  .verifyReviewOtp(
                                                                    id: value.details!.id,
                                                                    otp: otpController.text,
                                                                  );
                                                              if (!context.mounted) return;
                                                              final result = jsonDecode(
                                                                response!.body,
                                                              );
                                                              Navigator.of(context).pop();
                                                              ScaffoldMessenger.of(
                                                                context,
                                                              ).showSnackBar(
                                                                SnackBar(
                                                                  content: Text(
                                                                    result['message'] ??
                                                                        result['error'],
                                                                    textAlign: TextAlign.right,
                                                                    textDirection:
                                                                        TextDirection.rtl,
                                                                  ),
                                                                ),
                                                              );
                                                              notesController.clear();
                                                              otpController.clear();
                                                              Navigator.of(context).pop();
                                                            },
                                                            child: Text(
                                                              'تأكيد',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          } else {
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  result['message'] ?? result['error'],
                                                  textAlign: TextAlign.right,
                                                  textDirection: TextDirection.rtl,
                                                ),
                                              ),
                                            );
                                            notesController.clear();
                                          }
                                        },
                                        child: Consumer<ContrsutionFormsProvider>(
                                          builder: (context, value, child) => value.isReviewing
                                              ? CircularProgressIndicator(color: primarycolor1)
                                              : Text(
                                                  'إرسال',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );

                        case 'waiting_payment_otp':
                          context.read<AuthProvider>().resendOtpInApp(
                            value.details!.reconstructionRequest.email,
                          );

                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,

                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  top: 30,
                                  left: 30,
                                  right: 30,
                                  bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: SafeArea(
                                    child: Column(
                                      spacing: 20,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: otpController,
                                          decoration: InputDecoration(
                                            labelText: "رمز التحقق",

                                            alignLabelWithHint: true,
                                            labelStyle: TextStyle(
                                              color: context.watch<ThemeProvider>().isDark
                                                  ? primarycolor1
                                                  : primarycolor2,
                                            ),
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(10)),
                                            ),
                                          ),
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
                                          onPressed: () async {
                                            final response = await context
                                                .read<ContrsutionFormsProvider>()
                                                .verifyReviewOtp(
                                                  id: value.details!.id,
                                                  otp: otpController.text,
                                                );
                                            if (!context.mounted) return;
                                            final result = jsonDecode(response!.body);
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  result['message'] ?? result['error'],
                                                  textAlign: TextAlign.right,
                                                  textDirection: TextDirection.rtl,
                                                ),
                                              ),
                                            );
                                            notesController.clear();
                                            otpController.clear();
                                          },
                                          child: Text(
                                            'تأكيد',
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                      }
                    },

                    child: Text("قبول", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
