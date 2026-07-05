import 'package:flutter/material.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/screens/Contractor/Schedule/schedule_screen.dart';

class HomwMenuContractor extends StatefulWidget {
  const HomwMenuContractor({super.key});

  @override
  State<HomwMenuContractor> createState() => _HomwMenuContractorState();
}

class _HomwMenuContractorState extends State<HomwMenuContractor> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'قائمتي',
                style: TextStyle(fontWeight: FontWeight.bold, color: primarycolor1),
              ),
              Divider(color: primarycolor1, height: 5),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                minimumSize: Size(double.infinity, 60),

                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: primarycolor2,
                foregroundColor: primarycolor1,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ContractorScheduleScreen()),
                );
              },
              child: Row(
                spacing: 10,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'جدول المواعيد',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  Icon(Icons.calendar_month),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
