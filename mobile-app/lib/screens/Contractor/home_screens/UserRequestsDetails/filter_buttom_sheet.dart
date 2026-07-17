import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/providers/Contractor/user_requests_provider.dart';

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
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: primarycolor1),
          ),
          const SizedBox(height: 25),
          Directionality(
            textDirection: TextDirection.rtl,
            child: TextField(
              controller: locationController,
              textDirection: TextDirection.rtl,

              decoration: InputDecoration(
                labelStyle: TextStyle(color: primarycolor1),
                labelText: "الموقع",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Directionality(
            textDirection: TextDirection.rtl,
            child: DropdownMenu<String>(
              inputDecorationTheme: InputDecorationTheme(
                labelStyle: TextStyle(color: primarycolor1),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              width: double.infinity,
              label: Text('اختر النوع'),

              menuHeight: 250,

              menuStyle: MenuStyle(
                shape: WidgetStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                fixedSize: WidgetStatePropertyAll(Size(100, 200)),
              ),
              initialSelection: selectedType,
              dropdownMenuEntries: [
                DropdownMenuEntry(value: "construction", label: "Construction"),
                DropdownMenuEntry(value: "restoration", label: "Restoration"),
                DropdownMenuEntry(value: "finishing", label: "Finishing"),
              ],
              onSelected: (value) {
                selectedType = value;
              },
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
        ],
      ),
    );
  }
}
