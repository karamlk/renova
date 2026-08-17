import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/wallet_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class TransferMoney extends StatefulWidget {
  const TransferMoney({super.key});

  @override
  State<TransferMoney> createState() => _TransferMoneyState();
}

class _TransferMoneyState extends State<TransferMoney> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? engineerName;
  String? cardNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تحويل مالي', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ListView(
          padding: EdgeInsets.all(30),
          children: [
            Consumer<WalletProvider>(
              builder: (context, value, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: context.watch<ThemeProvider>().isDark
                        ? Colors.white30
                        : primarycolor2,
                    foregroundColor: primarycolor1,
                  ),
                  onPressed: () async {
                    final response = await value.fetchEngineers();
                    if (!context.mounted) return;
                    print(response?.statusCode);

                    if (response?.statusCode == 200) {
                      showModalBottomSheet(
                        context: context,

                        builder: (context) {
                          if (value.engineers.isEmpty) {
                            return Center(
                              child: Text(
                                'لا يوجد مهندسين',
                                style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
                              ),
                            );
                          }

                          return ListView.builder(
                            padding: EdgeInsets.all(30),
                            itemCount: value.engineers.length,
                            itemBuilder: (context, index) {
                              final engineer = value.engineers[index];
                              return Card(
                                child: ElevatedButton(
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
                                  onPressed: () {
                                    engineerName = engineer.engineerName;
                                    cardNumber = engineer.cardNumber;
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(15),
                                    child: Column(
                                      spacing: 5,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              engineer.engineerName,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text('اسم المهندس'),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              engineer.cardNumber,
                                              style: TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                            Text('رقم البطاقة'),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }
                  },
                  child: Text(
                    engineerName ?? 'اختر مهندس',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                );
              },
            ),
            SizedBox(height: 30),
            TextField(
              controller: amountController,
              decoration: InputDecoration(
                labelText: "الكمية",
                labelStyle: TextStyle(
                  color: context.read<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
            SizedBox(height: 30),
            TextField(
              maxLines: 3,
              controller: descriptionController,
              decoration: InputDecoration(
                alignLabelWithHint: true,
                labelText: "الوصف",
                labelStyle: TextStyle(
                  color: context.read<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Consumer<WalletProvider>(
            builder: (context, value, child) => ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: context.watch<ThemeProvider>().isDark
                    ? Colors.white30
                    : primarycolor2,
                foregroundColor: primarycolor1,
              ),
              onPressed: () async {
                final response = await value.transferMoney(
                  cardNumber.toString(),
                  amountController.text,
                  descriptionController.text,
                );
                if (!context.mounted) return;
                final result = jsonDecode(response!.body);
                final message = result['message'] ?? result['error'];
                print(result);
                if (response.statusCode == 200) {
                  Navigator.of(context).pop();
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    content: Text(
                      message,
                      style: TextStyle(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                );
              },

              child: value.isTransfer
                  ? CircularProgressIndicator(color: primarycolor1)
                  : Text("تحويل", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }
}
