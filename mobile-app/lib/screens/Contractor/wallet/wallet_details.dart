import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/Contractor/projects/projects_index.dart';
import 'package:renove_provider/providers/Contractor/project_provider.dart';
import 'package:renove_provider/providers/Contractor/wallet_provider.dart';
import 'package:renove_provider/providers/User/invoices_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class WalletDetails extends StatefulWidget {
  final int id;
  const WalletDetails({super.key, required this.id});

  @override
  State<WalletDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<WalletDetails> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WalletProvider>().fetchPaymentDetails(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تفاصيل الدفعة', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Consumer<WalletProvider>(
        builder: (context, value, child) {
          if (value.isLoading) {
            return const SizedBox.shrink();
          }
          if (value.paymentDetails == null) {
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
                Text("المقدار", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
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
                    value.paymentDetails!.amount.toString(),
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),

                SizedBox(height: 10),
                Text("تم الدفع بتاريخ", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
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
                    value.paymentDetails!.paidAt,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),

                SizedBox(height: 10),
                Text("المبلغ المحول", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
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
                    value.paymentDetails!.releasedAmount,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),

                Text(" الفاتورة", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
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
                    value.paymentDetails!.invoice!.invoiceNumber,
                    textDirection: TextDirection.rtl,

                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: value.paymentDetails!.audits.length,
                  itemBuilder: (context, index) {
                    final audit = value.paymentDetails!.audits[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "من المستخدم",
                              style: TextStyle(fontSize: 18),
                              textAlign: TextAlign.right,
                            ),
                          ],
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
                            audit.fromUser.name,
                            textDirection: TextDirection.rtl,

                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Text(
                          "إلى المستخدم",
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
                            audit.toUser.name,
                            textDirection: TextDirection.rtl,

                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
