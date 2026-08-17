import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/wallet_provider.dart';
import 'package:renove_provider/providers/User/user_wallet_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Contractor/wallet/wallet_details.dart';
import 'package:renove_provider/screens/User/wallet/user_wallet_details_screen.dart';

class UserWalletIndexScreen extends StatefulWidget {
  const UserWalletIndexScreen({super.key});

  @override
  State<UserWalletIndexScreen> createState() => _UserWalletIndexState();
}

class _UserWalletIndexState extends State<UserWalletIndexScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserWalletProvider>().fetchWallet();
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<UserWalletProvider>().fetchWallet(),
      color: primarycolor1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('المحفظة', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Consumer<UserWalletProvider>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return const SizedBox.shrink();
            }
            if (value.wallet == null) {
              return Center(
                child: Text(
                  'فشل تحميل التفاصيل',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: primarycolor1),
                ),
              );
            }
            return SafeArea(
              child: ListView(
                key: const PageStorageKey<String>('wallet_list'),
                padding: EdgeInsets.all(25),
                children: [
                  Text("الرصيد", style: TextStyle(fontSize: 18), textAlign: TextAlign.right),
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
                      value.wallet!.balance.toString(),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.center,

                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primarycolor1,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: value.wallet!.transactions.length,
                    itemBuilder: (context, index) {
                      final trans = value.wallet!.transactions[index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Column(
                              spacing: 8,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('الكمية'),
                                    Text(trans.amount, style: TextStyle(color: primarycolor1)),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('الدفعة'),
                                    Text(trans.action, style: TextStyle(color: primarycolor1)),
                                  ],
                                ),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('من المستخدم'),
                                    Text(
                                      trans.fromUser.name,
                                      style: TextStyle(color: primarycolor1),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('إلى المستخدم'),
                                    Text(trans.toUser.name, style: TextStyle(color: primarycolor1)),
                                  ],
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
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserWalletDetailsScreen(id: trans.paymentId!.toInt()),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'التفاصيل',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: primarycolor1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
