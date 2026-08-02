import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/Inspection/inspection_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';
import 'package:renove_provider/screens/Contractor/construction%20forms/create_form_screen.dart';

class ShowInspectionRequest extends StatefulWidget {
  const ShowInspectionRequest({super.key});

  @override
  State<ShowInspectionRequest> createState() => _ShowInspectionRequestState();
}

class _ShowInspectionRequestState extends State<ShowInspectionRequest>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ContractorInspectionRequestsProvider>().fetchRequests();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("جدول الزيارات", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: RefreshIndicator(
        color: primarycolor1,
        onRefresh: () => context.read<ContractorInspectionRequestsProvider>().fetchRequests(),
        child: Consumer<ContractorInspectionRequestsProvider>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return Center(child: CircularProgressIndicator(color: primarycolor1));
            }
            if (value.requests.isEmpty) {
              return const Center(child: Text("لا توجد طلبات", style: TextStyle(fontSize: 20)));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(20),

              itemCount: value.requests.length,

              itemBuilder: (context, index) {
                final item = value.requests[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: Card(
                    color: context.watch<ThemeProvider>().isDark
                        ? primarycolor2
                        : Colors.grey.shade300,

                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        spacing: 10,
                        children: [
                          Text(
                            item.request.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            textDirection: TextDirection.rtl,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.request.location,
                                style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                              ),
                              const Text(":الموقع"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.request.type,
                                style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                              ),
                              const Text(":النوع"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.schedule.day,
                                style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                              ),
                              const Text(":اليوم"),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${item.schedule.startTime} - ${item.schedule.endTime}",
                                style: TextStyle(color: primarycolor1, fontWeight: FontWeight.bold),
                              ),
                              const Text(":الموعد"),
                            ],
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CreateFormScreen(
                                    reconstructionRequestId: item.inspectionRequestId,
                                    contractorId: item.contractorId,
                                    engineerId: item.engineerId!,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.white30,
                              foregroundColor: primarycolor1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "إعداد الاستمارة",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
