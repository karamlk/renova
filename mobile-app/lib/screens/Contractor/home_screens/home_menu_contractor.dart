import 'package:flutter/material.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/screens/Contractor/Schedule/schedule_screen.dart';
import 'package:renove_provider/screens/Contractor/construction%20forms/forms_index.dart';
import 'package:renove_provider/screens/Contractor/home_screens/InspectionRequests/show_inspection_request.dart';

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
        padding: const EdgeInsets.all(25),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: GridView(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: Size(30, 30),

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
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      radius: 35,
                      child: Icon(Icons.calendar_month, size: 35, color: primarycolor1),
                    ),
                    Text(
                      'جدول المواعيد',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: Size(30, 30),

                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: primarycolor2,
                  foregroundColor: primarycolor1,
                ),

                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ShowInspectionRequest()),
                  );
                },
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      radius: 35,
                      child: Icon(Icons.work_history_outlined, size: 35, color: primarycolor1),
                    ),
                    Text(
                      'جدول الزيارات',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  minimumSize: Size(30, 30),

                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: primarycolor2,
                  foregroundColor: primarycolor1,
                ),

                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => ContractorIndexFormsScreen()));
                },
                child: Column(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white24,
                      radius: 35,
                      child: Icon(Icons.work_history_outlined, size: 35, color: primarycolor1),
                    ),
                    Text(
                      'الاستمارات المقدمة',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
