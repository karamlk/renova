import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/user_requests_provider.dart';
import 'package:renove_provider/providers/theme_provider.dart';

class FilterButtomSheet extends StatefulWidget {
  const FilterButtomSheet({super.key});

  @override
  State<FilterButtomSheet> createState() => _FilterButtomSheetState();
}

class _FilterButtomSheetState extends State<FilterButtomSheet> {
  final locationController = TextEditingController();
  String? selectedType;

  final List<String> types = ["construction", "restoration", "finishing"];
  @override
  Widget build(BuildContext context) {
    final provider = context.read<ContractorRequestsProvider>();
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "إدخال فلتر",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: context.watch<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
            ),
          ),
          const SizedBox(height: 25),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              controller: locationController,
              textDirection: TextDirection.rtl,

              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                ),
                labelText: "الموقع",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Directionality(
            textDirection: TextDirection.rtl,
            child: DropdownButtonFormField<String>(
              decoration: InputDecoration(
                label: Text("اختر النوع"),
                hint: Text("اختر النوع"),

                labelStyle: TextStyle(
                  color: context.watch<ThemeProvider>().isDark ? primarycolor1 : primarycolor2,
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
              ),

              initialValue: selectedType,
              items: [
                DropdownMenuItem(value: 'construction', child: Text('Construction')),
                DropdownMenuItem(value: 'restoration', child: Text('Restoration')),
                DropdownMenuItem(value: 'finishing', child: Text('Finishing')),
              ],
              onChanged: (value) => selectedType = value,
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: primarycolor2,
              foregroundColor: primarycolor1,
            ),
            onPressed: () async {
              Navigator.pop(context);

              await provider.fetchRequests(location: locationController.text, type: selectedType);
            },
            child: const Text("تطبيق الفلتر", style: TextStyle(fontWeight: FontWeight.bold)),
          ),

          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: Size(200, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              backgroundColor: primarycolor2,
              foregroundColor: primarycolor1,
            ),
            onPressed: () async {
              Navigator.pop(context);

              await provider.fetchRequests();
            },
            child: const Text("إزالة الفلتر"),
          ),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
