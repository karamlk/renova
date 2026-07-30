import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/Contractor/construction%20forms/create_construction_form.dart';
import 'package:renove_provider/providers/Contractor/construction%20forms/construction_form_provider.dart';
import 'package:renove_provider/screens/Contractor/construction%20forms/add_material_bottom_sheet.dart';

class CreateFormScreen extends StatefulWidget {
  final int reconstructionRequestId;
  final int contractorId;
  final int engineerId;

  const CreateFormScreen({
    super.key,
    required this.reconstructionRequestId,
    required this.contractorId,
    required this.engineerId,
  });

  @override
  State<CreateFormScreen> createState() => _CreateFormScreenState();
}

class _CreateFormScreenState extends State<CreateFormScreen> {
  final TextEditingController desccontroller = TextEditingController();
  final TextEditingController warrentycontroller = TextEditingController();
  final TextEditingController execcontroller = TextEditingController();
  final TextEditingController matcost = TextEditingController();
  final TextEditingController workcost = TextEditingController();
  final TextEditingController profit = TextEditingController();
  String selectedWUnit = 'شهر';
  String selectedEUnit = 'شهر';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("إعداد الاستمارة", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: GestureDetector(
        onTap: FocusScope.of(context).unfocus,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: ListView(
              children: [
                SizedBox(height: 5),
                TextField(
                  controller: desccontroller,
                  maxLines: 3,

                  maxLength: 100,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    label: Text("وصف البناء"),
                    labelStyle: TextStyle(color: primarycolor1),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                  ),
                ),
                SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: warrentycontroller,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text("فترة الضمان"),
                          labelStyle: TextStyle(color: primarycolor1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField(
                        initialValue: selectedWUnit,
                        decoration: InputDecoration(
                          label: Text("الوحدة"),
                          labelStyle: TextStyle(color: primarycolor1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'شهر', child: Text('شهر')),
                          DropdownMenuItem(value: 'سنة', child: Text('سنة')),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedWUnit = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextField(
                        controller: execcontroller,
                        maxLength: 2,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text("مدة التنفيذ"),
                          labelStyle: TextStyle(color: primarycolor1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField(
                        initialValue: selectedEUnit,
                        decoration: InputDecoration(
                          label: Text("الوحدة"),
                          labelStyle: TextStyle(color: primarycolor1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'شهر', child: Text('شهر')),
                          DropdownMenuItem(value: 'سنة', child: Text('سنة')),
                        ],
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedEUnit = newValue;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: matcost,

                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text("كلفة المواد"),
                          labelStyle: TextStyle(color: primarycolor1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "ل.س",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: workcost,

                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text("كلفة العمالة"),
                          labelStyle: TextStyle(color: primarycolor1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "ل.س",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: TextField(
                        controller: profit,

                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          label: Text("الأرباح"),
                          labelStyle: TextStyle(color: primarycolor1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "ل.س",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Consumer<InspectionFormProvider>(
                  builder: (context, value, child) {
                    if (value.pdfFile == null) {
                      return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          backgroundColor: Color(0xFF3b414c),
                          foregroundColor: Color(0xFFF59B4A),
                          disabledBackgroundColor: Color(0xFF3b414c),
                        ),
                        onPressed: value.pickPdf,
                        child: Text('رفع ملف PDF'),
                      );
                    }
                    return Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Card(
                            child: ListTile(title: Text(value.pdfFile!.path.split('/').last)),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            radius: 25,
                            child: IconButton(
                              onPressed: value.removePdf,
                              icon: Icon(Icons.delete, color: Colors.redAccent),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    backgroundColor: Color(0xFF3b414c),
                    foregroundColor: Color(0xFFF59B4A),
                    disabledBackgroundColor: Color(0xFF3b414c),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (_) => const AddMaterialBottomSheet(),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("إضافة مادة"),
                ),
                SizedBox(height: 20),
                Consumer<InspectionFormProvider>(
                  builder: (context, value, child) {
                    return Column(
                      children: List.generate(value.materials.length, (index) {
                        final meterial = value.materials[index];
                        return Card(
                          child: ListTile(
                            title: Text(meterial.materialName),
                            subtitle: Text("${meterial.quantity} ${meterial.unit}"),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                value.removeMaterial(index);
                              },
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ),
                SizedBox(height: 40),
                Consumer<InspectionFormProvider>(
                  builder: (context, value, child) => ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      backgroundColor: Color(0xFF3b414c),
                      foregroundColor: Color(0xFFF59B4A),
                      disabledBackgroundColor: Color(0xFF3b414c),
                    ),
                    onPressed: () async {
                      final provider = context.read<InspectionFormProvider>();
                      if (provider.pdfFile == null) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text("يرجى إرفاق ملف PDF")));
                        return;
                      }
                      if (provider.materials.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("يرجى إضافة مادة واحدة على الأقل")),
                        );
                        return;
                      }
                      final form = InspectionFormModel(
                        reconstructionRequestId: widget.reconstructionRequestId,
                        contractorId: widget.contractorId,
                        engineerId: widget.engineerId,

                        buildingDescription: desccontroller.text,

                        warrantyPeriod: "${warrentycontroller.text} $selectedWUnit",

                        executionDuration: "${execcontroller.text} $selectedEUnit",

                        materialsCost: double.tryParse(matcost.text) ?? 0,

                        laborCost: double.tryParse(workcost.text) ?? 0,

                        profit: double.tryParse(profit.text) ?? 0,

                        materials: provider.materials,
                      );
                      final response = await provider.submitInspection(form);
                      if (response == null) return;

                      final result = jsonDecode(response.body);
                      print(response.body);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result["message"]),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      if (response.statusCode == 200 || response.statusCode == 201) {
                        Navigator.pop(context);
                      }
                    },
                    child: value.isLoading
                        ? CircularProgressIndicator(color: primarycolor1)
                        : Text("إرسال الاستمارة", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
