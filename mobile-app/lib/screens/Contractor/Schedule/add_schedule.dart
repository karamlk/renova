import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/contractor_schedule_provider.dart';

class AddSchedule extends StatefulWidget {
  const AddSchedule({super.key});

  @override
  State<AddSchedule> createState() => _AddScheduleState();
}

class _AddScheduleState extends State<AddSchedule> {
  final startController = TextEditingController();
  final endController = TextEditingController();

  String? selectedDay;

  final List<String> days = [
    "monday",
    "tuesday",
    "wednesday",
    "thursday",
    "friday",
    "saturday",
    "sunday",
  ];
  @override
  void dispose() {
    startController.dispose();
    endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('إضافة موعد جديد', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(30),
        child: ListView(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButtonFormField<String>(
                initialValue: selectedDay,
                isExpanded: true,
                alignment: Alignment.centerLeft,

                decoration: InputDecoration(
                  labelText: 'اليوم',
                  labelStyle: TextStyle(color: primarycolor1),

                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                items: days.map((day) {
                  return DropdownMenuItem(value: day, child: Text(day));
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedDay = value;
                    });
                  }
                },
              ),
            ),
            SizedBox(height: 25),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                readOnly: true,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,

                    builder: (BuildContext context, Widget? child) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                backgroundColor: primarycolor2,
                                foregroundColor: primarycolor1,

                                elevation: 2,

                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          child: child!,
                        ),
                      );
                    },
                    initialTime: TimeOfDay.now(),
                    barrierDismissible: false,
                    confirmText: 'تم',
                    cancelText: "إلغاء",
                  );

                  if (time != null) {
                    final String period = time.period == DayPeriod.am ? 'AM' : 'PM';

                    int hour12 = time.hourOfPeriod;
                    if (hour12 == 0) hour12 = 12;

                    final String formattedHour = hour12.toString().padLeft(2, '0');
                    final String formattedMinute = time.minute.toString().padLeft(2, '0');

                    startController.text = '$formattedHour:$formattedMinute $period';
                  }
                },
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                controller: startController,
                cursorColor: primarycolor1,
                decoration: InputDecoration(
                  labelText: "وقت البداية",
                  labelStyle: TextStyle(color: primarycolor1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            SizedBox(height: 25),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                readOnly: true,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,

                    builder: (BuildContext context, Widget? child) {
                      return Directionality(
                        textDirection: TextDirection.rtl,
                        child: Theme(
                          data: Theme.of(context).copyWith(
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                backgroundColor: primarycolor2,
                                foregroundColor: primarycolor1,

                                elevation: 2,

                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),

                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          child: child!,
                        ),
                      );
                    },
                    initialTime: TimeOfDay.now(),
                    barrierDismissible: false,
                    confirmText: 'تم',
                    cancelText: "إلغاء",
                  );

                  if (time != null) {
                    final String period = time.period == DayPeriod.am ? 'AM' : 'PM';

                    int hour12 = time.hourOfPeriod;
                    if (hour12 == 0) hour12 = 12;

                    final String formattedHour = hour12.toString().padLeft(2, '0');
                    final String formattedMinute = time.minute.toString().padLeft(2, '0');

                    endController.text = '$formattedHour:$formattedMinute $period';
                  }
                },
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                controller: endController,
                cursorColor: primarycolor1,
                decoration: InputDecoration(
                  labelText: "وقت النهاية",
                  labelStyle: TextStyle(color: primarycolor1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),
            SizedBox(height: 30),

            Consumer<ContractorScheduleProvider>(
              builder: (context, value, child) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: primarycolor2,
                  foregroundColor: primarycolor1,
                ),
                onPressed: () async {
                  if (selectedDay == null ||
                      startController.text.isEmpty ||
                      endController.text.isEmpty) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(const SnackBar(content: Text('يرجى ملء جميع الحقول')));
                    return;
                  }
                  final response = await value.addSchedule(
                    day: selectedDay!,
                    startTime: startController.text,
                    endTime: endController.text,
                  );
                  final result = jsonDecode(response!.body);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(result['message'], textDirection: TextDirection.rtl)),
                  );
                  if (!context.mounted) return;

                  Navigator.pop(context);
                },
                child: value.isLoading
                    ? CircularProgressIndicator(color: primarycolor1)
                    : Text("إضافة", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
