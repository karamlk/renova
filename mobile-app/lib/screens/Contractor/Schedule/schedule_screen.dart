import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/contractor_schedule_provider.dart';
import 'package:renove_provider/screens/Contractor/Schedule/add_edit_schedule.dart';
import 'package:renove_provider/screens/Contractor/Schedule/add_schedule.dart';
import 'package:renove_provider/screens/Contractor/Schedule/edit_schedule.dart';

class ContractorScheduleScreen extends StatefulWidget {
  const ContractorScheduleScreen({super.key});

  @override
  State<ContractorScheduleScreen> createState() => _ContractorScheduleScreenState();
}

class _ContractorScheduleScreenState extends State<ContractorScheduleScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContractorScheduleProvider>().fetchSchedules();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("جدول الدوام", style: TextStyle(fontWeight: FontWeight.bold)),

        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (_) => AddSchedule()));

              context.read<ContractorScheduleProvider>().fetchSchedules();
            },
          ),
        ],
      ),

      body: RefreshIndicator(
        color: primarycolor1,
        onRefresh: () => context.read<ContractorScheduleProvider>().fetchSchedules(),

        child: Consumer<ContractorScheduleProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return Center(child: CircularProgressIndicator(color: primarycolor1));
            }

            if (provider.schedules.isEmpty) {
              return CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Text(
                        "لا يوجد أي مواعيد",
                        style: TextStyle(fontSize: 20, color: primarycolor1),
                      ),
                    ),
                  ),
                ],
              );
            }

            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                padding: const EdgeInsets.all(15),
                itemCount: provider.schedules.length,

                itemBuilder: (context, index) {
                  final schedule = provider.schedules[index];

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),

                    child: Padding(
                      padding: const EdgeInsets.all(15),

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            schedule.day,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primarycolor1,
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(schedule.date),

                          const SizedBox(height: 6),

                          Text("${schedule.startTime}  -  ${schedule.endTime}"),

                          const SizedBox(height: 15),

                          Row(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.minPositive, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.white30,
                                    foregroundColor: primarycolor1,
                                  ),
                                  onPressed: () async {
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditSchedule(schedule: schedule),
                                      ),
                                    );

                                    provider.fetchSchedules();
                                  },
                                  child: Row(
                                    spacing: 5,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("تعديل", style: TextStyle(fontWeight: FontWeight.bold)),
                                      Icon(Icons.edit),
                                    ],
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.minPositive, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  backgroundColor: Colors.white30,
                                  foregroundColor: primarycolor1,
                                ),
                                onPressed: () async {
                                  final ok = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => AlertDialog(
                                      title: Text("تأكيد", textAlign: TextAlign.right),

                                      content: const Text(
                                        "هل تريد حذف هذا الموعد؟",
                                        textAlign: TextAlign.right,
                                      ),
                                      actions: [
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(150, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            backgroundColor: Colors.white30,
                                            foregroundColor: primarycolor1,
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: Text(
                                            "إلغاء",
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),

                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(double.minPositive, 50),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            backgroundColor: Colors.white30,
                                            foregroundColor: primarycolor1,
                                          ),
                                          onPressed: () => Navigator.pop(context, true),
                                          child: Text(
                                            "حذف",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );

                                  if (ok == true) {
                                    await provider.deleteSchedule(schedule.id);
                                    provider.fetchSchedules();
                                  }
                                },
                                child: Row(
                                  spacing: 5,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "حذف",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(Icons.delete, color: Colors.redAccent),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
