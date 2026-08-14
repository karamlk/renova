import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/payments_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class PaymentsIndex extends StatefulWidget {
  const PaymentsIndex({super.key});

  @override
  State<PaymentsIndex> createState() => _PaymentsIndexState();
}

class _PaymentsIndexState extends State<PaymentsIndex> {
  final TextEditingController otpController = TextEditingController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PaymentProvider>().fetchPayments();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: primarycolor1,
      onRefresh: () => context.read<PaymentProvider>().fetchPayments(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('المدفوعات', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Consumer<PaymentProvider>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return Center(child: CircularProgressIndicator(color: primarycolor1));
              }
              if (value.payments.isEmpty) {
                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),

                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text(
                          'لا يوجد أي مدفوعات',
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
                itemCount: value.payments.length,
                itemBuilder: (context, index) {
                  final payment = value.payments[index];
                  return Padding(
                    padding: EdgeInsets.all(5),
                    child: Card(
                      color: context.watch<ThemeProvider>().isDark
                          ? Colors.white10
                          : Colors.grey.shade300,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  payment.amount,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                Text(
                                  'الكمية',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  payment.type,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                Text(
                                  'النوع',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  payment.paidAt ?? 'لم تدفع',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                Text(
                                  'الكمية',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  payment.releasedAmount,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                Text(
                                  'المبلغ المحول',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  value.formatDate(payment.createdAt),
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: primarycolor1,
                                  ),
                                ),
                                Text(
                                  'تم الإنشاء بتاريخ',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
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
                              onPressed: () async {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SafeArea(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 30,
                                        left: 30,
                                        right: 30,
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Center(
                                            child: CircularProgressIndicator(color: primarycolor1),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                                await context.read<PaymentProvider>().sendOtp(payment.id);
                                if (!context.mounted) return;
                                Navigator.of(context).pop();

                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,

                                  builder: (context) => SafeArea(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 30,
                                        left: 30,
                                        right: 30,
                                        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
                                      ),
                                      child: Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: Column(
                                          spacing: 30,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text('تم إرسال رمز تحقق إلى بريدك الإلتروني'),
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
                                                  borderRadius: BorderRadius.all(
                                                    Radius.circular(10),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                minimumSize: Size(double.infinity, 50),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                backgroundColor:
                                                    context.read<ThemeProvider>().isDark
                                                    ? Colors.white30
                                                    : primarycolor2,
                                                foregroundColor: primarycolor1,
                                              ),
                                              onPressed: () async {
                                                final response = await context
                                                    .read<PaymentProvider>()
                                                    .pay(payment.id, otpController.text);

                                                final message = jsonDecode(response!.body);
                                                if (!context.mounted) return;
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      message['message'],
                                                      textAlign: TextAlign.right,
                                                      textDirection: TextDirection.rtl,
                                                    ),
                                                    behavior: SnackBarBehavior.floating,
                                                  ),
                                                );
                                                print(otpController.text);

                                                Navigator.of(context).pop();
                                                otpController.clear();
                                              },
                                              child: value.isVeriying
                                                  ? CircularProgressIndicator(color: primarycolor1)
                                                  : Text(
                                                      "تأكيد",
                                                      style: TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                'دفع الفاتورة',
                                style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                              ),
                            ),
                          ],
                        ),
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
