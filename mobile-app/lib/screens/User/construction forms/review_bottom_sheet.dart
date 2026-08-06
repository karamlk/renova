import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/construction%20forms/contrsution_forms_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class ReviewFormBottomSheet extends StatefulWidget {
  const ReviewFormBottomSheet({
    super.key,
    required this.notesController,
    required this.onReview,
    required this.onVerifyOtp,
  });

  final TextEditingController notesController;

  final Future<bool> Function() onReview;

  final Future<void> Function(String otp) onVerifyOtp;

  @override
  State<ReviewFormBottomSheet> createState() => _ReviewFormBottomSheetState();
}

class _ReviewFormBottomSheetState extends State<ReviewFormBottomSheet> {
  final otpController = TextEditingController();

  bool waitingForOtp = false;

  @override
  Widget build(BuildContext context) {
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
            if (!waitingForOtp) ...[
              TextField(
                controller: widget.notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: context.watch<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                  ),
                  alignLabelWithHint: true,
                  labelText: "ملاحظات",
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),

              const SizedBox(height: 20),

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
                  final success = await widget.onReview();

                  if (success) {
                    setState(() {
                      waitingForOtp = true;
                    });
                  }
                },
                child: Consumer<ContrsutionFormsProvider>(
                  builder: (context, value, child) => value.isReviewing
                      ? CircularProgressIndicator(color: primarycolor1)
                      : Text("إرسال", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],

            if (waitingForOtp) ...[
              const Text("تم إرسال رمز التحقق إلى بريدك الإلكتروني", textAlign: TextAlign.center),

              const SizedBox(height: 15),

              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    color: context.watch<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                  ),
                  labelText: "رمز التحقق",
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),

              const SizedBox(height: 20),

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
                  await widget.onVerifyOtp(otpController.text);
                },
                child: Text("تأكيد", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
