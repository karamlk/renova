import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/Contractor/contractor_schedule_model.dart';
import 'package:renove_provider/providers/Contractor/contractor_schedule_provider.dart';

class EditSchedule extends StatefulWidget {
  // Pass the existing schedule map data or a custom model instance
  final ContractorScheduleModel schedule;

  const EditSchedule({super.key, required this.schedule});

  @override
  State<EditSchedule> createState() => _EditScheduleState();
}

class _EditScheduleState extends State<EditSchedule> {
  late final TextEditingController startController;
  late final TextEditingController endController;
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
  void initState() {
    super.initState();

    // 1. Prefill values directly from the widget's constructor data
    startController = TextEditingController(text: widget.schedule.startTime);
    endController = TextEditingController(text: widget.schedule.endTime);

    // Normalize string casing to ensure it matches your lowercase list array keys perfectly

    selectedDay = widget.schedule.day.toLowerCase();
  }

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
        title: const Text('تعديل الموعد', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButtonFormField<String>(
                value: days.contains(selectedDay) ? selectedDay : null,
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
            const SizedBox(height: 25),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                readOnly: true,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialEntryMode: TimePickerEntryMode.input,
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
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                readOnly: true,
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialEntryMode: TimePickerEntryMode.input,
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
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Consumer<ContractorScheduleProvider>(
              builder: (context, value, child) => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: primarycolor2,
                  foregroundColor: primarycolor1,
                ),
                onPressed: value.isLoading
                    ? null
                    : () async {
                        if (selectedDay == null ||
                            startController.text.isEmpty ||
                            endController.text.isEmpty) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(const SnackBar(content: Text('يرجى ملء جميع الحقول')));
                          return;
                        }

                        final response = await value.updateSchedule(
                          id: widget.schedule.id,
                          day: selectedDay!,
                          startTime: startController.text,
                          endTime: endController.text,
                        );

                        if (response != null) {
                          final result = jsonDecode(response.body);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  result['message'] ?? 'تم التعديل بنجاح',
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        }
                      },
                child: value.isLoading
                    ? CircularProgressIndicator(color: primarycolor1)
                    : const Text("حفظ التعديلات", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
