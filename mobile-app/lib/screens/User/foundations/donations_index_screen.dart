import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/User/foundation_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/User/foundations/add_donation_screen.dart';
import 'package:renove_provider/screens/User/foundations/foundation_details.dart';

class DonationsIndexScreen extends StatefulWidget {
  const DonationsIndexScreen({super.key});

  @override
  State<DonationsIndexScreen> createState() => _DonationsIndexScreenState();
}

class _DonationsIndexScreenState extends State<DonationsIndexScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch campaigns on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FoundationProvider>().fetchDonationCampaigns();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("التبرعات", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(40, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: context.watch<ThemeProvider>().isDark
                    ? Colors.white30
                    : primarycolor2,
                foregroundColor: primarycolor1,
              ),
              onPressed: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => AddDonationScreen()));
              },
              child: Row(
                spacing: 5,
                children: [
                  Text('حملة تبرع', style: TextStyle(fontWeight: FontWeight.bold)),
                  Icon(Icons.add),
                ],
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: primarycolor1,
        onRefresh: () => context.read<FoundationProvider>().fetchDonationCampaigns(),
        child: SafeArea(
          child: Consumer<FoundationProvider>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return Center(child: CircularProgressIndicator(color: primarycolor1));
              }
              if (value.campaigns.isEmpty) {
                return Center(
                  child: Text(
                    "لا يوجد اي حملات",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: primarycolor1,
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(20),
                itemCount: value.campaigns.length,
                itemBuilder: (context, index) {
                  final campaign = value.campaigns[index];
                  return Card(
                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            spacing: 5,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("العنوان"),
                                  Text(
                                    campaign.title ?? '',
                                    style: TextStyle(color: primarycolor1),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("المقدار"),
                                  Text(
                                    campaign.targetAmount ?? '',
                                    style: TextStyle(color: primarycolor1),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("الموقع"),
                                  Text(
                                    campaign.location ?? '',
                                    style: TextStyle(color: primarycolor1),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(120, 50),
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
                                          builder: (context) => FoundationDetails(id: campaign.id),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "تفاصيل ",
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size(120, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      backgroundColor: context.watch<ThemeProvider>().isDark
                                          ? Colors.white30
                                          : primarycolor2,
                                      foregroundColor: primarycolor1,
                                    ),
                                    onPressed: () async {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AlertDialog(
                                            title: Text(
                                              "هل أنت متأكد من الحذف",
                                              textAlign: TextAlign.right,
                                            ),
                                            content: Text(
                                              "هل أنت متأكد أنك تريد حذف هذه الحملة؟",
                                              textAlign: TextAlign.right,
                                            ),
                                            actions: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(120, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  backgroundColor:
                                                      context.watch<ThemeProvider>().isDark
                                                      ? Colors.white30
                                                      : primarycolor2,
                                                  foregroundColor: primarycolor1,
                                                ),
                                                onPressed: () async {
                                                  final response = await value.delete(campaign.id);
                                                  if (!context.mounted) return;
                                                  final result = jsonDecode(response!.body);
                                                  final message = result['message'] ?? ['error'];
                                                  Navigator.of(context).pop();
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
                                                  if (response.statusCode == 200 ||
                                                      response.statusCode == 201) {
                                                    value.fetchDonationCampaigns();
                                                  }
                                                },
                                                child: value.isDeleting
                                                    ? CircularProgressIndicator(
                                                        color: Colors.redAccent,
                                                      )
                                                    : Text(
                                                        'حذف',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.redAccent,
                                                        ),
                                                      ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  minimumSize: Size(120, 50),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  backgroundColor:
                                                      context.watch<ThemeProvider>().isDark
                                                      ? Colors.white30
                                                      : primarycolor2,
                                                  foregroundColor: primarycolor1,
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  'إلغاء',
                                                  style: TextStyle(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Text(
                                      "حذف ",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.redAccent,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
