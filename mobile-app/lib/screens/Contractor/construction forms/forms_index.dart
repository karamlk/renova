import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/Contractor/construction%20forms/forms_index.dart';
import 'package:renove_provider/providers/Contractor/construction%20forms/construction_form_provider.dart';
import 'package:renove_provider/screens/Contractor/construction%20forms/construction_form_details.dart';
import 'package:renove_provider/screens/Contractor/construction%20forms/update_form_screen.dart';

class ContractorIndexFormsScreen extends StatefulWidget {
  const ContractorIndexFormsScreen({super.key});

  @override
  State<ContractorIndexFormsScreen> createState() => _ContractorFormsScreenState();
}

class _ContractorFormsScreenState extends State<ContractorIndexFormsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InspectionFormProvider>().fetchForms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الاستمارات")),
      body: RefreshIndicator(
        onRefresh: () => context.read<InspectionFormProvider>().fetchForms(),
        color: primarycolor1,
        child: Consumer<InspectionFormProvider>(
          builder: (_, provider, __) {
            if (provider.isFormsLoading) {
              return Center(child: CircularProgressIndicator(color: primarycolor1));
            }

            if (provider.forms.isEmpty) {
              return const Center(child: Text("لا توجد استمارات"));
            }

            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(15, 15, 15, 100),
              itemCount: provider.forms.length,
              itemBuilder: (_, index) {
                final form = provider.forms[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            form.reconstructionRequest.title,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          ),

                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("الموقع :"), Text(form.reconstructionRequest.location)],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("النوع:"), Text(form.reconstructionRequest.type)],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("الحالة:"), Text(form.status)],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("الإجمالي:"), Text(form.totalCost)],
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text("المهندس:"), Text(form.engineer.name)],
                          ),

                          const SizedBox(height: 15),

                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Color(0xFF3b414c),
                                    foregroundColor: Color(0xFFF59B4A),
                                    disabledBackgroundColor: Color(0xFF3b414c),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            ConstructionFormDetailsScreen(formId: form.id),
                                      ),
                                    );
                                  },
                                  child: Text("عرض", style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                              ),

                              const SizedBox(width: 10),

                              const SizedBox(width: 10),

                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Color(0xFF3b414c),
                                    foregroundColor: Color(0xFFF59B4A),
                                    disabledBackgroundColor: Color(0xFF3b414c),
                                  ),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text('حذف الاستمارة', textAlign: TextAlign.right),
                                        content: Text(
                                          "هل أنت متاكد من حذف هذه الاستمارة؟",
                                          textAlign: TextAlign.right,
                                        ),
                                        actions: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  backgroundColor: Color(0xFF3b414c),
                                                  foregroundColor: Color(0xFFF59B4A),
                                                  disabledBackgroundColor: Color(0xFF3b414c),
                                                ),
                                                onPressed: () async {
                                                  final response = await context
                                                      .read<InspectionFormProvider>()
                                                      .deleteForm(reconstructionRequestId: form.id);
                                                  if (response == null || !context.mounted) return;

                                                  final result = jsonDecode(response.body);
                                                  final text = result['message'] ?? result['error'];

                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        text.toString(),
                                                        textDirection: TextDirection.rtl,
                                                        textAlign: TextAlign.right,
                                                      ),
                                                    ),
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text(
                                                  "حذف",
                                                  style: TextStyle(color: Colors.redAccent),
                                                ),
                                              ),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  backgroundColor: Color(0xFF3b414c),
                                                  foregroundColor: Color(0xFFF59B4A),
                                                  disabledBackgroundColor: Color(0xFF3b414c),
                                                ),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text("إلغاء"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "حذف",
                                    style: TextStyle(
                                      color: Colors.redAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
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
        ),
      ),
    );
  }
}
