import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/Contractor/contractor_schedule_model.dart';

import 'package:renove_provider/providers/Contractor/contractor_schedule_provider.dart';

class ContractorAddEditSchedule extends StatefulWidget {
  final ContractorScheduleModel? schedule;

  const ContractorAddEditSchedule({super.key, this.schedule});

  @override
  State<ContractorAddEditSchedule> createState() => _ContractorAddEditScheduleState();
}

class _ContractorAddEditScheduleState extends State<ContractorAddEditSchedule> {
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
  void initState() {
    super.initState();

    if (widget.schedule != null) {
      startController.text = widget.schedule!.startTime;
      endController.text = widget.schedule!.endTime;
      selectedDay = widget.schedule!.day;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ContractorScheduleProvider>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.schedule == null ? "إضافة موعد" : "تعديل الموعد")),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: DropdownButtonFormField<String>(
                initialValue: selectedDay,
                isExpanded: true,

                decoration: InputDecoration(
                  labelText: "اليوم",
                  labelStyle: TextStyle(color: primarycolor1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: primarycolor1, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
                ),

                items: days.map((day) {
                  return DropdownMenuItem<String>(value: day, child: Text(day));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedDay = value;
                  });
                },
              ),
            ),

            const SizedBox(height: 20),

            Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                controller: startController,
                decoration: InputDecoration(
                  labelText: "وقت البداية",
                  labelStyle: TextStyle(color: primarycolor1),
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Directionality(
              textDirection: TextDirection.rtl,
              child: TextField(
                textAlign: TextAlign.left,
                textDirection: TextDirection.ltr,
                controller: endController,
                decoration: InputDecoration(
                  labelStyle: TextStyle(color: primarycolor1),
                  labelText: "وقت النهاية",

                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.minPositive, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.white30,
                foregroundColor: primarycolor1,
              ),
              onPressed: provider.isLoading
                  ? null
                  : () async {
                      if (selectedDay == null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text("يرجى اختيار اليوم")));
                        return;
                      }
                      if (widget.schedule == null) {
                        final response = await provider.addSchedule(
                          day: selectedDay!,

                          startTime: startController.text,
                          endTime: endController.text,
                        );
                        final result = jsonDecode(response!.body);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result['message'], textDirection: TextDirection.rtl),
                          ),
                        );
                      } else {
                        final response = await provider.updateSchedule(
                          id: widget.schedule!.id,
                          day: selectedDay!,

                          startTime: startController.text,
                          endTime: endController.text,
                        );
                        final result = jsonDecode(response!.body);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(result['message'], textDirection: TextDirection.rtl),
                          ),
                        );
                      }

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    },
              child: provider.isLoading
                  ? const CircularProgressIndicator()
                  : Text(
                      widget.schedule == null ? "إضافة" : "حفظ التعديلات",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
