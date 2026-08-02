import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:renove_provider/extras/theme.dart';
import 'package:renove_provider/models/Contractor/construction%20forms/create_construction_form.dart';
import 'package:renove_provider/models/Contractor/construction%20forms/forms_index.dart';
import 'package:renove_provider/providers/Contractor/construction%20forms/construction_form_provider.dart';
import 'package:renove_provider/screens/Contractor/construction%20forms/add_material_bottom_sheet.dart';

class UpdateFormScreen extends StatefulWidget {
  final ConstructionFormDetails form;
  final int constructionId;
  final int contractorId;
  final int engineerId;
  const UpdateFormScreen({
    super.key,
    required this.constructionId,
    required this.form,
    required this.contractorId,
    required this.engineerId,
  });

  @override
  State<UpdateFormScreen> createState() => _CreateFormScreenState();
}

class _CreateFormScreenState extends State<UpdateFormScreen> {
  late final TextEditingController buildingDescriptionController;
  late final TextEditingController warrantyController;
  late final TextEditingController executionController;
  late final TextEditingController materialsCostController;
  late final TextEditingController laborCostController;
  late final TextEditingController profitController;
  String selectedWUnit = 'شهر';
  String selectedEUnit = 'شهر';

  @override
  void initState() {
    super.initState();
    final form = widget.form;
    buildingDescriptionController = TextEditingController(text: form.buildingDescription);

    final wParts = form.warrantyPeriod.trim().split(' ');
    warrantyController = TextEditingController(text: wParts.isNotEmpty ? wParts[0] : '');
    if (wParts.length > 1) {
      selectedWUnit = _normalizeUnit(wParts[1]);
    }

    final eParts = form.executionDuration.trim().split(' ');
    executionController = TextEditingController(text: eParts.isNotEmpty ? eParts[0] : '');
    if (eParts.length > 1) {
      selectedEUnit = _normalizeUnit(eParts[1]);
    }

    materialsCostController = TextEditingController(text: form.materialsCost);

    laborCostController = TextEditingController(text: form.laborCost);

    profitController = TextEditingController(text: form.profit);
    final provider = context.read<InspectionFormProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final material in form.materials) {
        if (!mounted) return;
        final provider = context.read<InspectionFormProvider>();
        provider.addMaterial(
          MaterialModel(
            materialName: material.materialName,
            materialType: material.materialType,
            quantity: material.quantity.toInt(),
            unit: material.unit,
            unitPrice: material.unitPrice.toDouble(),
          ),
        );
      }
    });
  }

  String _normalizeUnit(String rawUnit) {
    if (rawUnit.contains('month') || rawUnit.contains('شهر')) {
      return 'شهر';
    } else if (rawUnit.contains('year') || rawUnit.contains('سنة')) {
      return 'سنة';
    }
    return 'شهر';
  }

  @override
  void dispose() {
    buildingDescriptionController.dispose();
    warrantyController.dispose();
    executionController.dispose();
    materialsCostController.dispose();
    laborCostController.dispose();
    profitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text("تعديل الاستمارة", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  controller: buildingDescriptionController,
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
                        controller: warrantyController,
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
                        controller: executionController,
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
                        controller: materialsCostController,

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
                        controller: laborCostController,

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
                        controller: profitController,

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
                        reconstructionRequestId: widget.form.reconstructionRequestId,
                        contractorId: widget.form.contractorId,
                        engineerId: widget.form.engineerId,

                        buildingDescription: buildingDescriptionController.text,

                        warrantyPeriod: "${warrantyController.text} $selectedWUnit",

                        executionDuration: "${executionController.text} $selectedEUnit",

                        materialsCost: double.tryParse(materialsCostController.text) ?? 0,

                        laborCost: double.tryParse(laborCostController.text) ?? 0,

                        profit: double.tryParse(profitController.text) ?? 0,

                        materials: provider.materials,
                      );
                      final response = await provider.updateInspection(
                        id: widget.constructionId,
                        form: form,
                      );

                      if (response == null) return;

                      final result = jsonDecode(response.body);

                      print(response.statusCode);
                      print(response.body);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(result.toString()),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                      if (response.statusCode == 200 || response.statusCode == 201) {
                        Navigator.pop(context);
                      } else {}
                    },
                    child: value.isLoading
                        ? CircularProgressIndicator(color: primarycolor1)
                        : Text("حفظ التعديلات", style: TextStyle(fontWeight: FontWeight.bold)),
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
